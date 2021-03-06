-- payment library for OpenComputers.

local obj = {}

function obj:setPaymentFrom(side)
  checkArg(1, side, "number")
  assert(side >= 0 and side <= 5, "invalid side")
  self.from = side
  return self
end

function obj:setPaymentTo(side)
  checkArg(1, side, "number")
  assert(side >= 0 and side <= 5, "invalid side")
  self.to = side
  return self
end

function obj:setPaymentItem(item, dmg)
  dmg = dmg or 0
  checkArg(1, item, "string")
  checkArg(2, dmg, "number")
  self.item = {name = item, damage = dmg}
  return self
end

function obj:getPayment(n)
  checkArg(1, n, "number")
  local item = self.tp.getStackInSlot(self.from, 1)
  if (self.item.item) and (not item) or (item.damage ~= self.item.damage) or
     (item.name ~= self.item.name) or (item.size < n) then
    return nil, "invalid payment"
  end
  local i = 0
  while i < n do
    i = i + self.tp.transferItem(self.from, self.to, n - i)
  end
  return true
end

return {new=function(tp)
  return setmetatable({tp=component.proxy(tp)}, {__index = obj})
end}
