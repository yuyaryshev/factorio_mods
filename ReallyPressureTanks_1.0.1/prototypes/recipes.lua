data:extend(
{
  {
    type = "recipe",
    name = "high-overflow-valve",
    energy_required = 2,
    enabled = false,
    ingredients =
    {
      {"electronic-circuit", 1},
      {"steel-plate", 1},
      {"iron-gear-wheel", 1},
      {"pipe", 1}
    },
    result = "high-overflow-valve"
  },
  {
    type = "recipe",
    name = "high-underflow-valve",
    energy_required = 2,
    enabled = false,
    ingredients =
    {
      {"electronic-circuit", 1},
      {"steel-plate", 1},
      {"iron-gear-wheel", 1},
      {"pipe", 1}
    },
    result = "high-underflow-valve"
  },
  {
    type = "recipe",
    name = "high-pipe",
    energy_required = 0.002,
    enabled = true,
    ingredients =
    {
      {"pipe", 1},
    },
    result = "high-pipe"
  },
})