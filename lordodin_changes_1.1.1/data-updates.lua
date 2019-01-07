require "config"

function starts_with(s, pattern1, pattern2, pattern3)
	return s and (pattern1 and string.find(s, pattern1, 1, true) == 1 or pattern2 and string.find(s, pattern2, 1, true) == 1 or pattern3 and string.find(s, pattern3, 1, true) == 1)
end

data.raw["recipe"]["concrete"].result_count = 100 
data.raw["recipe"]["rail"].result_count = 20
---data.raw["recipe"]["landfill"].result_count = 100

-- data.raw["recipe"]["loader"].ingredients = {{"electronic-circuit", 10},{"filter-inserter", 6}}
-- data.raw["recipe"]["fast-loader"].ingredients = {{"loader", 2}}
-- data.raw["recipe"]["express-loader"].ingredients = {{"fast-loader", 2}}

data.raw["constant-combinator"]["constant-combinator"].item_slot_count = 90

data.raw["recipe"]["red-wire"].energy_required = 0.002
data.raw["recipe"]["green-wire"].energy_required = 0.002
data.raw["recipe"]["red-wire"].ingredients = {}
data.raw["recipe"]["green-wire"].ingredients = {}

data.raw["arithmetic-combinator"]["arithmetic-combinator"].active_energy_usage = "10W"
data.raw["decider-combinator"]["decider-combinator"].active_energy_usage = "10W"
data.raw["programmable-speaker"]["programmable-speaker"].active_energy_usage = "10W"

if data.raw["technology"]["ore-refining"] then
	data.raw["assembling-machine"]["assembling-machine-1"].ingredient_count = 6
	data.raw["assembling-machine"]["assembling-machine-2"].ingredient_count = 6
end

data.raw.item["raw-wood"].stack_size = 400
if data.raw["recipe"]["logistic-train-stop"] ~= nil then
	data.raw["recipe"]["logistic-train-stop"].ingredients = data.raw["recipe"]["train-stop"].ingredients
	data.raw["recipe"]["train-stop"].result = data.raw["recipe"]["logistic-train-stop"].result
	data.raw["technology"]["logistic-train-network"] = nil
end

function update_stack_inserter_capacity(tech, new_capacity)
if data.raw["technology"][tech].effects[1].type == "stack-inserter-capacity-bonus" then
	i = 1
else
	if data.raw["technology"][tech].effects[2].type == "stack-inserter-capacity-bonus" then
		i = 2
	else
		i = 3
	end
end
data.raw["technology"][tech].effects[i].modifier = new_capacity
end

update_stack_inserter_capacity("stack-inserter"			  , 2 )
update_stack_inserter_capacity("inserter-capacity-bonus-1", 3 )
update_stack_inserter_capacity("inserter-capacity-bonus-2", 5 )
update_stack_inserter_capacity("inserter-capacity-bonus-3", 5 )
update_stack_inserter_capacity("inserter-capacity-bonus-4", 5 )
update_stack_inserter_capacity("inserter-capacity-bonus-5", 5 )
update_stack_inserter_capacity("inserter-capacity-bonus-6", 5 )
update_stack_inserter_capacity("inserter-capacity-bonus-7", 5 )

for k,item in pairs(data.raw.item) do
	if string.find(item.name, "rail") and item.stack_size == 100 then
		item.stack_size = 1000
	end

	for index = 1, #item.flags do
		if item.flags[index] == "goes-to-quickbar" then
			table.remove(item.flags, index)
			break
		end 
	end	
end



----Tree Collision----
--Forest easyer to walk through
if TreeCollision then
	for _,tree in pairs(data.raw["tree"]) do
--		tree.collision_box = {{-0.01, -0.01}, {0.01, 0.01}}	
	end
end




	
if false then -- disabled tree fix due to bio industries
	----Pollution obsorbtion----
	--All Trees EVEN MOD TREES 
	for k,tree in pairs(data.raw["tree"]) do
		if tree.emissions_per_tick then
			local Emissions = tree.emissions_per_tick
			tree.emissions_per_tick = Emissions * EmissionsFactor
		end	--trees have negative emissions so they soak up polution
	end

	--- Trees Give 40 Raw Wood.
	for _,tree in pairs(data.raw["tree"]) do
		if not (tree.name =="dead-tree" or tree.name == "dry-tree" or tree.name == "green-coral" or tree.name == "dead-grey-trunk" or tree.name == "dry-hairy-tree" or tree.name == "dead-dry-hairy-tree") then  
		tree.minable = 	{mining_particle = "wooden-particle", mining_time = 1, results = {{type = "item", name = "raw-wood", amount = 4*math.abs(EmissionsFactor)},}}
		end
	end
end


--function upgrade_speed(type_name, name)
--	if data.raw[type_name] and data.raw[type_name][name] then
--		data.raw[type_name][name].speed = 2 * data.raw[type_name][name].speed
--	end
--end
--
--
--upgrade_speed("transport-belt", "transport-belt")
--upgrade_speed("transport-belt", "fast-transport-belt")
--upgrade_speed("transport-belt", "express-transport-belt")
--
--upgrade_speed("underground-belt", "underground-belt")
--upgrade_speed("underground-belt", "fast-underground-belt")
--upgrade_speed("underground-belt", "express-underground-belt")
--
--upgrade_speed("splitter", "splitter")
--upgrade_speed("splitter", "fast-splitter")
--upgrade_speed("splitter", "express-splitter")
--
--upgrade_speed("loader", "loader")
--upgrade_speed("loader", "fast-loader")
--upgrade_speed("loader", "express-loader")
--
--upgrade_speed("loader", "deadlock-loader-item-1")
--upgrade_speed("loader", "deadlock-loader-item-2")
--upgrade_speed("loader", "deadlock-loader-item-3")



