require "config"

----Pollution obsorbtion----
--All Trees EVEN MOD TREES 
for k,tree in pairs(data.raw["tree"]) do
	if tree.emissions_per_tick then
		local Emissions = tree.emissions_per_tick
		tree.emissions_per_tick = Emissions * EmissionsFactor
	end	--trees have negative emissions so they soak up polution
end

----Tree Collision----
--Forest easyer to walk through
if TreeCollision then
	for _,tree in pairs(data.raw["tree"]) do
--		tree.collision_box = {{-0.01, -0.01}, {0.01, 0.01}}	
	end
end

----Tree Material Correction----
--Tree drop wood when killed; like rocks drop stone.
if TreeMaterialCorrection then
	for _,tree in pairs(data.raw["tree"]) do
		tree.loot = {{item = "raw-wood", probability = 1, count_min = 1, count_max = 2}}
		--One Forth to Half of mineable items; just like the rocks.
	end
end

--- Trees Give Random 1 - 6 Raw Wood.
for _,tree in pairs(data.raw["tree"]) do
	if not (tree.name =="dead-tree" or tree.name == "dry-tree" or tree.name == "green-coral" or tree.name == "dead-grey-trunk" or tree.name == "dry-hairy-tree" or tree.name == "dead-dry-hairy-tree") then  
	tree.minable = 	{mining_particle = "wooden-particle", mining_time = 1.5*math.abs(EmissionsFactor), results = {{type = "item", name = "raw-wood", amount = 4*math.abs(EmissionsFactor)},}}
	end
end


----Tree Loot----
--Tree drop wood when killed; like rocks drop stone.
if TreeLoot then
	for _,tree in pairs(data.raw["tree"]) do
		tree.loot = {{item = "raw-wood", probability = 1, count_min = 1, count_max = 2}}
		--One Forth to Half of mineable items; just like the rocks.
	end
end

