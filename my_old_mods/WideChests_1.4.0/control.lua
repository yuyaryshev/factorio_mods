if not MergingChests then MergingChests = {} end
if not MergingChests.Migrations then MergingChests.Migrations = {} end
if not MergingChests.Migrations._1_3_0 then MergingChests.Migrations_1_3_0 = false end

require("config")

function MergingChests.OnTick()
	if not MergingChests.Migrations._1_3_0 then
			for _, force in pairs(game.forces) do
				if force.technologies["steel-processing"] then
					if force.technologies["steel-processing"].researched then
						for __, size in pairs(MergingChests.ChestRecipes) do
							force.recipes["wide-chest-"..size].enabled = true
							force.recipes["high-chest-"..size].enabled = true
						end
					end
				end
			end
		MergingChests.Migrations._1_3_0 = true
	end
end

function entityCompareX(entityA, entityB)
	return entityA.position.x < entityB.position.x
end

function entityCompareY(entityA, entityB)
	return entityA.position.y < entityB.position.y
end

function MergingChests.CheckContinuousChests(entities, property)
	for i = 1, #entities - 1 do
		if property(entities[i]) + 1.1 < property(entities[i+1]) then
			return false
		end
	end
	
	return true
end

function MergingChests.OnPlayerSelectedArea(event)
	if not item or item == "merge-chest-selector" then
		local player = game.players[event.player_index]
		if event.area.left_top.x ~= event.area.right_bottom.x and event.area.left_top.y ~= event.area.right_bottom.y then
			local entities = player.surface.find_entities_filtered{area = event.area, force = player.force, name = "steel-chest"}
			
			if entities and #entities > 1 then
				local min = entities[1].position
				local max = entities[1].position
				
				for i = 2, #entities do
					if min.x > entities[i].position.x then min.x = entities[i].position.x end
					if min.y > entities[i].position.y then min.y = entities[i].position.y end
					if max.x < entities[i].position.x then max.x = entities[i].position.x end
					if max.y < entities[i].position.y then max.y = entities[i].position.y end
				end
				
				local width = math.ceil(max.x) - math.floor(min.x)
				local height = math.ceil(max.y) - math.floor(min.y)
				
				if width > MergingChests.MaxSize then
					width = MergingChests.MaxSize
				end
				
				if height > MergingChests.MaxSize then
					height = MergingChests.MaxSize
				end
						
				local destinationStack = 1
			
				if width < 1.5 then
					--merge vertical
					table.sort(entities, entityCompareY)
					
					if MergingChests.CheckContinuousChests(entities, function(entity) return entity.position.y end) then
						local newInventory = player.surface.create_entity{name = "high-chest-"..height, position = {entities[1].position.x, entities[1].position.y + height / 2 - 1}, force = player.force}.get_inventory(1)
						
						for i = 1, height do
							local oldInventory = entities[i].get_inventory(1)
							for j = 1, #oldInventory do
								if oldInventory[j].valid_for_read then
									newInventory[destinationStack].set_stack(oldInventory[j])
									destinationStack = destinationStack + 1
								end
							end
							entities[i].destroy()
						end
						
					else
						player.print("Selected area doesn't contain continuous chests.")
					end
				elseif height < 1.5 then
					--merge horizontal
					table.sort(entities, entityCompareX)
					
					if MergingChests.CheckContinuousChests(entities, function(entity) return entity.position.x end) then
						local newInventory = player.surface.create_entity{name = "wide-chest-"..width, position = {entities[1].position.x + width / 2 - 1, entities[1].position.y}, force = player.force}.get_inventory(1)
						
						for i = 1, width do
							local oldInventory = entities[i].get_inventory(1)
							for j = 1, #oldInventory do
								if oldInventory[j].valid_for_read then
									newInventory[destinationStack].set_stack(oldInventory[j])
									destinationStack = destinationStack + 1
								end
							end
							entities[i].destroy()
						end
					else
						player.print("Selected area doesn't contain continuous chests.")
					end
				else
					player.print("Selected area has to be 1 row or 1 column.")
				end
			else
				player.print("Not enough chests found")
			end
		else
			player.print("Not enough chests found")
		end
	end
end

script.on_event(defines.events.on_player_selected_area, MergingChests.OnPlayerSelectedArea)
script.on_event(defines.events.on_tick, MergingChests.OnTick)