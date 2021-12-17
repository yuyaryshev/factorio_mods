data:extend{
  {
    type = "technology",
    name = "basic-planning",
    icon = "__basic-planner__/graphics/icons/planner-paper.png",
    prerequisites = {""},
    unit =
    {
      count = 10,
      ingredients =
      {
        {"science-pack-1", 1},
      },
      time = 10
    },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "planner-1x1"
      },
      {
        type = "unlock-recipe",
        recipe = "planner-1x1-round"
      },
      {
        type = "unlock-recipe",
        recipe = "planner-1x1-triangle"
      },
      {
        type = "unlock-recipe",
        recipe = "planner-paper"
      },
      {
        type = "unlock-recipe",
        recipe = "planner-2x2"
      },
      {
        type = "unlock-recipe",
        recipe = "planner-3x3"
      },
      {
        type = "unlock-recipe",
        recipe = "planner-4x4"
      },
      {
        type = "unlock-recipe",
        recipe = "planner-5x5"
      },
    },
    order = "c-i",
  },
}
