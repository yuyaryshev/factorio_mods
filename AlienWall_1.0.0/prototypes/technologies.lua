data:extend(
{
  {
    type = 'technology',
    name='alien-bioengineering',
	localised_name='Alien Bio Engineering',
    icon = '__AlienWall__/graphics/icons/tech/alien-bioconstruct.png',
	icon_size = 128,
    effects = {{type = 'unlock-recipe', recipe='alien-bioconstruct'}},
    prerequisites = {},
    unit =
	{
      count = 50,
      ingredients =
      {
        {"science-pack-1", 2},
        {"science-pack-2", 1},
      },
      time = 15
    },
    order='a-e-a',
  },
  {
    type = "technology",
    name="alien-hybridization-1",
	localised_name='Alien Wall Hybridization',
	localised_description='Hybrid Wall that regenerates HP. Basic rate is 2 HP per second. Do research for higher regeneration rates.',
    icon = '__AlienWall__/graphics/icons/tech/stone-walls.png',
	icon_size = 128,
    effects = {{type = "unlock-recipe", recipe="hybridized-wall"}},
    prerequisites = {"stone-walls", 'alien-bioengineering'},
	unit =
    {
      count = 100,
      ingredients =
      {
        {"science-pack-1", 2},
        {"science-pack-2", 1},
		{"military-science-pack", 1},
      },
      time = 30
    },
    order="a-e-b",
  },
  {
    type = "technology",
    name="alien-hybridization-2",
	localised_name='Alien Gate Hybridization',
	localised_description='Hybrid Gate that regenerates HP. Basic rate is 2 HP per second. Do research for higher regeneration rates.',
    icon = '__AlienWall__/graphics/icons/tech/gates.png',
	icon_size = 128,
    effects = {{type = "unlock-recipe", recipe="hybridized-gate"}},
    prerequisites = {"alien-hybridization-1", "gates"},
	unit =
    {
      count = 200,
      ingredients =
      {
        {"science-pack-1", 3},
        {"science-pack-2", 2},
		{"military-science-pack", 1},
      },
      time = 60
    },
    order="a-e-c",
  },
  -- Kinda tempted to rebalance some of these costs, but I'll leave it alone for now.
  -- Hey, I wonder if I could dynamically generate more of these based on `HybridHP.length`, similar to how infinite research works...
  {
    type = "technology",
    name="alien-hybrid-upgrade-1",
	localised_name='Alien Hybrid Upgrade 1',
	localised_description='Upgrade Hybrid Walls to 600 HP and 5 HP/s regeneration.',
    icon = '__AlienWall__/graphics/icons/tech/stone-walls-plus.png',
	icon_size = 128,
	effects = {},
    prerequisites = {"alien-hybridization-2"},
	unit =
    {
      count = 100,
      ingredients =
      {
        {"science-pack-1", 3},
        {"science-pack-2", 2},
      },
      time = 20
    },
    order="a-f-a",
  },
  {
    type = "technology",
    name="alien-hybrid-upgrade-2",
	localised_name='Alien Hybrid Upgrade 2',
	localised_description='Upgrade Hybrid Walls to 750 HP and 10 HP/s regeneration.',
    icon = '__AlienWall__/graphics/icons/tech/stone-walls-plus.png',
	icon_size = 128,
	effects = {},
    prerequisites = {"alien-hybrid-upgrade-1"},
	unit =
    {
      count = 200,
      ingredients =
      {
        {"science-pack-1", 3},
        {"science-pack-2", 2},
		{"military-science-pack", 1},
      },
      time = 30
    },
    order="a-f-b",
	upgrade = "true",
  },
  {
    type = "technology",
    name="alien-hybrid-upgrade-3",
	localised_name='Alien Hybrid Upgrade 3',
	localised_description='Upgrade Hybrid Walls to 1000 HP and 15 HP/s regeneration.',
    icon = '__AlienWall__/graphics/icons/tech/stone-walls-plus.png',
	icon_size = 128,
	effects = {},
    prerequisites = {"alien-hybrid-upgrade-2"},
	unit =
    {
      count = 200,
      ingredients =
      {
        {"science-pack-1", 3},
        {"science-pack-2", 3},
		{"science-pack-3", 2},
		      },
      time = 60
    },
    order="a-f-c",
	upgrade = "true",
  },
  {
    type = "technology",
    name="alien-hybrid-upgrade-4",
	localised_name='Alien Hybrid Upgrade 4',
	localised_description='Upgrade Hybrid Walls to 1500 HP and 25 HP/s regeneration.',
    icon = '__AlienWall__/graphics/icons/tech/stone-walls-plus.png',
	icon_size = 128,
	effects = {},
    prerequisites = {"alien-hybrid-upgrade-3"},
	unit =
    {
      count = 350,
      ingredients =
      {
        {"science-pack-1", 3},
        {"science-pack-2", 3},
		{"science-pack-3", 2},
		{"military-science-pack", 2},
		      },
      time = 60
    },
    order="a-f-d",
	upgrade = "true",
  }
})