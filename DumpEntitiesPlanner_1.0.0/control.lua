local filename = "dump_entities.lua"

function lo_dump(lua_table)
	return serpent.dump(lua_table, 
		{
		--nocode = true, 
		sortkeys = true, 
		comment = true, 
		indent = "	",
		})
end

function dump_entity(e)
	return
		{
			name		= e.name,
			position	= e.position,
			direction	= e.direction,
		}
end

function DumpEntitiesPlanner_OnPlayerSelectedArea(event)	
	if event.item and event.item == "dump-entities-planner" then
		local dump_table = {}
		local player = game.players[event.player_index]
		
		for _,entity in ipairs(event.entities) do
			table.insert(dump_table,  dump_entity(entity))
		end
		
		player.print('Dump =')
		local dump_string = lo_dump(dump_table)
		game.write_file(filename , dump_string, false, player.index)		
		player.print("'"..filename.."' - dump saved")
		
	end
end

script.on_event(defines.events.on_player_selected_area, 	DumpEntitiesPlanner_OnPlayerSelectedArea)
script.on_event(defines.events.on_player_alt_selected_area, DumpEntitiesPlanner_OnPlayerSelectedArea)



