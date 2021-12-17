-- this mod in runtime stores list of chunks with inserters instead of storing list of all inserters on map
-- 1) don't need to save, load, migrate, validate it, just rebuild on_load, - more stable since reloading the game will reset the mod
-- 2) chunks list is much shorter than list of inserters
-- 3) searches and updates are done inside one chunk which MAYBE faster due to game optimizations

local max_chunks_per_tick = 1000
local init_done = false
local chunks_with_inserters = nil
local last_checked_index = 0

local inserters_antifreeze_debug_mode = false

local total_inserters_count = 0

function debug_print(s)
	if inserters_antifreeze_debug_mode then
		game.print("InsertersAntifreeze:"..s)
	end
end



function positionKey(position)
	return "x" .. position.x .. "y".. position.y
end



function next_chunk_to_check()
	if chunks_with_inserters == nil then
		chunks_with_inserters = {}
	
		---- DEBUG INIT - NEAR PLAYER ONLY ----------
--		if inserters_antifreeze_debug_mode then
--			local cc = get_chunk(game.players[1].position)
--			local srf = game.surfaces["nauvis"]
--			
--			table.insert(chunks_with_inserters, { surface=srf, chunk={x = cc.x-1, y = cc.y-1}})
--			table.insert(chunks_with_inserters, { surface=srf, chunk={x = cc.x  , y = cc.y-1}})
--			table.insert(chunks_with_inserters, { surface=srf, chunk={x = cc.x+1, y = cc.y-1}})
--			table.insert(chunks_with_inserters, { surface=srf, chunk={x = cc.x-1, y = cc.y  }})
--			table.insert(chunks_with_inserters, { surface=srf, chunk={x = cc.x  , y = cc.y  }})
--			table.insert(chunks_with_inserters, { surface=srf, chunk={x = cc.x+1, y = cc.y  }})
--			table.insert(chunks_with_inserters, { surface=srf, chunk={x = cc.x-1, y = cc.y+1}})
--			table.insert(chunks_with_inserters, { surface=srf, chunk={x = cc.x  , y = cc.y+1}})
--			table.insert(chunks_with_inserters, { surface=srf, chunk={x = cc.x+1, y = cc.y+1}})
--			if true then
--				return nil
--			end
--		end
		----------------------------------------------
	
		for _,surface in pairs(game.surfaces) do 
			for chunk in surface.get_chunks() do 
				table.insert(chunks_with_inserters, {surface=surface, chunk=chunk} )
			end
		end
		return nil	-- don't do any work here, because previous loop can be heavy, suspend until next on_tick event
	end
	
	if last_checked_index <= 0 then
--		debug_print("Next iteration starting, total_inserters_count = "..total_inserters_count.."(on_prev_iteration) #chunks_with_inserters = "..#chunks_with_inserters)
		last_checked_index = #chunks_with_inserters
		if last_checked_index <= 0 then		-- no inserters on map
			return nil
		end
	else
		last_checked_index = last_checked_index - 1
		if last_checked_index % 100 == 0 then
--			debug_print("last_checked_index = "..last_checked_index)
		end
	end
	
	return chunks_with_inserters[last_checked_index]
end

function remove_last_chunk()
	if chunks_with_inserters ~= nil and #chunks_with_inserters > 0 then
		-- optimization: if removing from middle of table - swap with the end and then - remove from the end - will be o(1) instead of o(N)
		if last_checked_index < #chunks_with_inserters then
			chunks_with_inserters[last_checked_index] = chunks_with_inserters[#chunks_with_inserters]
		end
		table.remove(chunks_with_inserters)
	end
	
	-- last_checked chunk was removed, so on it's place an unchecked one - restore last_checked_index to previous value
	last_checked_index = last_checked_index + 1
end



function chunk_area(chunk)
	return {{chunk.x * 32, chunk.y * 32}, {chunk.x * 32 + 32, chunk.y * 32 + 32}}
end 



function get_chunk(position)
	return {x = math.floor(position.x / 32), y = math.floor(position.y / 32)}
end 



script.on_event(defines.events.on_tick, function(event)
--	debug_print("on_tick")

local n_chunks = 0
for n_chunks = 0,max_chunks_per_tick do
	local c = next_chunk_to_check()
	if c == nil then
		break
	end

	local inserters = c.surface.find_entities_filtered{area=chunk_area(c.chunk), type = "inserter"}
	if inserters == nil or #inserters <= 0 then
		-- remove empty chunk from list
		remove_last_chunk()
	else
		for _, inserter in pairs(inserters) do
			if positionKey(get_chunk(inserter.position)) ~= positionKey(c.chunk) then
				debug_print("Out of chunk inserter="..positionKey(get_chunk(inserter.position))..", chunk=" ..positionKey(c.chunk))
			end
		
			if inserter.held_stack ~= nil and inserter.held_stack.valid_for_read and inserter.drop_target ~= nil 
				and not inserter.drop_target.can_insert(inserter.held_stack) 
				and inserter.pickup_target ~= nil
				and inserter.pickup_target.can_insert(inserter.held_stack) 
				then
				local key = positionKey(inserter.position)
				debug_print("Found frozen inserter inserter.held_stack.count = "..inserter.held_stack.count ..", key = "..key)
			
				-- only check inserters that are not yet in list
				if global.inserters_restore_list == nil or global.inserters_restore_list[key] == nil then
					local v_drop_position = inserter.drop_position
					local v_pickup_position = inserter.pickup_position

					local stored_data = 
						{
						entity					= inserter, 
						direction				= inserter.direction,
						drop_position			= inserter.drop_position,
						pickup_position			= inserter.pickup_position
						}

					-- Next two idiotic lines are to make inserter actually move. Without this changing drop_position and pickup_position won't work
					inserter.direction = defines.direction.north -- change direction
					inserter.direction = defines.direction.south -- in case if direction already was south this will change it
					
					-- swap inserter's positions
					inserter.drop_position					= stored_data.pickup_position
					inserter.pickup_position				= inserter.position
					stored_data.modified_direction			= inserter.direction
					stored_data.modified_drop_position		= positionKey(inserter.drop_position)
					stored_data.modified_pickup_position	= positionKey(inserter.position)

					-- store inserters data to restore it later				
					if global.inserters_restore_list == nil then
						global.inserters_restore_list = {}
					end
					global.inserters_restore_list[key] = stored_data
				end
			end
		end
--		debug_print("Done "..n_chunks.." chunks, last was with #inserters = "..#inserters)
		break -- this chunk had some inserters, so exit (check just one non-empty chunk on each tick)
	end
end

if n_chunks > 1 then
	debug_print("Done "..n_chunks.." chunks")
end


if global.inserters_restore_list == nil then -- or (event.tick % 10) ~= 7 then
	return
end

-- should check often, because inserter should have time to take anything before we restore it back
local inserters_restore_list_count = 0
for key, stored_inserter in pairs(global.inserters_restore_list) do
	if not stored_inserter.entity.valid then
		debug_print("Removed invalid inserter")
		global.inserters_restore_list[key] = nil
	else
		inserters_restore_list_count = inserters_restore_list_count + 1

		-- have this inserter released his hand?	
		if stored_inserter.entity.held_stack == nil or not stored_inserter.entity.held_stack.valid_for_read then		
			-- I check all this to ensure that player manually didn't changed any parameters of inserter during restore cycle
			if stored_inserter.entity.direction == defines.direction.south 
			and positionKey(stored_inserter.entity.drop_position) == stored_inserter.modified_drop_position
			and positionKey(stored_inserter.entity.pickup_position) == stored_inserter.modified_pickup_position
			then	
				debug_print("Restoring inserter "..key)
				-- Next lines is to make inserter actually move. Without this changing drop_position and pickup_position won't work
				stored_inserter.entity.direction			= defines.direction.north -- change direction
				stored_inserter.entity.direction			= defines.direction.south -- in case if direction already was south this will change it
				
				-- restore all parameters
				stored_inserter.entity.direction			= stored_inserter.direction
				stored_inserter.entity.drop_position		= stored_inserter.drop_position
				stored_inserter.entity.pickup_position		= stored_inserter.pickup_position
			end
			
			debug_print("Removing from list")
			global.inserters_restore_list[key] = nil		-- touched by player remove from list and don't do anything to it
			inserters_restore_list_count = inserters_restore_list_count - 1
		end
	end
end

--debug_print("Frozen list size = "..inserters_restore_list_count)

-- If no frozen insertest exist, then destroy the table, so on_tick will perform faster on next iteration
if inserters_restore_list_count <=0 then
	global.inserters_restore_list = nil
end

end)
