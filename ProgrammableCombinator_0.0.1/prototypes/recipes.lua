data:extend({
	{
		type = "recipe",
		name = "programmable-combinator",
		energy_required = 10,
		enabled = true,
		ingredients =
		{
			{"iron-plate", 10},
			{"copper-cable", 20},
			{"electronic-circuit", 20},
		},
		result = "programmable-combinator"
	},
	{
		type = "recipe",
		name = "programmable-combinator-input",
		energy_required = 1,
		enabled = true,
		ingredients =
		{
			{"iron-plate", 1},
			{"electronic-circuit", 1},
		},
		result = "programmable-combinator-input"
	},
	{
		type = "recipe",
		name = "programmable-combinator-output",
		energy_required = 1,
		enabled = true,
		ingredients =
		{
			{"iron-plate", 1},
			{"electronic-circuit", 1},
		},
		result = "programmable-combinator-output"
	},
})