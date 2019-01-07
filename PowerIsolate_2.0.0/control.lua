
local function getKey(entity)
	return "x" .. entity.position.x .. "y".. entity.position.y
end

function IsolateElectric_OnPlayerSelectedArea(event)	
	if event.item and event.item == "isolate-planner" then
		local player = game.players[event.player_index]
		
		local inner_entities = {}

		-- gather all entities inside selected area
		for _,entity in ipairs(event.entities) do
			if entity.prototype.max_wire_distance ~= nil then
				local key = getKey(entity)
				inner_entities[key] = entity
			end
		end
		
		-- remove connections to entities outside this area
		for _,entity in pairs(inner_entities) do
			for _,neighbour in pairs(entity.neighbours["copper"]) do
				if inner_entities[getKey(neighbour)] == nil then
					entity.disconnect_neighbour(neighbour)
				end
			end
		end		
	end
end


function IsolateElectric_OnPlayerAltSelectedArea(event)	
	if event.item and event.item == "isolate-planner" then
		local player = game.players[event.player_index]
		
		-- Remove all circuits connection
		for _,entity in ipairs(event.entities) do
			if entity.prototype.max_wire_distance ~= nil then
				entity.disconnect_neighbour(defines.wire_type.red)
				entity.disconnect_neighbour(defines.wire_type.green)
			end
		end
	end
end


function IsolateElectric_GatherLockedNetwork(k, entity)
	if not global.IsolateElectric then
		global.IsolateElectric = {}
	end
	global.IsolateElectric.LockedElectricNetwork[k] = true
	for _,neighbour in pairs(entity.neighbours["copper"]) do
		local k2 = getKey(neighbour)
		if not global.IsolateElectric.LockedElectricNetwork[k] then
			IsolateElectric_GatherLockedNetwork(k2, entity)
		end
	end
end

function IsolateElectric_OnPlayerBuiltEntity(event)	
	local player = game.players[event.player_index]
	local entity = event.created_entity
	if not global.IsolateElectric then
		global.IsolateElectric = {}
	end

	
	if entity and entity.type == "electric-pole" and global.IsolateElectric.LockedElectricNetwork then
		local k = getKey(entity)
	
		local is_connected_to_locked_network = false
		local some_connections_are_deleted = false
		for _,neighbour in pairs(entity.neighbours["copper"]) do
			local k2 = getKey(neighbour)
			if global.IsolateElectric.LockedElectricNetwork[k2] then
				is_connected_to_locked_network = true
			end
		end		
	
		if is_connected_to_locked_network then
			-- Add new pole to the locked network
			global.IsolateElectric.LockedElectricNetwork[k] = true
			
			for _,neighbour in pairs(entity.neighbours["copper"]) do
				local k2 = getKey(neighbour)
				if not global.IsolateElectric.LockedElectricNetwork[k2] then
					entity.disconnect_neighbour(neighbour)
					some_connections_are_deleted = true
				end
			end
		end
		
		if global.IsolateElectric.LastPlacedKey == k and some_connections_are_deleted then
			-- Player is placing pole over and over again trying to figure out "Why the hell it isn't connecting?", so let's help him...
			player.print("Electric network locked mode deleted some copper connections. Turn in off with 'Lock electric network' hotkey.")
		else
			global.IsolateElectric.LastPlacedKey = k
		end
	end
end

script.on_event("powerisolate-lock-electric-network", function(event)
	local player = game.players[event.player_index]
	local entity = player.selected

	if not global.IsolateElectric then
		global.IsolateElectric = {}
	end
	
	if global.IsolateElectric.LockedElectricNetwork then
		global.IsolateElectric.LockedElectricNetwork = nil
		player.print("Unlocked electric network.")
	else
		if entity and entity.type == "electric-pole" then
			global.IsolateElectric.LockedElectricNetwork = {}
			IsolateElectric_GatherLockedNetwork(getKey(entity),entity)
			player.print("Locked on this electric network. All new built poles will only connect to this network and will be isolated from other electric networks.")
		else
			player.print("Select an electric pole to lock an electric network")
		end
	end
end)

script.on_event(defines.events.on_player_selected_area, 	IsolateElectric_OnPlayerSelectedArea)
script.on_event(defines.events.on_player_alt_selected_area, IsolateElectric_OnPlayerAltSelectedArea)

-- Only player can use 'Lock electric network' since robots don't build poles in sequence, so the algorithm just won't work with them.
script.on_event(defines.events.on_built_entity,				IsolateElectric_OnPlayerBuiltEntity)



