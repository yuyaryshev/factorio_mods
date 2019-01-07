local pumps_new_base_level = 3				-- entities containing 'pump'
local other_entites_new_base_level = 2		-- entities with base_level == 1 (assemplers, mining drills, etc)

function generate_high_pipe(type_name, entity_name)
	if high_pipe.fluid_box and (not high_pipe.fluid_box.base_level or high_pipe.fluid_box.base_level == 0) then
		local high_pipe = util.table.deepcopy(data.raw[type_name][entity_name])
		high_pipe.placeable_by = high_pipe.placeable_by or high_pipe.name
		high_pipe.name = "high-".. high_pipe.name
		high_pipe.fluid_box.base_level = 1
		
		if high_pipe.localized_name then
			high_pipe.localized_name = "High "..high_pipe.localized_name 
		end
		
		if high_pipe.localized_description then
			high_pipe.localized_description = "High "..high_pipe.localized_description
		end		
		data:extend(high_pipe)
	end
end

if settings.startup["ReallyPressureTanks_enable"].value then
	local name_mask = settings.startup["ReallyPressureTanks_name_mask"].value
	local min_capacity = settings.startup["ReallyPressureTanks_min_capacity"].value
	if name_mask == "" then
		name_mask = false
	end

	local n_tanks = 0
	local n_pumps = 0
	local n_other_entities = 0
	

	if settings.startup["ReallyPressureTanks_upgrade_pumps"].value then
	
		-- Upgrade pumps
		for k,entity in pairs(data.raw["pump"]) do
			if string.find(entity.name, "pump") and (not entity.fluid_box.base_level or entity.fluid_box.base_level >= 0 and entity.fluid_box.base_level < 3) then
				 entity.fluid_box.base_level = 3
			 n_pumps = n_pumps + 1
			end
		end
		
		-- Upgrade production entities
		for type_name,v_type in pairs(data.raw) do
			for k,entity in pairs(v_type) do
				if entity and not string.find(entity.name, "high-") then
					local changed = false
					
					if entity.fluid_box and entity.fluid_box.base_level and entity.fluid_box.base_level == 1 then
						entity.fluid_box.base_level = other_entites_new_base_level
						changed = true
					end

					if entity.output_fluid_box and entity.output_fluid_box.base_level and entity.output_fluid_box.base_level == 1 then
						entity.output_fluid_box.base_level = other_entites_new_base_level
						changed = true
					end
					
					if entity.fluid_boxes then
						for box_key,box in pairs(entity.fluid_boxes) do
							if box and type(box)=="table" and box.base_level and box.base_level == 1 then
								entity.fluid_boxes[box_key].base_level = other_entites_new_base_level
								changed = true
							end
						end
					end
			
					if changed then
						n_other_entities = n_other_entities + 1
					end
				end
			end
		end
	end

--	-- Generate high versions for pipes and underground-pipes
--	Planner for moving between levels is not implemented
--	for k,entity in pairs(data.raw["pipe"],data.raw["pipe-to-ground"]) do
--		generate_high_pipe(entity.type, entity.name)
--	end

	-- Upgrade fluid tanks
	for k,entity in pairs(data.raw["storage-tank"]) do
		if (not name_mask or string.find(entity.name, name_mask)) and (not entity.fluid_box.base_level or entity.fluid_box.base_level == 0) and entity.fluid_box.base_area > min_capacity then
			 entity.fluid_box.base_level = 1
			 
			 n_tanks = n_tanks + 1
		end
	end
	
	--error("DEBUG: Changed n_tanks="..n_tanks..", n_pumps="..n_pumps..", n_other_entities="..n_other_entities..".")
end




