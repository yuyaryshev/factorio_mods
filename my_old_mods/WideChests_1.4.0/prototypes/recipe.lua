data:extend(
{
	{
		type = "recipe",
		name = "merge-chest-selector",
		energy_required = 0.01,
		ingredients =
		{
			{"wood", 1}
		},
		result = "merge-chest-selector",
		enabled = true
	},
})

if MergingChests.ChestRecipes then
	for _, size in pairs(MergingChests.ChestRecipes) do
			data:extend(
			{
				{
					type = "recipe",
					name = "wide-chest-"..size,
					localised_name = "Steel chest "..size.." wide",
					energy_required = 0.01,
					ingredients =
					{
						{"steel-chest", size}
					},
					result = "wide-chest-"..size,
					enabled = false
				},
				{
					type = "recipe",
					name = "high-chest-"..size,
					localised_name = "Steel chest "..size.." high",
					energy_required = 0.01,
					ingredients =
					{
						{"steel-chest", size}
					},
					result = "high-chest-"..size,
					enabled = false
				},
			})
	end
end
	
	