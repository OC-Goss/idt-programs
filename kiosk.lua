-- kiosk program

local config = require("kioskconfig")
local libpayment = require("libpayment")
local menu = require("libmenu")

while not event.pull("interrupted") do
end
