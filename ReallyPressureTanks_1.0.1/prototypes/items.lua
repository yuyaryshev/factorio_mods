data:extend(
{
  {
    type = "item",
    name = "high-overflow-valve",
    icon = "__ReallyPressureTanks__/graphics/icon/high-overflow-valve.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-c[pump]b",
    place_result = "high-overflow-valve",
    stack_size = 50
  },
  {
    type = "item",
    name = "high-underflow-valve",
    icon = "__ReallyPressureTanks__/graphics/icon/high-underflow-valve.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-c[pump]bb",
    place_result = "high-underflow-valve",
    stack_size = 50
  },
  {
    type = "item",
    name = "high-pipe",
    icon = "__ReallyPressureTanks__/graphics/icon/high-pipe.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-c[pump]bbb",
    place_result = "high-pipe",
    stack_size = 50
  },  
})