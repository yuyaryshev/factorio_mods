data:extend({
  {
    type = "module",
    name = "5d-speed-effectivity-4",
    icon = "__5dim_module__/graphics/icon/av4.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "module-4",
    order = "a",
    category = "speed",
    tier = 4,
    stack_size = 50,
    default_request_amount = 10,
    effect = { speed = {bonus = 0.6}, consumption = {bonus = 0.2}}
  },

--Recipe
  {
    type = "recipe",
    name = "5d-speed-effectivity-4",
    enabled = false,
	category = "welding",
    ingredients =
    {
      {"5d-speed-module-4", 1},
      {"5d-effectivity-module-4", 1},
    },
    energy_required = 90,
    result = "5d-speed-effectivity-4"
  },

--Entity
})