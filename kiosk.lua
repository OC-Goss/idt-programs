-- kiosk program
-- this may or may not abuse the payment library i wrote

local config = require("kioskconfig")
local libpayment = require("libpayment")
local menu = require("libmenu")
local component = require("component")

local payment = libpayment.new(component.get(config.payment.transposer))
payment:setPaymentFrom(config.payment.input)
payment:setPaymentTo(config.payment.output)
payment:setPaymentItem(config.payment.item, config.payment.damage)

local menuitems = {}
local map = {}

for k, v in pairs(config.products) do
  menuitems[#menuitems + 1] = v.name
  local tp = component.get(v.transposer)
  map[v.name] = {
    transfer = libpayment.new(tp)
      :setPaymentFrom(v.input)
      :setPaymentTo(v.output)
      :setPaymentItem(k, v.damage),
    item = v,
    type = "product"
  }
end

for k, v in pairs(config.services) do
  menuitems[#menuitems + 1] = v.name
  local itp = component.get(v.input.transposer)
  local otp = component.get(v.output.transposer)
  local input = libpayment.new(itp)
    :setPaymentFrom(v.input.input)
    :setPaymentTo(v.input.output)
  local output = libpayment.new(otp)
    :setPaymentFrom(v.output.input)
    :setPaymentTo(v.input.output)
  map[v.name] = {
    input = input,
    output = output,
    data = v,
    type = "service"
  }
end

local function getproduct(item)
  local ok, err = payment:getPayment()
end

local function getservice(item)
  
end

local menu = libmenu.new(menuitems)
menu.title = "Total Cost: 0"

local view = "View Purchases"
local chkt = "Check Out"
menu:addOption(view)
menu:addOption(chkt)

while not event.pull("interrupted") do
  local item = menu:select()
  if item == chkt then
    for k, v in pairs(selected) do
      local item = map[v]
      if item.type == "product" then
        getproduct(item)
      else
        getservice(item)
      end
    end
  elseif item == view then
    
  else
    item = map[item]
    total = total + item.cost
    selected[#selected + 1] = item
  end
end
