
local max = math.max


-- Removes blood of biters
local explosions = data.raw['explosion']
explosions['blood-explosion-small'].created_effect = nil
explosions['blood-explosion-big'].created_effect = nil
explosions['blood-explosion-huge'].created_effect = nil

-- Removes corpses and some effects in each unit
for _, unit in pairs(data.raw.unit) do
	unit.dying_explosion = nil
	unit.corpse = nil
end


local modifier = settings.startup["ups-fps_biter-modifier"].value
-- Make biters stronger but fewer
if modifier > 1 then
	for _, unit in pairs(data.raw.unit) do
		if unit.subgroup == "enemies" and unit.max_health then -- Perhaps, it's a wrong way
			unit.max_health = unit.max_health * modifier
			
			if unit.spawning_time_modifier then
				unit.spawning_time_modifier = unit.spawning_time_modifier * max(1, modifier)
			else
				unit.spawning_time_modifier = max(1, modifier)
			end
			
			if unit.attack_parameters ~= nil then
				if unit.attack_parameters.cooldown > 0 then
					unit.attack_parameters.cooldown = unit.attack_parameters.cooldown / modifier;
				end
				
				if unit.attack_parameters.cooldown_deviation > 0 then
					unit.attack_parameters.cooldown_deviation = unit.attack_parameters.cooldown_deviation / modifier;
				end			
			end		
		end
	end
end

-- Perhaps, it's crap \/
--for _, spawner in pairs(data.raw["unit-spawner"]) do
--	if spawner.autoplace then
--		--max_count_of_owned_units =
--		--max_friends_around_to_spawn =
--		--With zero evolution the spawn rate is 6 seconds, with max evolution it is 2.5 seconds
--		--spawning_cooldown = {360, 150}
--	end
--end


if settings.startup["ups-fps_remove-remnants"].value == true then
	for _, prototype in pairs(data.raw) do
		for _, entity in pairs(prototype) do
			entity.corpse = nil
		end
	end

	for name, corpse in pairs(data.raw.corpse) do
		if name == "defender-remnants" then -- it's weird
			corpse.time_before_removed = 2*60 -- 1 sec
			corpse.time_before_shading_off = 60 -- 1 sec
		else
			corpse = nil
		end
	end

	-- Probably, it must be changed
	for name, corpse in pairs(data.raw['rail-remnants']) do
		corpse.time_before_removed = 2*60 -- 1 sec
		corpse.time_before_shading_off = 60 -- 1 sec
	end
end
