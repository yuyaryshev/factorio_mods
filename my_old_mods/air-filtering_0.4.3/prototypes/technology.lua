data:extend({
  {
    type = "technology",
    name = "air-filtering",
    icon = "__air-filtering__/graphics/technology/air-filtering.png",
    prerequisites = {"plastics", "steel-processing", "advanced-electronics"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "air-filter-machine"
      },
      {
        type = "unlock-recipe",
        recipe = "filter-air"
      },
      {
        type = "unlock-recipe",
        recipe = "unused-air-filter"
      }
    },
    unit =
    {
      count = 20,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1}
      },
      time = 10
    },
    order = "d-a-a"
  },
  {
    type = "technology",
    name = "air-filtering-mk2",
    icon = "__air-filtering__/graphics/technology/air-filtering.png",
    prerequisites = {"air-filtering"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "air-filter-machine-mk2"
      }
    },
    unit =
    {
      count = 100,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1}
      },
      time = 60
    },
    order = "d-a-a"
  },
  {
    type = "technology",
    name = "air-filtering-mk3",
    icon = "__air-filtering__/graphics/technology/air-filtering.png",
    prerequisites = {"air-filtering-mk2"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "air-filter-machine-mk3"
      }
    },
    unit =
    {
      count = 200,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
      },
      time = 60
    },
    order = "d-a-a"
  },
  {
    type = "technology",
    name = "air-filter-recycling",
    icon = "__air-filtering__/graphics/technology/air-filter-recycling.png",
    prerequisites = {"air-filtering"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "air-filter-recycling"
      }
    },
    unit =
    {
      count = 50,
      ingredients = {{"science-pack-1", 1}, {"science-pack-2", 1}},
      time = 20
    },
    order = "d-a-a"
  }
})
