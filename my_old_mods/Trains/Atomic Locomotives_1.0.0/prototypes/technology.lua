data:extend({
  {
    type = "technology",
    name = "atomic-locomotives",
    icon = "__Atomic Locomotives__/graphics/technology/atomic-locomotive.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "atomic-locomotive"
      },
      {
        type = "unlock-recipe",
        recipe = "atomic-shuttle"
      }
    },
    prerequisites = {"rtg-equipment", "railway"},
    unit =
    {
      count = 150,
      ingredients =
      {
        {"science-pack-1", 2},
        {"science-pack-2", 1}
      },
      time = 15
    },
    order = "c-g-e"
  }
})