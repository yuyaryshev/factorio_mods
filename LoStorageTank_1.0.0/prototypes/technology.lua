data:extend({
  {
    type = "technology",
    name = "adv-fluid-storage",
    icon = "__LoStorageTank__/graphics/icon/lo-storage-tank big.png",
    icon_size = 64,
    prerequisites = {"fluid-handling"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "lo-storage-tank",
      },
      {
        type = "unlock-recipe",
        recipe = "lo-storage-tank2",
      },
      {
        type = "unlock-recipe",
        recipe = "lo-storage-tank3",
      }
    },
    unit =
    {
      count = 200,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
      },
      time = 20
    },
    order = "d-a-a"
  }
})
