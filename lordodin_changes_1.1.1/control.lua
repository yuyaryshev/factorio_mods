current_kit = nil
require "./config"
require "kits"



script.on_event(defines.events.on_chunk_generated, function(e)
     for key, entity in pairs(e.surface.find_entities(e.area)) do
        local removeEntity = false
		-- If Entity is a tree, and the remove rate is greater than 0.
        if entity.type == "tree" and removeTrees > 0 then
			-- If remove rate is less than 1, chance it. 
			if removeTrees < 1 then
				rand = math.random()
				if rand < removeTrees then
					removeEntity = true
				end
			-- If remove rate is 1, don't waste processing time on random numbers, just remove it.
			else
				removeEntity = true
			end
		-- If entity is a rock, do same as above.
        elseif entity.name == "stone-rock" and removeRocks > 0 then
			-- If remove rate is less than 1, chance it. 
			if removeRocks < 1 then
				rand = math.random()
				if rand < removeRocks then
					removeEntity = true
				end
			-- If remove rate is 1, don't waste processing time on random numbers, just remove it.
			else
				removeEntity = true
			end
        end
		
		-- If we've designated it to be remove, remove it.
        if removeEntity then
            entity.destroy()
        end
    end
end)

script.on_event(defines.events.on_player_created,function(param)
	--get the joined player. This makes the code, that follows shorter
	local p=game.players[param.player_index]

	if not KEEP_INV then
		--clear all player inventories
		for i,v in pairs(defines.inventory) do
			pcall(function()
				p.get_inventory(v).clear()
			end)
		end
	end
	if current_kit.chest then
		local chest_entity = p.surface.create_entity({name = "steel-chest", position = p.position, force = p.force})
		local inv=chest_entity.get_inventory(1)
		for i,v in pairs(current_kit.chest) do
			inv.insert(v)
		end
	end
	
	local inv=p.get_inventory(defines.inventory.player_main)
	for i,v in pairs(current_kit.inv) do
		inv.insert(v)
	end
	
	inv=p.get_inventory(defines.inventory.player_quickbar)
	for i,v in pairs(current_kit.quick) do
		inv.insert(v)
	end
	
	pcall(function()
		p.get_inventory(defines.inventory.player_tools).insert({name="steel-axe",count=5})
	end)
	
	for n,t in pairs(p.force.technologies) do 
		if current_kit.researched_techs[t.name] then
			t.researched=true
		end
	end
end)


local lordodin_changes_target_version = "1.02"
local lordodin_changes_version 
script.on_event(defines.events.on_tick,function(param)
	if not lordodin_changes_version or lordodin_changes_version ~= lordodin_changes_target_version then
		lordodin_changes_version = lordodin_changes_target_version
		local p=game.players[1]
		local inv=p.get_inventory(defines.inventory.player_main)

--						inv.insert({name="electronic-circuit",count=500000})		

--								inv.insert({name="resin",count=100000})		

--						inv.insert({name="raw-wood",count=100000})
		
--							for n,t in pairs(p.force.technologies) do 
--								if current_kit.researched_techs[t.name] then
--									t.researched=true
--								end
--							end
		
		--p.surface.clear_pollution()
		
--						inv.insert({name="beltplanner",count=1})		
--						inv.insert({name="radar",count=20})		

--						inv.insert({name="lo-radio-transmitter",count=100})		
--						inv.insert({name="lo-radio-receiver",count=100})		
--						inv.insert({name="lo-radio-constant",count=100})		
--						inv.insert({name="power-switch",count=100})		
		
--						inv.insert({name="electric-mining-drill",count=100})		
--						inv.insert({name="assembling-machine-2",count=300})		
--						inv.insert({name="bob-greenhouse",count=40})		
--						inv.insert({name="steam-engine",count=100})		
--						inv.insert({name="boiler",count=50})		
--						inv.insert({name="inserter",count=500})		

		
--						inv.insert({name="electronic-circuit",count=8000})		
--						inv.insert({name="science-pack-1",count=100})		
--						inv.insert({name="copper-plate",count=1000})
--						inv.insert({name="iron-plate",count=10000})
--						inv.insert({name="medium-electric-pole",count=700})
--						inv.insert({name="inserter",count=1000})
--						inv.insert({name="stone-brick",count=10000})
--						inv.insert({name="stone-pipe",count=300})
--						inv.insert({name="deadlock-stack-raw-wood",count=10000})
--						inv.insert({name="filter-inserter",count=1000})
--						inv.insert({name="steel-chest",count=1000})
--						inv.insert({name="rail",count=5000})
--						inv.insert({name="rail-chain-signal",count=1500})
--						inv.insert({name="rail-signal",count=500})

		
--						inv.insert({name="electronic-circuit",count=18000})
--						inv.insert({name="roboport",count=2})
--						inv.insert({name="logistic-robot",count=100})
--						inv.insert({name="construction-robot",count=50})
--
--						inv.insert({name="logistic-chest-passive-provider",count=200})
--						inv.insert({name="logistic-chest-storage",count=4})
--						inv.insert({name="logistic-chest-requester",count=200})
--
--						inv.insert({name="deadlock-loader-item-1",count=100})		
--						inv.insert({name="switchbutton",count=50})		
--						inv.insert({name="gun-turret",count=50})		
--						inv.insert({name="firearm-magazine",count=500})		
--						inv.insert({name="inserter",count=100})		
--						inv.insert({name="big-electric-pole",count=150})		
--						inv.insert({name="inserter",count=200})		
--						inv.insert({name="stone-pipe",count=300})		
--						inv.insert({name="transport-belt",count=10000})		
--						inv.insert({name="iron-plate",count=7000})		
--						inv.insert({name="lead-plate",count=7000})		
--						inv.insert({name="tin-plate",count=7000})		
--						inv.insert({name="solder-plate",count=3000})		
--						inv.insert({name="copper-plate",count=7000})		
--						inv.insert({name="steel-plate",count=5000})		
--						inv.insert({name="science-pack-1",count=400})		
--						inv.insert({name="science-pack-2",count=400})		
	end
end)




function strDirection(d)
	if d == defines.direction.north	then
		return "north"
	end
	if d == defines.direction.east	then
		return "east"
	end
	if d == defines.direction.south	then
		return "south"
	end
	if d == defines.direction.west	then
		return "west"
	end
	return "unknown"
end


function MakeLine(s, e, m, proto, ddd)
	-- Creates a line with given s = start, e = end, m = mid_point
--	Make lines (start-end coordinates)
--	s.x, s.y
--	s.x, m
--	
--	s.x, m
--	e.x, m
--	
--	e.x, m
--	e.x, e.y
--	   for var=start,end,step do
--      ...
---    end
	if ddd < 0 then
		local ts = s
		s = e
		e = ts
	end


	local surface = proto.surface
	local dx
	local dy
	local hh
	local h_dir

	if not s or not e or not m or not proto.direction or not proto or not s.x or not e.x then
		game.players[1].print('Argument is nil');
		game.players[1].print(serpent.line({s=s,e=e,m=m,d=proto.direction}));
		return;
	end
	
	if proto.direction == defines.direction.south then
		hh = 1
	else
		hh = -1
	end

	if s.x < e.x then
		dx = 1
	else
		dx = -1
	end

	if hh*dx>0 then
		h_dir = defines.direction.east
	else
		h_dir = defines.direction.west
	end

	if s.y < e.y then
		dy = 1
	else
		dy = -1
	end
	
	for y=s.y, m-dy, dy do
		surface.create_entity{position={s.x, y}, direction=proto.direction, inner_name=proto.name, name="entity-ghost", force=proto.force}
	end

	for x=s.x, e.x-dx, dx do
		surface.create_entity{position={x, m}, direction=h_dir, inner_name=proto.name, name="entity-ghost", force=proto.force}
	end
	
	for y=m, e.y, dy do
		surface.create_entity{position={e.x, y}, direction=proto.direction, inner_name=proto.name, name="entity-ghost", force=proto.force}
	end
end

function getArea(entities)
	if not entities or #entities < 1 then
		return {{0,0},{0,0}}
	end

	local e = entities[1]	
	local bb = {{e.position.x, e.position.y},{e.position.x, e.position.y}}	
	for _,entity in ipairs(entities) do
		if bb[1][1] > entity.position.x then bb[1][1] = entity.position.x end
		if bb[2][1] < entity.position.x then bb[2][1] = entity.position.x end
		if bb[1][2] > entity.position.y then bb[1][2] = entity.position.y end
		if bb[2][2] < entity.position.y then bb[2][2] = entity.position.y end
	end
	return bb
end


function getEntitesInfo(entities)
	local a = getArea(entities)
	return {
		x1=a[1][1], 
		y1 = a[1][2], 
		x2 = a[2][1], 
		y2 = a[2][2], 
		w = a[2][1]-a[1][1], 
		h = a[2][2]-a[1][2], 
		area=a, 
		entities=entities
		}	
end

function BeltConnection_OnPlayerSelectedArea(event)	
local i
	if event.item and event.item == "beltconnect-planner" then
		local player = game.players[event.player_index]
		
		if event.area.right_bottom.y-event.area.left_top.y < 5 then
			player.print("Selected area height must be 5 or more tiles")
			return
		end

		local top_area = {{event.area.left_top.x, event.area.left_top.y},{event.area.right_bottom.x, event.area.left_top.y+2}}
		local bottom_area = {{event.area.left_top.x, event.area.right_bottom.y-2},{event.area.right_bottom.x, event.area.right_bottom.y}}
		local top_belts0 = player.surface.find_entities_filtered{area = top_area, type= "transport-belt"}
		local bottom_belts0 = player.surface.find_entities_filtered{area = bottom_area, type= "transport-belt"}
		
		table.sort(top_belts0, function(a,b) return a.position.x < b.position.x end)
		table.sort(bottom_belts0, function(a,b) return a.position.x < b.position.x end)
		
		local top_belts = getEntitesInfo(top_belts0)
		local bottom_belts = getEntitesInfo(bottom_belts0)
		
		local chest_belts
		local factory_belts
		if top_belts.w + bottom_belts.w > 0 then
			local d
			if top_belts.w < bottom_belts.w then
				chest_belts = top_belts
				factory_belts = bottom_belts
				d = -1
			else
				chest_belts = bottom_belts
				factory_belts = top_belts
				d = 1
			end
			
			if #(chest_belts.entities) < 1 then
				player.print("No belts indicating chest found")
				return
			end

			local ex1 = chest_belts.entities[1].position.x
			local ex2 = chest_belts.entities[#(chest_belts.entities)].position.x
			if ex1 == ex2 then
				ex2 = ex1+36
			end
			
			
			if factory_belts.h > 0.01 then
				player.print("Factory belts have different Y position")
				return
			end
						
			if chest_belts.h > 0.01 then
				player.print("Chest belts have different Y position")
				return
			end

			local sy = factory_belts.y1 + d
			local ey = chest_belts.y1 - d

--			sy = sy + 1
			
			local c = 0
			for i=1, #(factory_belts.entities), 1 do
				local entity = factory_belts.entities[i]
				if entity.position.x < ex1 then
					c = c + 1
				else
					break
				end
			end

			local c2 = 0
			for i=#(factory_belts.entities), 1, -1 do
				local entity = factory_belts.entities[i]
				if ex2 < entity.position.x then
					c2 = c2 + 1
				else
					break
				end
			end
			
			if c2 > c then
				c = c2
			end
			
			local dc = c - ey - sy
			if dc < 0 then
				player.print("Need more space! (" .. dc .. " tiles)")
			end
			
			local ec1 = 0
			local ec2 = 0
			
			for i=1, #(factory_belts.entities), 1 do
				local entity = factory_belts.entities[i]
				if entity.position.x < ex1 then
					MakeLine(entity.position, {x=ex1, y=ey}, ey-ec1*d, entity, d)
					ec1 = ec1 + 1
					ex1 = ex1 + 1
					if ex1>=ex2 or math.abs(ey-sy) <= ec1 then
						player.print("Break1")
						break
					end
				else
					player.print("Break2")
					break
				end
			end
			
			for i=#(factory_belts.entities), 1, -1 do
				local entity = factory_belts.entities[i]
				if ex2 < entity.position.x then
					MakeLine(entity.position, {x=ex2, y=ey}, ey-ec2*d, entity, d)
					ec2 = ec2 + 1
					ex2 = ex2 - 1
					if ex2<=ex1 or math.abs(ey-sy) <= ec2 then
						break
					end
				else
					break
				end
			end
			
			for i=1, #(factory_belts.entities), 1 do
				local entity = factory_belts.entities[i]
				if ex1 <= entity.position.x and entity.position.x <= ex2 then
					MakeLine(entity.position, {x=entity.position.x, y=ey}, ey, entity, d)
				end
			end			
			
		end
	end
end

function BeltConnection_OnBuilt(event)
	local built = event.created_entity
--	    -- invalid build or fake player build from pseudo-bot mods?
--		if not built or not built.valid or event.revived or not string.find(built.name, "deadlock-loader", 1, true) then return end
--	    local snap2inv = settings.get_player_settings(game.players[event.player_index])["deadlock-loaders-snap-to-inventories"].value
--	    local snap2belt = settings.get_player_settings(game.players[event.player_index])["deadlock-loaders-snap-to-belts"].value
--		-- no need to check anything if configs are off
--		if not snap2inv and not snap2belt then return end
--		-- check neighbours and snap if necessary
--	    local belt_end = get_neighbour_entities(built, built.direction)
--	    local loading_end = get_neighbour_entities(built, opposite[built.direction])
--	    -- belt-end detection by shanemadden
--	    if snap2belt and are_belt_facing(belt_end, opposite[built.direction]) then
--	        built.rotate( {by_player = event.player_index} )
--	    elseif snap2belt and are_belt_facing(belt_end, built.direction) then
--	        return
--	    -- no belts detected, check for adjacent inventories
--	    elseif snap2inv and not are_loadable(belt_end) and are_loadable(loading_end) then
--	        built.rotate( {by_player = event.player_index} )
--	    elseif snap2inv and are_loadable(belt_end) and not are_loadable(loading_end) then
--	        built.direction = opposite[built.direction]
--	        if not snap2belt or not are_belt_facing(loading_end, built.direction) then
--	            built.rotate( {by_player = event.player_index} )
--	        end
--	    -- no inventories, check for inventory-end belts
--	    elseif snap2belt and are_belt_facing(loading_end, built.direction) then
--	        built.direction = opposite[built.direction]
--	        built.rotate( {by_player = event.player_index} )
--	    elseif snap2belt and are_belt_facing(loading_end, opposite[built.direction]) then
--	        built.direction = opposite[built.direction]
--	    end
end

script.on_event(defines.events.on_player_selected_area, 	BeltConnection_OnPlayerSelectedArea)
--script.on_event(defines.events.on_player_alt_selected_area, BeltConnection_OnPlayerAltSelectedArea)
script.on_event(defines.events.on_built_entity, BeltConnection_OnBuilt)
