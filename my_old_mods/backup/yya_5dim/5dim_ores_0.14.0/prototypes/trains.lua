data:extend({
  {
    type = "recipe",
    name = "5d-rail-water",
    enabled = "false",
    ingredients =
    {
      {"straight-rail", 1}
    },
    result = "5d-rail-water",
    result_count = 1
  },
    {
    type = "recipe",
    name = "5d-power-rail-water",
    enabled = "false",
    ingredients = 
	{
		{"straight-rail", 1},
		{"steel-plate", 1},
		{"copper-plate", 1}
	},
    result = "5d-power-rail-water",
    result_count = 1
  },
    {
    type = "recipe",
    name = "straight-power-rail",
    enabled = "false",
    ingredients = 
	{
		{"straight-rail", 1},
		{"steel-plate", 1},
		{"copper-plate", 1}
	},
    result = "straight-power-rail",
    result_count = 1
  },
  {
    type = "recipe",
    name = "5d-rail-water-curve",
    enabled = "false",
    ingredients =
    {
      {"straight-rail", 1}
    },
    result = "5d-rail-water-curve",
    result_count = 1
  },
  {
    type = "recipe",
    name = "5d-curved-power-rail-water", 
    enabled = "false",
    ingredients = 
	{
		{"curved-rail", 1},
		{"steel-plate", 2},
		{"copper-plate", 2}
	},
    result = "5d-curved-power-rail-water",
    result_count = 1
  },
  {
    type = "recipe",
    name = "curved-power-rail", 
    enabled = "false",
    ingredients = 
	{
		{"curved-rail", 1},
		{"steel-plate", 2},
		{"copper-plate", 2}
	},
    result = "curved-power-rail",
    result_count = 1
  },
  {
    type = "recipe",
    name = "cargo-wagon-passive",
    enabled = "false", -- TESTING ONLY
    ingredients =
    {
      {"cargo-wagon", 1},
      {"zinc-plate", 10},
	  {"logistic-chest-passive-provider", 1}
    },
    result = "cargo-wagon-passive"
  },
  {
    type = "recipe",
    name = "electric-locomotive",
    enabled = "false",
    ingredients =
    {
      {"electric-engine-unit", 15},
      {"electronic-circuit", 5},
      {"zinc-plate", 25},
    },
    result = "electric-locomotive"
  },
	{
		type = "recipe",
		name = "cargo-wagon-laser-turret",
		enabled = "false", -- TESTING ONLY
		ingredients =
		{
			{"cargo-wagon", 1},
			{"accumulator", 1},
			{"copper-cable", 15},
			{"5d-gold-circuit", 2},
			{"laser-turret", 4},
		},
		result = "cargo-wagon-laser-turret"
	},
	{
		type = "recipe",
		name = "cargo-wagon-gun-turret",
		enabled = "false", -- TESTING ONLY
		ingredients =
		{
			{"cargo-wagon", 1},
			{"5d-tin-plate", 50},
			{"gun-turret", 6},
		},
		result = "cargo-wagon-gun-turret"
	},
    {
    type = "recipe",
    name = "cargo-wagon-active",
    enabled = "false", -- TESTING ONLY
    ingredients =
    {
      {"cargo-wagon", 1},
      {"5d-tin-plate", 10},
	  {"logistic-chest-active-provider", 1}
    },
    result = "cargo-wagon-active"
  },
  	{
    type = "recipe",
    name = "cargo-wagon-accumulator",
    enabled = "false",
    ingredients =
    {
      {"cargo-wagon", 1},
	  {"accumulator", 10},
	  {"5d-gold-wire", 15}
    },
    result = "cargo-wagon-accumulator"
  },
	{
    type = "recipe",
    name = "cargo-wagon-storage",
    enabled = "false", -- TESTING ONLY
    ingredients =
    {
      {"cargo-wagon", 1},
      {"aluminium-plate", 10},
	  {"logistic-chest-storage", 1}
    },
    result = "cargo-wagon-storage"
  },
    {
    type = "recipe",
    name = "cargo-wagon-roboport",
    enabled = "false", -- TESTING ONLY
    ingredients =
    {
      {"cargo-wagon", 1},
	  {"roboport", 1},
	  {"zinc-plate", 15},
	  {"5d-gold-circuit", 1},
	  {"5d-gold-wire", 15}
    },
    result = "cargo-wagon-roboport"
  },
  {
    type = "recipe",
    name = "cargo-wagon-requester",
    enabled = "false", -- TESTING ONLY
    ingredients =
    {
      {"cargo-wagon", 1},
      {"lead-plate", 10},
	  {"logistic-chest-requester", 1}
    },
    result = "cargo-wagon-requester"
  },
})