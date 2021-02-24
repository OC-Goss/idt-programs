-- example kiosk configuration

return {
  products = {
    ["minecraft:redstone_dust"] = {
      name = "Redstone Dust",
      damage = 0,
      count = 16,
      cost = 1,
      transposer = "4eac3", -- the transposer address - can be truncated
      input = 4, -- the input side
      output = 2, -- the output side
    },
  },
  services = {
    {
      name = "Process Ores",
      type = "process", -- pull items into a machine through one transposer
                        -- and out through another
      input = {
        transposer = "83ac0",
        input = 5,
        output = 1,
      },
      output = {
        transposer = "427ca",
        input = 1,
        output = 5,
      },
      count = 64,
      cost = 2 -- 2 payment per $(count) input items
    }
  },
  payment = {
    item = "minecraft:diamond",
    name = "Diamond",
    damage = 0,
    transposer = "57f2",
    input = 3, -- the chest where the user puts payment
    output = 0 -- the chest where the system stores payment
  }
  
}
