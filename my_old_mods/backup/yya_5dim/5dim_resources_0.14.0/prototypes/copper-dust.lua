data:extend({
-- Item
	{
		type = "item",
		name = "5d-copper-dust",
		subgroup = "plates-dust",
		order = "b",
		icon = "__5dim_resources__/graphics/icon/icon_5d_copper_dust.png",
		flags = {"goes-to-main-inventory"},
		stack_size = 200
	},

--Recipe
	{
		type = "recipe",
		name = "5d-copper-plate",
		icon = "__base__/graphics/icons/copper-plate.png",
		subgroup = "plates-plates2",
		order = "b",
		category = "smelting",
		energy_required = 3.5,
		ingredients = {{ "5d-copper-dust", 1}},
		result = "copper-plate",
	},
	{
		type = "recipe",
		name = "5d-copper-dust",
		enabled = "true",
		category = "mashering",
		energy_required = 3.5,
		ingredients = 
		{
			{"copper-ore",1}
		},
		result = "5d-copper-dust",
		result_count = 2,
	},

--Entity
})