

if not data.raw.technology["steel-processing"].effects then
	data.raw.technology["steel-processing"].effects = {}
end

table.insert(data.raw.technology["steel-processing"].effects, {type="unlock-recipe", recipe = "merge-chest-selector"})
if MergingChests.ChestRecipes then
	for _, size in pairs(MergingChests.ChestRecipes) do
		table.insert(data.raw.technology["steel-processing"].effects, {type="unlock-recipe", recipe = "wide-chest-"..size})
		table.insert(data.raw.technology["steel-processing"].effects, {type="unlock-recipe", recipe = "high-chest-"..size})
	end
end