table.insert(data.raw.technology["advanced-material-processing-2"].effects,{type = "unlock-recipe", recipe = "5d-furnace"})

  --[[{
    type = "technology",
    name = "advanced-material-processing-2",
    icon = "__base__/graphics/technology/advanced-material-processing.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "5d-furnace"
      },
      {
        type = "unlock-recipe",
        recipe = "electric-furnace"
      }
    },
    prerequisites = {"advanced-material-processing"},
    unit =
    {
      count = 150,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
      },
      time = 30
    },
    order = "c-c-a"
  },]]

data:extend({
	{
		type = "technology",
		name = "masher",
		icon = "__5dim_resources__/graphics/icon/masher.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "5d-copper-plate"
			},
			{
				type = "unlock-recipe",
				recipe = "5d-iron-plate"
			},
			{
				type = "unlock-recipe",
				recipe = "5d-iron-dust"
			},
			{
				type = "unlock-recipe",
				recipe = "5d-copper-dust"
			},
			{
				type = "unlock-recipe",
				recipe = "5d-masher"
			},
		},
		prerequisites = {"electronics", "automation"},
		unit =
		{
			count = 50,
			ingredients = 
			{
				{"science-pack-1", 1},
				{"science-pack-2", 1},				
			},
			time = 5
		},
		order = "c-a"
	},
	{
		type = "technology",
		name = "masher-2",
		icon = "__5dim_resources__/graphics/icon/masher.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "5d-masher-2"
			},
		},
		prerequisites = {"masher"},
		unit =
		{
			count = 100,
			ingredients = 
			{
				{"science-pack-1", 1},
				{"science-pack-2", 1},
				{"science-pack-3", 1},
			},
			time = 5
		},
		order = "c-a"
	},
  {
    type = "technology",
    name = "advanced-material-processing-3",
    icon = "__base__/graphics/technology/advanced-material-processing.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "5d-electric-furnace"
      }
    },
    prerequisites = {"advanced-material-processing-2", "advanced-electronics"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
      },
      time = 30
    },
    order = "c-c-b"
  },
})