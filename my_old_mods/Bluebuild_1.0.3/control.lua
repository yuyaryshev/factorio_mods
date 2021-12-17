-- require("serpent") --For debug only

local construction_delay = 1
local deconstruction_delay = 1
local tick_active = 0

function activate(r)
--	game.print("Activated!"..r)
	tick_active = game.tick
end

-- Find ghosts to place.  Then find buildings to destruct.
function runOnce()
	global.runOnce = true
	if not global.blueBuildFirstTick then
		global.blueBuildFirstTick = {}
	end
	if not global.bluePositions then
		global.bluePosition = {}
	end
	if not global.blueBuildToggle then
		global.blueBuildToggle = {}
	end
	if not global.blueDemoToggle then
		global.blueDemoToggle = {}
	end
	if not global.blueLastDemo then
		global.blueLastDemo = {}
	end
end

function initPlayer(event)
	if not global.runOnce then
		runOnce()
	end
	global.blueBuildToggle[event.player_index] = true
	global.blueDemoToggle[event.player_index] = true
	global.blueBuildFirstTick[event.player_index] = game.tick
	global.blueLastDemo[event.player_index] = game.tick
end

function playerloop()
	if not global.runOnce then
		runOnce()
	end
	
	for iPlayer = 1, #game.players do
		if game.players[iPlayer].connected then
			bluecheck(game.players[iPlayer])
		end
	end
end

function bluecheck(builder)
	local pos = builder.position
	--game.print("Checking player.")
	-- if global.bluePosition[builder.index] and global.bluePosition[builder.index] == pos then
	if global.bluePosition[builder.index] and global.bluePosition[builder.index].x == pos.x and global.bluePosition[builder.index].y == pos.y then
		--We haven't moved.  Good, let's continue.
		--game.print("Player hasn't moved.")
		if global.blueBuildFirstTick[builder.index] and game.tick > global.blueBuildFirstTick[builder.index] + construction_delay then		
			if global.blueBuildToggle[builder.index] == true then
				-- Make magic happen.
				global.blueBuildFirstTick[builder.index] = game.tick
				if bluebuild(builder) == true then
					--global.blueBuildFirstTick[builder.index] = game.tick --Make this happen by default to reduce how often it's checked.
					return
				end
			end
			if global.blueDemoToggle[builder.index] == true then
				if global.blueLastDemo[builder.index] then
					-- Destructive magic happens here
					global.blueBuildFirstTick[builder.index] = game.tick
					if bluedemo(builder) == true then
						global.blueLastDemo[builder.index] = game.tick
					end
				else
					global.blueLastDemo[builder.index] = game.tick
				end
			end
		end
	else
		-- Player moved.  Reset progress.
		global.bluePosition[builder.index] = pos
		global.blueBuildFirstTick[builder.index] = game.tick
	end
end

function bluebuild(builder)
	local pos = builder.position
	-- local reachDistance = data.raw.player.player.reach_distance
	local reachDistance = 25
	local searchArea = {{pos.x - reachDistance, pos.y - reachDistance}, {pos.x + reachDistance, pos.y + reachDistance}}
	local areaList = builder.surface.find_entities_filtered{area = searchArea, type = "entity-ghost", force=builder.force }
	local tileList = builder.surface.find_entities_filtered{area = searchArea, type = "tile-ghost", force=builder.force }
	-- Merge the lists
	for key, value in pairs(tileList) do
		if not areaList then
			areaList = {}
		end
		table.insert(areaList, value)
	end
	-- game.print("Found " .. #areaList .. " ghosts in area.")
	for index, ghost in pairs(areaList) do
		--Should not need to check force again.
		--if builder.can_reach_entity(ghost) and builder.force == ghost.force then
		if builder.can_reach_entity(ghost) then
			activate("bluebuild")
			-- game.print("Checking for items in inventory.")
			local materials = ghost.ghost_prototype.items_to_place_this
			local moduleList
			if ghost.type == "entity-ghost" then
				moduleList = ghost.item_requests --{"name"=..., "count"=...}
			end
			for __, item in pairs(materials) do
				if builder.get_item_count(__) > 0 then
					if ghost.type == "tile-ghost" then
						builder.remove_item({name=__})
						ghost.revive()
						return true
					end
					local tmp, revive = ghost.revive()
					-- game.print("Placing item " .. revive.name .. ".")
					if revive and revive.valid then
						for ___, moduleItem in pairs(moduleList) do
						-- game.print("moduleList == " .. moduleItem.item )
							if builder.get_item_count(moduleItem.item) > 0 then
								local modStack = {name=moduleItem.item, count=math.min(builder.get_item_count(moduleItem.item), moduleItem.count)}
								revive.insert(modStack)
								builder.remove_item(modStack)
							end
						end
						-- game.print("Removing item from inventory.")
						game.raise_event(defines.events.on_put_item, {position=revive.position, player_index=builder.index, name="on_put_item"})
						game.raise_event(defines.events.on_built_entity, {created_entity=revive, player_index=builder.index, tick=game.tick, name="on_built_entity"})
						
						builder.remove_item({name=__})
						return true
					end
				end
			end
		end
	end
	-- Are we still here?
	return false
end		

function bluedemo(builder)
	local pos = builder.position
	--local reachDistance = data.raw.player.player.reach_distance
	local reachDistance = 25
	local searchArea = {{pos.x - reachDistance, pos.y - reachDistance}, {pos.x + reachDistance, pos.y + reachDistance}}
	local areaList = builder.surface.find_entities(searchArea)
	local areaListCleaned = {}
	
	-- Clean areaList
	for index, ent in pairs(areaList) do
		if ent and ent.valid and ent.to_be_deconstructed(game.forces.player)  then --and builder.can_reach_entity(ent)
			table.insert(areaListCleaned, ent)
		end
	end
	--game.print("Found " .. #areaListCleaned .. " demo targets in area.")
	--Now calculate mining time and destroy
	for index, ent in pairs(areaListCleaned) do
		local isTile = false
		if ent.name == "deconstructible-tile-proxy" then --In case we're trying to demo floor tiles.
			ent = ent.surface.get_tile(ent.position)
			--game.print(ent.prototype.mineable_properties)
			local products = ent.prototype.mineable_properties.products
			for key, value in pairs(products) do
				builder.insert({name=value.name, count=math.random(value.amount_min, value.amount_max)})
			end
			builder.surface.set_tiles({{name=ent.hidden_tile, position=ent.position}})
			return true
		end
		
		if deconstruction_delay < game.tick - global.blueLastDemo[builder.index] then --ent.prototype.mineable_properties.miningtime * 60  or string.find(ent.type, "tree") then
			activate("bluedemo")
			-- Add inventory of the destroyed
			-- game.print("Destroyed inventory: " .. serpent.line(ent.get_inventory(defines.inventory.item_main)))
			for inv, def in pairs(defines.inventory) do
				local inventory = ent.get_inventory(def)
				if inventory and inventory.valid then
					contents = inventory.get_contents()
					if contents then
						--game.print("Inventory " .. serpent.line(def) .. " contents: " .. serpent.line(contents))
						for key, value in pairs(contents) do
							local inserted = builder.insert({name=key, count=value})
							if inserted > 0 then
								ent.remove_item({name=key, count=inserted})
							end
							if inserted == 0 or not inserted == value then --Not enough inventory!
								builder.surface.create_entity({name="flying-text", position=builder.position, text="Inventory Full"})
								return true
							end
						end
					end
				end
			end
			--Add mining products
			local products = ent.prototype.mineable_properties.products			
			local inserted = 0
			if products then
				-- game.print("Products: " .. serpent.line(products))
				for key, value in pairs(products) do
					inserted = builder.insert({name=value.name, count=math.random(value.amount_min, value.amount_max)})
				end
			end
			-- Is the destroyed item a item-entity?
			if not isTile and ent.type == "item-entity" then
				inserted = builder.insert({name=ent.stack.name, count=ent.stack.count})
			end
			-- Was anything inserted?  If not, end here so we don't destroy the entity
			if inserted == 0 then
				builder.surface.create_entity({name="flying-text", position=builder.position, text="Inventory Full"})
				game.print(ent.name) -- Debug
				return true
			end
			game.raise_event(defines.events.on_preplayer_mined_item, {entity=ent, player_index=builder.index, name="on_preplayer_mined_item"})
			ent.destroy()
			return true
			
		end
	end
	return false
end

script.on_event(defines.events.on_player_joined_game, function(event)
	initPlayer(event)
end)
		

script.on_event(defines.events.on_tick, function(event)
if event.tick - tick_active < 60 or ((event.tick % 60) == 49) then 
	playerloop()
end
end)

script.on_event('bluebuild-autobuild', function(event)
	activate("bluebuild-autobuild")
	global.blueBuildToggle[event.player_index] = not global.blueBuildToggle[event.player_index]
	if global.blueBuildToggle[event.player_index] then
		game.players[event.player_index].print("Bluebuild autobuild set to True.")
	else
		game.players[event.player_index].print("Bluebuild autobuild set to False.")
	end
	global.blueBuildFirstTick[event.player_index] = game.tick
end)

script.on_event('bluebuild-autodemo', function(event)
	activate("bluebuild-autodemo")
	global.blueDemoToggle[event.player_index] = not global.blueDemoToggle[event.player_index]
	if global.blueDemoToggle[event.player_index] then
		game.players[event.player_index].print("Bluebuild autodemo set to True.")
	else
		game.players[event.player_index].print("Bluebuild autodemo set to False.")
	end
	global.blueBuildFirstTick[event.player_index] = game.tick
end)

script.on_configuration_changed(function()
	runOnce()
end)