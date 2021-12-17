function updateRecipe(recipe)
	if recipe.ingredients and #recipe.ingredients == 1 then
		local input_amount = recipe.ingredients[1].amount or recipe.ingredients[1][2]
		if input_amount > 1 then
				if recipe.ingredients[1].amount then
					recipe.ingredients[1].amount = 1
				else
					recipe.ingredients[1][2] = 1
				end
				
				-- adjust results
				if recipe.results then
					for i=1, #recipe.results, 1 do
						recipe.result[i].probability = 1/(input_amount*1.0)
						recipe.result[i].probability = (recipe.result[i].probability or 1)/(input_amount*1.0)
					end
				else
					recipe.results = {}
				end

				-- adjust result
				if recipe.result then
					table.insert(recipe.results, 
						{
						name = recipe.result,
						probability = 1/(input_amount*1.0),
						amount = recipe.result_count or 1
						})
					recipe.result = nil
					recipe.result_count = nil
				end
				
				--adjust energy (recipe time)
				recipe.energy_required = recipe.energy_required/(input_amount*1.0)
		end
	end
end

for _, recipe in pairs (data.raw["recipe"]) do
	if recipe.category == "smelting" then
		if recipe.ingredients then
			updateRecipe(recipe)
		end
		if recipe.normal and recipe.normal.ingredients then
			updateRecipe(recipe.normal)
		end
		if recipe.expensive and recipe.expensive.ingredients then
			updateRecipe(recipe.expensive)
		end
	end
end

--updateRecipe(data.raw["recipe"]["steel-plate"]



--data.raw["recipe"]["steel-plate"].normal =
--    {
--      enabled = false,
--      energy_required = 17.5/5,
--      ingredients = {{"iron-plate", 1}},
--	  results = {{
--		name = "steel-plate",
--		probability = 0.2,
--		amount = 1
--		}}
--    }
--data.raw["recipe"]["steel-plate"].expensive =
--    {
--      enabled = false,
--      energy_required = 35/10,
--      ingredients = {{"iron-plate", 1}},
--	  results = {{
--		name = "steel-plate",
--		probability = 0.1,
--		amount = 1
--		}}
--    }



