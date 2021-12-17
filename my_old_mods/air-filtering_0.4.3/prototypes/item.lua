data:extend({
  {
    type = "item",
    name = "air-filter-machine",
    icon = "__air-filtering__/graphics/icons/air-filter-machine.png",
    flags = { "goes-to-quickbar" },
    subgroup = "production-machine",
    order = "f[air-filter-machine]",
    place_result = "air-filter-machine",
    stack_size = 10
  },
  {
    type = "item",
    name = "air-filter-machine-mk2",
    icon = "__air-filtering__/graphics/icons/air-filter-machine-mk2.png",
    flags = { "goes-to-quickbar" },
    subgroup = "production-machine",
    order = "f[air-filter-machine]-g[air-filter-machine-mk2]",
    place_result = "air-filter-machine-mk2",
    stack_size = 10
  },
  {
    type = "item",
    name = "air-filter-machine-mk3",
    icon = "__air-filtering__/graphics/icons/air-filter-machine-mk3.png",
    flags = { "goes-to-quickbar" },
    subgroup = "production-machine",
    order = "g[air-filter-machine-mk2]-h[air-filter-machine-mk3]",
    place_result = "air-filter-machine-mk3",
    stack_size = 10
  },
  {
    type = "item",
    name = "unused-air-filter",
    icon = "__air-filtering__/graphics/icons/unused-air-filter.png",
    flags = { "goes-to-main-inventory" },
    subgroup = "raw-material",
    order = "g[plastic-bar]-h[unused-air-filter]",
    stack_size = 50
  },
  {
    type = "item",
    name = "used-air-filter",
    icon = "__air-filtering__/graphics/icons/used-air-filter.png",
    flags = { "goes-to-main-inventory" },
    subgroup = "raw-material",
    order = "h[unused-air-filter]-i[used-air-filter]",
    stack_size = 50
  }
})
