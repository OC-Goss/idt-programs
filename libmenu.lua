-- decent-looking menus for OpenComputers

local gpu = require("component").gpu
local text = require("text")
local event = require("event")
local w, h = gpu.getResolution()

local menu = {}

local function redraw(menu)
  gpu.setForeground(self.fg or 0xFFFFFF)
  gpu.setBackground(self.bg or 0x000000)
  gpu.fill(1, 1, w, h, " ")
  if menu.title then
    gpu.set(2, 1, menu.title)
  end
  for i=1, math.min(h - 4, #menu.items), 1 do
    if menu.selected == i then
      gpu.setForeground(self.bg or self.sfg or 0x000000)
      gpu.setBackground(self.fg or self.sbg or 0xFFFFFF)
    else
      gpu.setForeground(self.fg or 0xFFFFFF)
      gpu.setBackground(self.bg or 0x000000)
    end
    if menu.items[i].disabled then
      gpu.setForeground(0xAAAAAA)
    end
    gpu.set(2, i + 2, text.padRight(menu.items[i].text:sub(1, w - 4), w - 4))
  end
end

function menu:select()
  self.selected = self.selected or 1
  while true do
    redraw(self)
    local _, _, char, code = event.pull("key_down")
    if code == 200 then -- up
      if self.selected <= 1 then
        self.selected = #self.items
      else
        self.selected = self.selected - 1
      end
    elseif code == 208 then -- down
      if self.selected >= self.items then
        self.selected = 1
      else
        self.selected = self.selected + 1
      end
    elseif char == 13 and not self.items[self.selected].disabled then -- enter
      return self.items[self.selected].text
    end
  end
end

function menu:addOption(text)
  self.items[#self.items + 1] = {text=text,disabled=false}
  return #self.items
end

function menu:setOptions(items)
  checkArg(1, items, "table")
  self.items = items
end

function menu:enableOption(n)
  checkArg(1, n, "number")
  self.items[n].disabled = false
end

function menu:disableOption(n)
  checkArg(1, n, "number")
  self.items[n].disabled = true
end

local lib = {}

function lib.new(items)
  checkArg(1, items, "table", "nil")
  items = items or {}
  for k, v in pairs(items) do
    items[k] = {text = items[k], disabled = false}
  end
  return setmetatable({
    items = items or {},
    title = "Menu",
  }, {__index = menu})
end

return lib
