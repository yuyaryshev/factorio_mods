data:extend({
  {
    type = "recipe-category",
    name = "crafting-air-filter"
  },
  {
    type = "recipe",
    name = "air-filter-machine",
    icon = "__air-filtering__/graphics/icons/air-filter-machine.png",
    energy_required = 10.0,
    enabled = "false",
    ingredients =
    {
      {"assembling-machine-2", 1},
      {"electronic-circuit", 5},
      {"steel-plate", 10}
    },
    result = "air-filter-machine"
  },
  {
    type = "recipe",
    name = "air-filter-machine-mk2",
    icon = "__air-filtering__/graphics/icons/air-filter-machine-mk2.png",
    energy_required = 10.0,
    enabled = "false",
    ingredients =
    {
      {"air-filter-machine", 2},
      {"electronic-circuit", 10}
    },
    result = "air-filter-machine-mk2"
  },
  {
    type = "recipe",
    name = "air-filter-machine-mk3",
    icon = "__air-filtering__/graphics/icons/air-filter-machine-mk3.png",
    energy_required = 10.0,
    enabled = "false",
    ingredients =
    {
      {"air-filter-machine-mk2", 2},
      {"advanced-circuit", 10}
    },
    result = "air-filter-machine-mk3"
  },
  {
    type = "recipe",
    name = "unused-air-filter",
    icon = "__air-filtering__/graphics/icons/unused-air-filter.png",
    category = "crafting",
    subgroup = "raw-material",
    order = "f[plastic-bar]-f[unused-air-filter]",
    energy_required = 5,
    enabled = "false",
    ingredients =
    {
      {"coal", 10},
      {"iron-plate", 1}
    },
    result = "unused-air-filter"
  },
  {
    type = "recipe",
    name = "filter-air",
    icon = "__air-filtering__/graphics/icons/filter-air.png",
    category = "crafting-air-filter",
    order = "f[plastic-bar]-f[filter-air]",
    energy_required = 100,
    enabled = "false",
    ingredients =
    {
      {"unused-air-filter", 1}
    },
    result = "used-air-filter"
  },
  {
    type = "recipe",
    name = "air-filter-recycling",
    icon = "__air-filtering__/graphics/icons/air-filter-recycling.png",
    category = "crafting",
    subgroup = "raw-material",
    order = "f[unused-air-filter]-f[air-filter-recycling]",
    energy_required = 5,
    enabled = "false",
    ingredients =
    {
      {"used-air-filter", 1}
    },
    result = "unused-air-filter"
  }
})
