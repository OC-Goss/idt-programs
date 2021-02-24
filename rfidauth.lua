-- RFID authentication for EEPROMs and rolldoors

local function get(typ)
  return component.proxy((component.list(typ, true)()))
end

local rolldoor = get("os_rolldoorcontroller")
local rfid = get("os_rfidreader")

rolldoor.setSpeed(10)
local is_in_vicinity = false
while true do
  computer.pullSignal(1)
  local data = rfid.scan(6)
  if data then
    is_in_vicinity = false
    for i=1, #data, 1 do
      if data[i].name == "username" and data[i].data == 
          "AUTHSTRING" and data[i].locked then
        is_in_vicinity = true
        rolldoor.open()
      end
    end
  end
  if not is_in_vicinity then
    rolldoor.close()
  end
end
