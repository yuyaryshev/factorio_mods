require "config"

bobmods.lib.tech.add_recipe_unlock("sulfur-processing", "sulfur")

function starts_with(s, pattern1, pattern2, pattern3)
	return s and (pattern1 and string.find(s, pattern1, 1, true) == 1 or pattern2 and string.find(s, pattern2, 1, true) == 1 or pattern3 and string.find(s, pattern3, 1, true) == 1)
end

function change_recipe_energy(recipe,ratio)
	if data.raw["recipe"][recipe] then
		data.raw["recipe"][recipe].energy_required = data.raw["recipe"][recipe].energy_required*ratio
	end
end

if data.raw["assembling-machine"]["water-well-pump"] then
	data.raw["assembling-machine"]["water-well-pump"].energy_usage = "10W"
	data.raw["recipe"]["water-well-pump"].ingredients = data.raw["recipe"]["offshore-pump"].ingredients
	data.raw["recipe"]["water-well-pump"].enabled = true
end

change_recipe_energy("bi_recipe_seed_1", 0.3) 
change_recipe_energy("bi_recipe_seed_2", 0.3) 
change_recipe_energy("bi_recipe_seed_3", 0.3) 
change_recipe_energy("bi_recipe_seed_4", 0.3) 
change_recipe_energy("bi_recipe_seed_5", 0.3) 
change_recipe_energy("bi_recipe_seedling_mk1", 0.3)
change_recipe_energy("bi_recipe_seedling_mk2", 0.3)
change_recipe_energy("bi_recipe_seedling_mk3", 0.3)
change_recipe_energy("bi_recipe_seedling_mk4", 0.3)
change_recipe_energy("bi_recipe_seedling_mk5", 0.3)
change_recipe_energy("bi_recipe_logs_mk1", 0.3)
change_recipe_energy("bi_recipe_logs_mk2", 0.3)
change_recipe_energy("bi_recipe_logs_mk3", 0.3)
change_recipe_energy("bi_recipe_logs_mk4", 0.3)
change_recipe_energy("bi_recipe_logs_mk5", 0.3)


-- offshore pump can now be placed anywhere
data.raw["offshore-pump"]["offshore-pump"].adjacent_tile_collision_test = { "water-tile", "ground-tile" }

data.raw["recipe"]["red-wire"].energy_required = 0.002
data.raw["recipe"]["green-wire"].energy_required = 0.002
data.raw["recipe"]["red-wire"].ingredients = {}
data.raw["recipe"]["green-wire"].ingredients = {}
data.raw["recipe"]["landfill"].result_count = 10


data.raw.item["raw-wood"].stack_size = 500
data.raw["rail-planner"]["rail"].stack_size = 1000
data.raw.item["landfill"].stack_size = 1000

-- Remove all drains, so I don't have to mess with toggling off idle buildings
for i_type, v_type in pairs (data.raw) do
	if type(v_type) == "table" then
		for i_name, v_name in pairs (v_type) do
			if v_name.energy_source then 
				v_name.energy_source.drain = "0W"
			end
		end
	end
end

for i_name, e in pairs (data.raw["roboport"]) do
	 e.energy_usage = "0W"
end

if data.raw.item["wood-bricks"] then
	data.raw.item["wood-bricks"].fuel_value = "40MJ"
end

for type_name,_ in pairs(data.raw) do
	for entity_name,e in pairs(data.raw[type_name]) do
		if starts_with(entity_name, "storehouse", "warehouse") and e.inventory_size then
			e.inventory_size = e.inventory_size * 10
		end 
	end
end


if data.raw.recipe["beltplanner"] then
	data.raw.recipe["beltplanner"].ingredients = {}
end

for i, recipe in pairs(data.raw.recipe) do
  if
    recipe.name == "lo-radio-transmitter" or
    recipe.name == "lo-radio-receiver" or
    recipe.name == "lo-radio-constant" or
    recipe.name == "programmable-speaker" or
    recipe.name == "logistic-train-stop" or
    recipe.name == "arithmetic-combinator" or
    recipe.name == "decider-combinator" or
    recipe.name == "constant-combinator" or
    recipe.name == "yellow-filter-inserter" or
    recipe.name == "rail-signal" or
    recipe.name == "locomotive" or
    recipe.name == "power-switch" or
    recipe.name == "rail-chain-signal"
  then
    bobmods.lib.recipe.replace_ingredient(recipe.name, "electronic-circuit", "basic-circuit-board")
  end
end

for k,e in pairs(data.raw["radar"]) do
	if e.max_distance_of_sector_revealed then
		e.max_distance_of_sector_revealed = e.max_distance_of_sector_revealed * 2
	end
	
	if e.max_distance_of_nearby_sector_revealed then
		e.max_distance_of_nearby_sector_revealed = e.max_distance_of_nearby_sector_revealed * 2
	end
end

bobmods.lib.recipe.remove_ingredient("rail", "concrete")
bobmods.lib.tech.add_recipe_unlock("railway", "rail")
bobmods.lib.tech.remove_recipe_unlock("bob-railway-2", "rail")

--	for i_name, e in pairs (data.raw["radar"]) do
--	--	e.energy_per_sector		= data.raw["radar"]["radar"].energy_per_sector
--	--	e.energy_usage			= data.raw["radar"]["radar"].energy_usage
--	--	e.energy_per_sector		= "0kW"
--	--	e.energy_usage			= "0kW"
--	end
