data:extend({
	{
		type = "technology",
		name = "automation-4",
		icon = "__base__/graphics/technology/automation.png",
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "5d-assembling-machine-4"
			},
		},
		prerequisites = {"automation-3"},
		unit =
		{
			count = 150,
			ingredients =
				{
					{"science-pack-1", 2},
					{"science-pack-2", 1},
					{"science-pack-3", 1}
				},
			time = 70
		},
		order = "c-a"
	},
	{
		type = "technology",
		name = "automation-5",
		icon = "__base__/graphics/technology/automation.png",
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "5d-assembling-machine-5"
			},
		},
		prerequisites = {"automation-4"},
		unit =
		{
			count = 250,
			ingredients =
				{
					{"science-pack-1", 2},
					{"science-pack-2", 1},
					{"science-pack-3", 1}
				},
			time = 80
		},
		order = "c-a"
	},
  {
    type = "technology",
    name = "oil-processing-2",
    icon = "__base__/graphics/technology/oil-gathering.png",
    prerequisites = {"oil-processing"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "5d-oil-refinery-2"
      },
      {
        type = "unlock-recipe",
        recipe = "5d-chemical-plant-2"
      },
    },
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
    order = "d-a"
  },
  {
    type = "technology",
    name = "oil-processing-3",
    icon = "__base__/graphics/technology/oil-gathering.png",
    prerequisites = {"oil-processing-2"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "5d-oil-refinery-3"
      },
      {
        type = "unlock-recipe",
        recipe = "5d-chemical-plant-3"
      },
    },
    unit =
    {
      count = 150,
      ingredients = 
	  {
		{"science-pack-1", 1},
		{"science-pack-2", 1},
		{"science-pack-3", 1},
	  },
      time = 30
    },
    order = "d-a"
  },
})