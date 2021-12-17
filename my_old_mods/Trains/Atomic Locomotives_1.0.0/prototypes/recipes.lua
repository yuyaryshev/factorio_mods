data:extend({
  {
    type = "recipe",
    name = "atomic-locomotive",
    enabled = false,
    ingredients =
    {
      {"electric-engine-unit", 40},
      {"depleted-uranium", 32},
      {"steel-plate", 40},
      {"plutonium", 16},
    },
    result = "atomic-locomotive",
  },
  {
    type = "recipe",
    name = "atomic-shuttle",
    enabled = false,
    ingredients =
    {
      {"atomic-locomotive", 1}
    },
    result = "atomic-shuttle",
  }
})