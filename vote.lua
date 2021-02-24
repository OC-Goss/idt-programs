-- voting software, sort of --

local event = require("event")
local tutils = require("text")
local gpu = require("component").gpu
local w, h = gpu.getResolution()
require("process").info().data.signal = function() end
local exit = false
local config = dofile("votes.cfg")

local function draw(items, selected, title)
  if title then gpu.fill(1, 1, w, 1, " ") gpu.set(1, 1, title) end
  for i=1, #items, 1 do
    if selected == i then
      gpu.setForeground(0x000000)
      gpu.setBackground(0xFFFFFF)
    else
      gpu.setForeground(0xFFFFFF)
      gpu.setBackground(0x000000)
    end
    gpu.set(2, 2, tutils.padLeft(items[i], w - 2))
  end
end

local function menu(items, title)
  local selected = 1
  local current_player
  draw(items, selected, title)
  while true do
    draw(items, selected)
    local _, _, key, code, player = event.pull("key_down")
    if exit then return nil end
    current_player = player
    if code == 200 then -- up
      if selected == 1 then
        selected = #items
      else
        selected = selected - 1
      end
    elseif code == 208 then -- down
      if selected == #items then
        selected = 1
      else
        selected = selected + 1
      end
    elseif key == 13 then
      gpu.fill(1, 1, w, h, " ")
      return selected, current_player
    end
  end
end

local log = io.open("log.txt", "w")
local votes = {}
local cast = {}
local runners = {}
for i=1, #config.runners, 1 do
  runners[i] = config.runners[i]
  votes[runners[i]] = 0
end

local yesno = {
  "Yes",
  "No"
}

--          minutes -> seconds
event.timer(config.duration * 60, function() exit = true end)

while not exit do
  local selection, user
  ::restart::
  selection, user = menu(runners, "Select a candidate:")
  if not selection then break end
  if votes[user] then
    if runners[selection] == user then
      print("You cannot vote for yourself!")
      os.sleep(1)
      goto restart
    end
  end
  if cast[user] then
    local change = menu(yesno, "Change your vote to " .. runners[selection] .. "?")
    if change == 2 then
      goto restart
    end
  end
  cast[user] = runners[selection]
  log:write(os.date(), ": ", tostring(user).." voted for "
                                      ..tostring(runners[selection]))
end

log:close()

print("\27[2JCounting votes")

local winner, win_votes = nil, 0
for k, v in pairs(cast) do
  votes[v] = votes[v] + 1
end

for k, v in pairs(votes) do
  if v > win_votes then
    win_votes = v
    winner = k
  end
end

print("The winner is: " .. winner)
