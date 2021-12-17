data:extend({
  	{
		type = "item",
		name = "programmable-combinator",
		icon = MOD_NAME.."/graphics/programmable-combinator-item.png",
		icon_size = 32,
		flags = {"goes-to-quickbar"},
		subgroup = "circuit-network",
		order = "b[combinators]-programmable-combinator-1",
		place_result = "programmable-combinator",
		stack_size = 50,
		enabled = true
	},
  	{
		type = "item",
		name = "programmable-combinator-input",
		icon = MOD_NAME.."/graphics/programmable-combinator-input-item.png",
		icon_size = 32,
		flags = {"goes-to-quickbar"},
		subgroup = "circuit-network",
		order = "b[combinators]-programmable-combinator-2-input",
		place_result = "programmable-combinator-input",
		stack_size = 50,
		enabled = true
	},
  	{
		type = "item",
		name = "programmable-combinator-output",
		icon = MOD_NAME.."/graphics/programmable-combinator-output-item.png",
		icon_size = 32,
		flags = {"goes-to-quickbar"},
		subgroup = "circuit-network",
		order = "b[combinators]-programmable-combinator-3-output",
		place_result = "programmable-combinator-output",
		stack_size = 50,
		enabled = true
	},
})


local invisible_constant_combinator = copyPrototype("item", "constant-combinator", "invisible-constant-combinator")
local invisible_decider_combinator = copyPrototype("item", "decider-combinator", "invisible-decider-combinator")
local invisible_arithmetic_combinator = copyPrototype("item", "arithmetic-combinator", "invisible-arithmetic-combinator")
		
local invisible_combinators = {invisible_constant_combinator, invisible_decider_combinator, invisible_arithmetic_combinator}		

data:extend(invisible_combinators)

