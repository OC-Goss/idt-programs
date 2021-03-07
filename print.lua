-- print things --

local p = require("component").openprinter

local file, name = ...

if not file then
  io.stderr:write("usage: print FILE [NAME]\n")
  os.exit(1)
end

name = name or file
local handle = assert(io.open(file, "r"))
p.clear()
local page = 1
p.setTitle(name .. " 1")

local nlines = 0
for line in handle:lines() do
  if #line > 20
end
