local PAUSE = 1

--local instant_construct = true
--local instant_deconstruct = true

local instant_construct = false
local instant_deconstruct = false

--[[
local BUILD_HAND  = 20
local BUILD_IRON  = 15
local BUILD_STEEL = 10

local BUILD_DURATION_DECREASE = 20
]]
local MAX_BUILD_DISTANCE = 32
local selection_distance = 0

local table_sort =   table.sort
local math_abs = math.abs
local math_min = math.min
local math_max = math.max
local math_ceil = math.ceil
local math_floor = math.floor
local math_random = math.random

local string_format = string.format

local MOD_NAME = "ght-bluebuild"
local PROGRESSBAR = "ght-bluebuild-deconstruction"

-- global tables
local State
local Enabled

-- forward declaration
local increase_total
local decrease_total

local add_pending_construction
local add_pending_deconstruction

local DISABLED = false

--
-- item handling
--

-- LordOdin's [2 of 4] begin
function is_ghost(entity)
	return entity and entity.valid and (entity.type == "entity-ghost" or entity.type == "tile-ghost" or entity.name == "entity-ghost" or entity.name == "tile-ghost" or entity.name == "item-request-proxy")
end
-- LordOdin's [2 of 4] end

-- possible optimization: player main inventory, if sorted: inv[#inv]
local function get_empty_stack(inv, last_empty)
    for i = (last_empty or 0) + 1, #inv do
        local stack = inv[i]
        if not stack.valid_for_read then
            return stack, i
        end
    end

    return nil
end

local function add_ammo(inv, ammo, amount)
    -- adds only to existing stacks
    local total = 0
    for i = 1, #inv do
        local stack = inv[i]
        if stack.valid_for_read and stack.name == ammo then
            local added = stack.add_ammo(amount)

            if added < amount then
                total = total + added
                amount = amount - added
            else
                return total + amount
            end
        end
    end

    return total
end

local function add_durability(inv, name, amount)
    -- adds only to existing stacks
    local total = 0
    for i = 1, #inv do
        local stack = inv[i]
        if stack.valid_for_read and stack.name == name then
            local added = stack.add_durability(amount)
            if added < amount then
                total = total + added
                amount = amount - added
            else
                return total + amount
            end
        end
    end

    return total
end

local function move_stack(dst, stack)
    local proto = stack.prototype

    if stack.type == 'blueprint' or proto.inventory_size or proto.equipment_grid then
        local empty = get_empty_stack(dst)
        if not (empty and empty.set_stack(stack)) then
            return false
        end

    elseif proto.magazine_size then
        local amount = (stack.count - 1) * proto.magazine_size + stack.ammo
        local added = add_ammo(dst, stack.name, amount)

        if added < amount then
            stack.drain_ammo(added)
            local empty = get_empty_stack(dst)
            if not (empty and empty.set_stack(stack)) then
                return false
            end
        end

    elseif proto.durability then
        local amount = (stack.count - 1) * proto.durability + stack.durability
        local added = add_durability(dst, stack.name, amount)

        if added < amount then
            stack.drain_durability(added)
            local empty = get_empty_stack(dst)
            if not (empty and empty.set_stack(stack)) then
                return false
            end
        end

    else
        local added = dst.insert(stack)
        if added < stack.count then
            stack.count = stack.count - added
            return false
        end
    end

    stack.clear()
    return true
end

local function move_inventory(dst, src)
    local all = true

    for i = #src, 1, -1 do
        local stack = src[i]
        if stack.valid_for_read then
            if not move_stack(dst, stack) then
                all = false
            end
        end
    end

    return all
end

local function inv_remove_item_with_health(inv, item)
    assert(not item.ammo, "remove of item with ammo is not supported yet")
    assert(not item.duration, "remove of item with duration is not supported yet")

    local name = item.name

    for i = 1, #inv do
        local stack = inv[i]
        if stack.valid_for_read then
            if stack.name == name then
                if stack.health == 1 and item.health == 1 then
                    if stack.count >= item.count then
                        stack.count = stack.count - item.count
                        return
                    end
                end
            end
        end
    end

    assert(false, "could not remove item with health")
end

local function atomic_insert(inv, items)
    local total = {}
    local ok = true
    for _, item in pairs(items) do
        if (not item.type) or item.type == "item" then
            item.count = item.count or 1
            local added = inv.insert(item)

            -- assert(not item.health, "item health not suppored")
            assert(not item.ammo, "item with partly ammo not supported")
            assert(not item.durability, "item with durability not supported")

            if added < item.count then
                if added > 0 then
                    total[#total + 1] = {name = item.name, count = added, health = item.health}
                end
                ok = false
                break
           end
           total[#total + 1] = item
        elseif item.type == "fluid" then
            -- just skip fluids
        else
            assert(false, string_format("item of type %s is not supported", item.type))
        end
    end

    if ok then return true end

    for _, item in pairs(total) do
        assert(not item.ammo, "remove of item with ammo is not supported yet")
        assert(not item.duration, "remove of item with duration is not supported yet")
        if item.health then
            inv_remove_item_with_health(inv, item)
        else
            local removed = inv.remove(item)
            assert(removed == item.count)
        end
    end

    return false
end

--
-- construction
--

local player_inventories = {
    defines.inventory.player_main,
    defines.inventory.player_quickbar,
}


local function construct_entity(player, tick, state, ghost)
    local proto = ghost.ghost_prototype
    local material
    local materials = proto.items_to_place_this

    local inventory
    for _, inventory_id in pairs(player_inventories) do
        inventory = player.get_inventory(inventory_id)

        -- find an item we can use to build this ghost
        local empty = true
        for name, material_proto in pairs(materials) do
            empty = false
            if inventory.get_item_count(name) > 0 then
                material = name
                break
            end
        end
        if material then
            break
        end
    end

    assert(not empty, "with what should we build it?")

    if not material then return false, "no-material" end

    -- remove items, which collide with the new entity
    local item_area = game.entity_prototypes["item-on-ground"].collision_box
    local entity_pos  = ghost.position
    local entity_area = proto.collision_box

    local area = {
        {
            entity_pos.x + entity_area.left_top.x - item_area.right_bottom.x,
            entity_pos.y + entity_area.left_top.y - item_area.right_bottom.y
        }, {
            entity_pos.x + entity_area.right_bottom.x - item_area.left_top.x,
            entity_pos.y + entity_area.right_bottom.y - item_area.left_top.y
        }
    }

    local items = ghost.surface.find_entities_filtered{name = "item-on-ground", area = area}

    local clear = true
    for _, item in pairs(items) do
        clear = false
        if not item.to_be_deconstructed(ghost.force) then
            item.order_deconstruction(ghost.force)
            script.raise_event(defines.events.on_marked_for_deconstruction, {
                name = defines.events.on_marked_for_deconstruction,
                tick = tick,
                player_index = player.index,
                entity = item,
                mod = MOD_NAME,
            })
        end
    end

    if not clear then return false, "blocked-by-items" end

    local items, revive, proxy = ghost.revive(true)

    if not items then return false, "blocked" end

    local empty = true
    for name, count in pairs(items) do
        empty = false
        break
    end
    assert(empty)

    local stack = inventory.find_item_stack(material)
    assert(stack, "we search it, should be there")

    if revive.health then
        revive.health = revive.health * stack.health
    end
    stack.count = stack.count - 1

    script.raise_event(defines.events.on_built_entity, {
        name = defines.events.on_built_entity,
        tick = tick,
        player_index = player.index,
        created_entity = revive,
        mod = MOD_NAME,
    })

    if proxy then
        add_pending_construction(player, tick, state, proxy)
    end

    return true
end


local function construct_tile(player, ghost)
    local ghost_proto = ghost.ghost_prototype
    local materials = ghost_proto.items_to_place_this

    for name, proto in pairs(materials) do
        if player.get_item_count(name) > 0 then
            ghost.revive()
            player.remove_item{name = name}

            return true
        end
    end

    return false, 'no-material'
end

local function sort_by_pos_cb(a,b,x,y)
    local pos_a, pos_b = a.position, b.position
    local a_x, a_y, b_x, b_y = pos_a.x, pos_a.y, pos_b.x, pos_b.y

    local ra_x = math_abs(a_x - x)
    local ra_y = math_abs(a_y - y)
    local rb_x = math_abs(b_x - x)
    local rb_y = math_abs(b_y - y)

    local dist_a = math_max(ra_x, ra_y)
    local dist_b = math_max(rb_x, rb_y)

    if dist_a < dist_b then
        return true
    elseif dist_a > dist_b then
        return false
    end

    if a_y < b_y then
        return true
    elseif a_y > b_y then
        return false
    end

    if a_x < b_x then
        return true
    elseif a_x > b_x then
        return false
    end

end

local function sort_by_pos(t,x,y)
    x = math.floor(x * 2) / 2
    y = math.floor(y * 2) / 2
    table_sort(t, function(a,b) return sort_by_pos_cb(a,b,x,y) end)
end

local function is_inside_build_distance(e,bd2,x,y)
-- LordOdin's [1 of 4] begin
	return true
-- LordOdin's [1 of 4] end
end

local function get_construction_list(player, tick, state)
    local list = state.construction_list

    if not list then
        local pos = player.position
        local pos_x = pos.x
        local pos_y = pos.y

        local build_distance = MAX_BUILD_DISTANCE+selection_distance
		selection_distance = 0
        local bd2 = build_distance * build_distance

	local area =  {{pos_x - build_distance, pos_y - build_distance}, {pos_x + build_distance, pos_y + build_distance}}
        local find =  player.surface.find_entities_filtered
        local force = player.force

	local entities = find{area = area, force = force, type = "entity-ghost" }
	local tiles =    find{area = area, force = force, type = "tile-ghost" }
        -- TODO: factorio 0.15
	local proxy =    find{area = area, force = force, name = "item-request-proxy" }
	
	-- LordOdin's [3 of 4] begin
	if player.mod_settings["ght-bluebuild-tool-only"].value then
		entities = {}
		tiles = {}
		proxy = {}

		if state['selected_entities'] then
			local old_state_entities = state['selected_entities']
			state['selected_entities'] = {}
			for _, elm in pairs(old_state_entities) do
				if is_ghost(elm) then
					table.insert(entities, elm)
					table.insert(state['selected_entities'], elm)
				end
			end		
		end
	end
	-- LordOdin's [3 of 4] end

        list = {}

        for _, tab in pairs{entities, tiles, proxy} do
            if tab then
                for _, elm in pairs(tab) do
                    if is_inside_build_distance(elm, bd2, pos_x, pos_y) then
                        list[#list + 1] = elm
                    end
                end
            end
        end

        sort_by_pos(list, pos_x, pos_y)

        list.e = #list + 1
        list.s = 1

        state.construction_list = list
        state.construction_start = tick
    end

    return list
end

add_pending_construction = function (player, tick, state, entity)
    local list = state.construction_pending or { s = 1, e = 1 }
    state.construction_pending = list

    list[list.e] = entity
    list.e = list.e + 1

    state.construction_pending_since = state.construction_pending_since or tick
end

add_pending_deconstruction = function(player, tick, state, entity)
    local list = state.deconstruction_pending or { s = 1, e = 1 }
    state.deconstruction_pending = list

    list[list.e] = entity
    list.e = list.e + 1

    state.deconstruction_pending_since = state.deconstruction_pending_since or tick
end

local function try_insert(player, entity, name)
    local inserted = entity.insert{name = name}
    return inserted == 1
end

local function handle_request_proxy(player, tick, state, proxy)
    local main     = player.get_inventory(defines.inventory.player_main)
    local quickbar = player.get_inventory(defines.inventory.player_quickbar)

    local entities = player.surface.find_entities_filtered{force = player.force, position = proxy.position}
    local entity
    for _, e in pairs(entities) do
        if e.name ~= "item-request-proxy" then
            assert(not entity, "multiple entities under item-request-proxy")
            entity = e
        end
    end

    local requested = proxy.item_requests
    local new_requests = {}

    local executed = false
    for name, amount in pairs(requested) do
        if not executed then
            if main.get_item_count(name) > 0 then
                if try_insert(player, entity, name) then
                    local removed = main.remove{name = name, count = 1}
                    assert(removed == 1, "item found but could not remove it")

                    executed = true
                    if amount > 1 then
                        new_requests[name] = amount - 1
                        empty = false
                    end
                else
                    new_requests[name] = amount
                    empty = false
                end
            elseif quickbar.get_item_count(name) > 0 then
                if try_insert(player, entity, name) then
                    local removed = quickbar.remove{name = name, count = 1}
                    assert(removed == 1, "item found but could not remove it")

                    executed = true
                    if amount > 1 then
                        new_requests[name] = amount - 1
                        empty = false
                    end
                else
                    new_requests[name] = amount
                    empty = false
                end
            else
                new_requests[name] = amount
                empty = false
            end
        else
            new_requests[name] = amount
            empty = false
        end
    end

    proxy.item_requests = new_requests
    if not empty then
        if executed then
            local list = state.construction_list
            list.s = list.s - 1
            list[list.s] = proxy
        else
            add_pending_construction(player, tick, state, proxy)
        end
    end
end

local function construct(player, tick, state)
    local list = get_construction_list(player, tick, state)
	
    local player_main = player.get_inventory(defines.inventory.player_main)

    -- every item is handled once
    -- if construction fails, it is added to the pending list

	local instant_construct_action = false
	
    for index = list.s, list.e - 1 do
        local ghost = list[index]
        list[index] = nil
        list.s = index + 1

        if not ghost.valid then
            list[index] = nil
        elseif player.can_reach_entity(ghost) then
            if ghost.type == "tile-ghost" then
                local ok, reason = construct_tile(player, ghost)
				if ok and instant_construct then
					instant_construct_action = true
				else
					if not ok then
						add_pending_construction(player, tick, state, ghost)
					else
						return true
					end
				end
            elseif ghost.name == "item-request-proxy" then
                -- based on the amount of entities in the item-request-proxy,
                -- the function might prepend the proxy to the list again or
                -- put it to the pending list
                handle_request_proxy(player, tick, state, ghost)
                return true
            else
                local ok, reason = construct_entity(player, tick, state, ghost)
				if ok and instant_construct then
					instant_construct_action = true
				else
					if not ok then
						add_pending_construction(player, tick, state, ghost)
					else
						return true
					end
				end
            end
        end
    end

	if instant_construct_action then
		return true
	end
	
    state.construction_finished = true
    return false
end

local tool_hand = {
    name = "hand",
    prototype = {
        speed = 1,
    },
    drain_durability = function (amount) return amount end
}

local function get_tool(player)
    local tools = player.get_inventory(defines.inventory.player_tools)
    local tool = tools and tools[1] or nil

    if tool and tool.valid and tool.valid_for_read then
        return tool
    else
        return tool_hand
    end
end

local function get_mining_time(player, entity, tool)
    local mineable
    if entity.name == 'deconstructible-tile-proxy' then
        local pos = entity.position
        mineable = entity.surface.get_tile(pos.x, pos.y).prototype.mineable_properties
    else
        mineable = entity.prototype.mineable_properties
    end

    tool = tool or get_tool(player)

    local character_speed = player.character and (1 + player.character_mining_speed_modifier) or 1
    local tool_speed = tool.prototype.speed

    return 1 + math.floor(mineable.mining_time / (character_speed * .01 * (tool_speed - mineable.hardness))), tool_speed, mineable.hardness
end

local function get_deconstruction_list(player, tick, state)
    local list = state.deconstruction_list

    if not list then
        local pos = player.position
        local pos_x = pos.x
        local pos_y = pos.y

        local build_distance = MAX_BUILD_DISTANCE+selection_distance
		selection_distance = 0
        local bd2 = build_distance * build_distance

        local force = player.force
        local area = {{pos_x - build_distance, pos_y - build_distance}, {pos_x + build_distance, pos_y + build_distance}}
        local find = player.surface.find_entities_filtered

        local force_list = find{area = area, force = force}
        local tree_list =  find{area = area, type = "tree"}
        local rock_list =  find{area = area, type = "simple-entity"}
        local item_list =  find{area = area, type = "item-entity"}

        list = {}
	
        for _, sublist in pairs{force_list, item_list, tree_list, rock_list} do
            for index, entity in pairs(sublist) do
                if entity.valid and entity.to_be_deconstructed(force) and is_inside_build_distance(entity, bd2, pos_x, pos_y) then
                    list[#list + 1] = entity
                end
            end
        end

        sort_by_pos(list,pos_x,pos_y)

        list.e = #list + 1
        list.s = 1

        state.deconstruction_list = list
        state.deconstruction_start = tick
    end

    return list
end

local function get_gui(player, state)
    if state.gui then return state.gui end

    local gui = player.gui.center.add{type = "progressbar", name = PROGRESSBAR, size = 100, value = 0}
    state.gui = gui

    return gui
end

local function update_gui(player, tick, state)
    if not state.show_gui then return end

    local waiting = state.waiting
    if waiting then
        local gui = get_gui(player, state)

        gui.value = math_min(waiting.offset + (tick - waiting.since) / waiting.mining_time, 1)
    else
        if state.gui and state.gui.valid then
            state.gui.destroy()
        end
        state.gui = nil
    end
end

local function clear_gui(state)
    if state.gui and state.gui.valid then
        state.gui.destroy()
    end
    state.gui = nil
end

local function get_products(entity, health)
    local proto = entity.prototype
    local products = proto.mineable_properties.products			
    local health = health or entity.health and (entity.health / proto.max_health) or 1

    if not products then return {} end

    local mined = {}
    for key, value in pairs(products) do
        local count = 1
        if value.amount then
            count = value.amount
        else
            local amount_min = value.amount_min
            local amount_max = value.amount_max
            if amount_min and amount_max then
                if amount_min == amount_max then
                    count = value.amount_min
                else
                    count = math_random(amount_min, amount_max)
                end
            end
        end

        local proto = game.item_prototypes[value.name]
        local health = proto.place_result and health or 1

        if (value.probability or 1) == 1 then
            mined[#mined + 1] = {name = value.name, count = count, health = health}
        else
            local insert = 0
            for i = 1, count do
                local probability = math.random()
                if probability <= value.probability then
                    insert = insert + 1
                end
            end
            if insert > 0 then
                mined[#mined + 1] = {name = value.name, count = count, health = health}
            end
        end
    end

    return mined
end

local function deconstruct_tile(player, entity)
    local pos = entity.position
    local surface = entity.surface
    local tile = surface.get_tile(pos.x, pos.y)

    assert(tile)

    local mined = get_products(tile, 1)
    if not atomic_insert(player.get_inventory(defines.inventory.player_main), mined) then
        return false, "inventory-full"
    end

    entity.destroy()
    surface.set_tiles{{ name = tile.hidden_tile, position = pos }}

    return true
end

-- TODO: add more?
local is_crafting_machine = {
    ["furnace"] = true,
    ["assembling-machine"] = true,
}

local is_belt = {
    ["transport-belt"] = 2,
    ["underground-belt"] = 4,
    ["splitter"] = 8,
    ["loader"] = 2,
}

-- returns true on success, otherwise false and a reason why it does not succeed
local function deconstruct_entity(player, entity)
    local index = player.index

    if entity.name == "deconstructible-tile-proxy" then
        return deconstruct_tile(player, entity)
    end

    local player_main = player.get_inventory(defines.inventory.player_main)

    if entity.type == "item-entity" then
        local stack = entity.stack
        local ok = move_stack(player_main, stack)
        return ok, (not ok) and "inventory-full"
    end

    script.raise_event(defines.events.on_pre_player_mined_item, {
        name = defines.events.on_pre_player_mined_item,
        tick = tick,
        player_index = index,
        entity = entity,
        mod = MOD_NAME,
    })

    -- clear the inventories
    local clear = true

    for _, def in pairs(defines.inventory) do
        local inv = entity.get_inventory(def)
        if inv and inv.valid then
            -- TODO: move to quickbar?
            if not move_inventory(player_main, inv) then
                clear = false
            end
        end
    end

    -- is machine crafting
    if is_crafting_machine[entity.type] and entity.is_crafting() then
		local v_recipe = entity.get_recipe()
		if v_recipe then
			local ingredients = v_recipe.ingredients
			if not atomic_insert(player_main, ingredients) then
				clear = false
			end
		else
			clear = false
        end
    elseif is_belt[entity.type] then
        for line_id = 1, is_belt[entity.type] do
            local line = entity.get_transport_line(line_id)
            if line then
                for i = #line,1,-1 do
                    local stack = line[i]
                    move_stack(player_main, stack)
                    if stack.valid and stack.valid_for_read then
                        clear = false
                    end
                end
            end
        end
    elseif entity.type == "inserter" then
        local stack = entity.held_stack
        if stack.valid and stack.valid_for_read then
            move_stack(player_main, stack)
            if stack.valid and stack.valid_for_read then
                clear = false
            end
        end
    end


    if not clear then
        return false, "entity-not-empty"
    end


    local mined = get_products(entity)
    if not atomic_insert(player_main, mined) then
        return false, "inventory-full"
    end

    if entity.type == "tree" then
        entity.die()
    else
        entity.destroy()
    end

    return true
end

local function init_waiting(player, tick, state, entity)
    local mining_time, tool_speed, hardness = get_mining_time(player, entity)
    local wait_till = tick + mining_time
	if instant_deconstruct then
		wait_till = tick
	end

    state.waiting = {
        since = tick,
        till = wait_till,

        mining_time = mining_time,

        offset = 0, -- used if power changed

        entity = entity,

        tool_speed = tool_speed,
        hardness = hardness,
    }

    update_gui(player, tick, state)
end

local function clear_waiting(player, tick, state, pending)
    clear_gui(state)

    local waiting = state.waiting
    if waiting then
        local index, entity = waiting.index, waiting.entity
        local list = state.deconstruction_list

        if list and list[list.s] and list[list.s] == entity then
            list[list.s] = nil
            list.s = list.s + 1
        end

        if pending then
            local list = state.deconstruction_pending or {s = 1, e = 1}
            state.deconstruction_pending = list

            list[list.e] = entity
            list.e = list.e + 1

            state.deconstruction_pending_since = state.deconstruction_pending_since or tick
        end

        state.waiting = nil
    end
end


local function change_tool(player, tick,  waiting, tool)
    -- how much have we waited
    local waited = tick - waiting.since
    local percent_waited = waited / waiting.mining_time + waiting.offset

    local new_total = get_mining_time(player, waiting.entity, tool)
    local new_left = math.ceil(new_total * (1 - percent_waited))

    waiting.offset = percent_waited
    waiting.since = tick
    waiting.till = tick + new_left
    waiting.mining_time = new_total
    waiting.tool_speed = tool.prototype.speed
end


local function consume_durability(player, tick, waiting)
    local tool = get_tool(player)

    -- TODO move to tool_changed
    if tool.prototype.speed ~= waiting.tool_speed then
        change_tool(player, tick, waiting, tool)
    end

    local consumed = tool.drain_durability(waiting.hardness)
    if consumed < waiting.hardness then
        change_tool(player, tick, waiting, tool_hand)
    end
end

local function is_waiting(player, tick, state)
    local waiting = state.waiting

    if not waiting then return false end

    local entity = waiting.entity

    if not entity.valid or not entity.to_be_deconstructed(player.force) then
        clear_waiting(player, tick, state)
        return false
    end

    if waiting.till < tick then
        return false
    end

    consume_durability(player, tick, waiting)

    if waiting.till == tick then
        return true
    end

    update_gui(player, tick, state)

    return true
end

local function finished_waiting(player, tick, state)
    local waiting = state.waiting
    if not waiting then return false end

    -- checked in is_waiting
    assert(waiting.till <= tick)
    assert(waiting.entity.valid)
    assert(waiting.entity.to_be_deconstructed(player.force))

    return true
end

local function deconstruct(player, tick, state)
    if is_waiting(player, tick, state) then
        return true
    end

    if finished_waiting(player, tick, state) then
        local ok, reason = deconstruct_entity(player, state.waiting.entity)
        clear_waiting(player, tick, state, not ok)

        return true
    end

    local list = get_deconstruction_list(player, tick, state)

	local instant_deconstruct_action = false
    for idx = list.s, list.e - 1 do
        local entity = list[idx]
        list[idx] = nil
        list.s = idx + 1

		if instant_deconstruct then
			local ok, reason = deconstruct_entity(player, entity)
			instant_deconstruct_action = true
		end
		
        if entity.valid then
            init_waiting(player, tick, state, entity)
            return true
        end
    end
	
	if instant_deconstruct_action then
		return true
	end 

    state.deconstruction_finished = true
    return false
end

local function check_pending(player, tick, state)
    if state.construction_list then
        if state.construction_start < global.last_ghost_change then
            state.construction_list = nil
            state.construction_start = nil
            state.construction_pending = nil
            state.construction_finished = false
            state.finished = false
        elseif state.construction_pending and state.construction_pending_since < state.last_inventory_change then
            state.construction_list = state.construction_pending
            state.construction_start = tick
            state.construction_pending = nil
            state.construction_pending_since = nil
            state.construction_finished = false
            state.finished = false
        end
    end

    if state.deconstruction_list then
        if state.deconstruction_start < global.last_deconstruction_change then
            state.deconstruction_list = nil
            state.deconstruction_start = nil
            state.deconstruction_pending = nil
            state.deconstruction_finished = false
            state.finished = false
        elseif state.deconstruction_pending and state.deconstruction_pending_since < state.last_inventory_change then
            state.deconstruction_list = state.deconstruction_pending
            state.deconstruction_pending = nil
            state.deconstruction_pending_since = nil
            state.deconstruction_finished = false
            state.finished = false
        end
    end
end

local function check(player, tick, state)

    local pos = player.position
    local pos_x = pos.x
    local pos_y = pos.y

    if pos_x == state.pos_x and pos.y == state.pos_y then
        if state.finished then
            return
        end

        local last_action = state.last_action

        if last_action + PAUSE >= tick then
            return update_gui(player, tick, state)
        end

        if not state.construction_finished then
            local did_action = construct(player, tick, state)
            if did_action then
                state.last_action = tick
                return
            end
        end

        if not state.deconstruction_finished then
            local action = deconstruct(player, tick, state)
            if action then
                state.last_action = tick
                return
            end
        end

        state.finished = state.construction_finished and state.deconstruction_finished

        -- handle pending
        check_pending(player, tick, state)
    else
        state.pos_x = pos_x
        state.pos_y = pos_y
        state.last_action = tick

        clear_gui(state)

        state.finished = false
        state.waiting = nil

        state.construction_finished =   not state.construction_enabled
        state.deconstruction_finished = not state.deconstruction_enabled

        state.construction_list = nil
        state.construction_start = nil
        state.construction_pending = nil
        state.construction_pending_since = nil

        state.deconstruction_list = nil
        state.deconstruction_start = nil
        state.deconstruction_pending = nil
        state.deconstruction_pending_since = nil
    end
end

local function on_tick(event)
    local tick = event.tick
    local State = State
    for player_index, player in pairs(Enabled) do
        check(player, tick, State[player_index])
    end
end

local function init_player(player_index, player, tick)
    State[player_index] = {
        show_gui = player.mod_settings["ght-bluebuild-show-progressbar"].value,
        last_action = tick,
        pos_x = player.position.x,
        pos_y = player.position.y,
        last_inventory_change = tick,
    }

    -- cleanup gui, if it was left over (e.g. after join or modification)
    for id, elm in pairs(player.gui.center.children) do
        if elm.valid and elm.name == PROGRESSBAR then
            elm.destroy()
        end
    end
end

script.on_event(defines.events.on_player_created, function(event)
    local player_index = event.player_index
    local player = game.players[player_index]
    init_player(player_index, player, event.tick)
end)

script.on_event(defines.events.on_player_left_game, function(event)
    local player_index = event.player_index
    local player = Enabled[player]
    if player then
        local state = State[player_index]
        clear_gui(state)

        global.reenable[player_index] = {
            autobuild = state.construction_enabled,
            autodemo = state.deconstruction_enabled,
        }

        State[player_index] = nil
        Enabled[player_index] = nil

        decrease_total()
    end
end)

script.on_event(defines.events.on_player_joined_game, function(event)
    local player_index = event.player_index
    local player = game.players[player_index]

    init_player(player_index, player, event.tick)
    local reenable = global.reenable[player_index]
    if reenable then
        global.reenable[player_index] = false

        local state = State[player_index]
        if reenable.autobuild then
            state.construction_enabled = true
            state.construction_finished = false
        end
        if reenable.autodemo then
            state.deconstruction_enabled = true
            state.deconstruction_finished = false
        end

        Enabled[player_index] = player
        increase_total()
    end
end)

local function toggle_construction(event)
    local player_index = event.player_index
    local player = game.players[player_index]

    local state = State[player_index]

    state.last_action = event.tick
    state.construction_enabled = not state.construction_enabled

    state.construction_finished = not state.construction_enabled
    state.construction_start = nil
    state.construction_list = nil
    state.construction_pending = nil
    state.construction_pending_since = nil

    if state.construction_enabled then
        player.print({'message.ght-bluebuild-autobuild-enabled'})
        if not Enabled[player_index] then
            Enabled[player_index] = player
            increase_total()
        end
        state.finished = false
    else
        player.print({'message.ght-bluebuild-autobuild-disabled'})

        if not state.deconstruction_enabled then
            Enabled[player_index] = nil
            decrease_total()
        end
    end
end

local function disable_construction(player_index, state, tick)
    if not state.construction_enabled then return end

    state.last_action = tick

    state.construction_enabled = false
    state.construction_finished = true

    state.construction_start = nil
    state.construction_list = nil
    state.construction_pending = nil
    state.construction_pending_since = nil

    if not state.deconstruction_enabled then
        Enabled[player_index] = nil
        decrease_total()
    end
end

local function toggle_deconstruction(event)
    local player_index = event.player_index
    local player = game.players[player_index]

    local state = State[player_index]

    state.last_action = event.tick

    state.deconstruction_enabled = not state.deconstruction_enabled
    state.deconstruction_finished = not state.deconstruction_enabled

    state.waiting = nil
    state.deconstruction_start = nil
    state.deconstruction_list = nil
    state.deconstruction_pending = nil
    state.deconstruction_since = nil

    if state.deconstruction_enabled then
        player.print({'message.ght-bluebuild-autodemo-enabled'})
        if not Enabled[player_index] then
            Enabled[player_index] = player
            increase_total()
        end

        state.finished = false
    else
        player.print({'message.ght-bluebuild-autodemo-disabled'})
        clear_gui(state)

        if not state.construction_enabled then
            Enabled[player_index] = nil
            decrease_total()
        end
    end
end

local function disable_deconstruction(player_index, state, tick)
    if not state.deconstruction_enabled then return end

    clear_gui(state)

    state.last_action = tick

    state.deconstruction_enabled = false
    state.deconstruction_finished = true

    state.deconstruction_start = nil
    state.deconstruction_list = nil
    state.deconstruction_pending = nil
    state.deconstruction_since = nil


    if not state.construction_enabled then
        Enabled[player_index] = nil
        decrease_total()
    end
end

local function notify_players(tick)
    local State = State
    for index, player in pairs(Enabled) do
        local state = State[index]
        if state.finished then
            check_pending(player, tick, state)
        end
    end
end


local function on_built_entity(event)
    local entity = event.created_entity
    if entity.valid and (entity.type == 'entity-ghost' or entity.type == 'tile-ghost') then
        local tick = event.tick
        global.last_ghost_change = tick
        notify_players(tick)
    end
end

local function on_marked_for_deconstruction(event)
    global.last_deconstruction_change = event.tick
    notify_players(event.tick)
end

local function inventory_changed(event)
    local index = event.player_index
    local player = Enabled[index]
    if not player then return end

    local tick = event.tick

    local state = State[index]

    state.last_inventory_change = tick

    if state.finished then
        check_pending(player, tick, state)
    end
end

local function register_events()
    script.on_event(defines.events.on_player_main_inventory_changed, inventory_changed)
    script.on_event(defines.events.on_player_quickbar_inventory_changed, inventory_changed)
    script.on_event(defines.events.on_player_tool_inventory_changed, tool_changed)

    script.on_event(defines.events.on_built_entity, on_built_entity)
    script.on_event(defines.events.on_marked_for_deconstruction, on_marked_for_deconstruction)
    script.on_event(defines.events.on_tick, on_tick)
end

local function unregister_events()
    script.on_event(defines.events.on_player_main_inventory_changed, nil)
    script.on_event(defines.events.on_player_quickbar_inventory_changed, nil)
    script.on_event(defines.events.on_player_tool_inventory_changed, nil)

    script.on_event(defines.events.on_built_entity, nil)
    script.on_event(defines.events.on_marked_for_deconstruction, nil)
    script.on_event(defines.events.on_tick, nil)
end

local function register_keybindings()
    script.on_event('ght-bluebuild-autobuild', toggle_construction)
    script.on_event('ght-bluebuild-autodemo', toggle_deconstruction)
end

local function unregister_keybindings()
    script.on_event('ght-bluebuild-autobuild', nil)
    script.on_event('ght-bluebuild-autodemo', nil)
end

increase_total = function()
    local total = global.total or 0
    global.total = total + 1
    if total == 0 then
        register_events()
    end
end

decrease_total = function()
    local total = global.total
    global.total = total - 1
    if total == 1 then
        unregister_events()
    end
end

script.on_load(function(event)
    Enabled = global.enabled
    State = global.state

    if global.total > 0 then
        register_events()
    end

    DISABLED = not settings.global["ght-bluebuild-enable"].value
    if not DISABLED then
        register_keybindings()
    end
end)

local function init()
    global.reenable = {}
    global.enabled = {}
    global.state = {}
    global.total = 0

    Enabled = global.enabled
    State = global.state

    global.last_ghost_change = 0
    global.last_deconstruction_change = 0

    DISABLED = not settings.global["ght-bluebuild-enable"].value
    if not DISABLED then
        register_keybindings()
    end

    local tick = game.tick
    for idx, player in pairs(game.players) do
        init_player(idx, player, tick)
    end
end

script.on_event(defines.events.on_runtime_mod_setting_changed, function (event)
    local player_index = event.player_index
    local name = event.setting
    local tick = event.tick

    if name == "ght-bluebuild-enable" then
        if settings.global["ght-bluebuild-enable"].value == false then
            game.print{"message.ght-blueprint-disabled"}
            for index, player in pairs(Enabled) do
                local state = State[index]
                disable_construction(index, state, tick)
                disable_deconstruction(index, state, tick)
            end
            DISABLED = true
            unregister_keybindings()
        else
            game.print{"message.ght-blueprint-enabled"}
            DISABLED = false
            register_keybindings()
        end
    elseif name == "ght-bluebuild-show-progressbar" then
        local player = Enabled[player_index]
        if player then
            local value = player.mod_settings["ght-bluebuild-show-progressbar"].value
            local state = State[player_index]
            state.show_gui = value
            if value then
                update_gui(player, tick, state)
            else
                clear_gui(state)
            end
        end
    end
end)

script.on_init(init)
script.on_configuration_changed(function () init() end)




-- LordOdin's [4 of 4] begin
local function toggle_construction2(event)
    local player_index = event.player_index
    local player = game.players[player_index]

    local state = State[player_index]

    state.last_action = event.tick
    state.construction_enabled = not state.construction_enabled

    state.construction_finished = not state.construction_enabled
    state.construction_start = nil
    state.construction_list = nil
    state.construction_pending = nil
    state.construction_pending_since = nil

    if state.construction_enabled then
        if not Enabled[player_index] then
            Enabled[player_index] = player
            increase_total()
        end
        state.finished = false
    else
        if not state.deconstruction_enabled then
            Enabled[player_index] = nil
            decrease_total()
        end
    end
end




-- Add to construction list
function get_max_distance(player, old_max_distance, x, y)
	local pos = player.position
	local pos_x = pos.x
	local pos_y = pos.y		

	local d = math.sqrt((x-pos_x)*(x-pos_x)+(y-pos_y)*(y-pos_y))
	if d > old_max_distance then 
		return d
	else
		return old_max_distance
	end
end

function lo_reset_distance(event)
	local player = game.players[event.player_index]
--	player.print(serpent.line(event))
	if event.area.left_top.x ~= event.area.right_bottom.x and event.area.left_top.y ~= event.area.right_bottom.y 
		and event.item and (event.item == "bluebuild-selector" or event.item == "deconstruction-planner") then
		local player = game.players[event.player_index]
		selection_distance = get_max_distance(player, selection_distance, event.area.left_top.x, event.area.left_top.y)
		selection_distance = get_max_distance(player, selection_distance, event.area.left_top.x, event.area.right_bottom.y)
		selection_distance = get_max_distance(player, selection_distance, event.area.right_bottom.x, event.area.right_bottom.y)
		selection_distance = get_max_distance(player, selection_distance, event.area.right_bottom.x, event.area.left_top.y)
--		player.print('selection_distance = '..selection_distance)
	end
end

function OnPlayerSelectedArea(event)
	lo_reset_distance(event)
			
	if event.item and event.item == "bluebuild-selector" then
		local player = game.players[event.player_index]
		if event.area.left_top.x ~= event.area.right_bottom.x and event.area.left_top.y ~= event.area.right_bottom.y then
			for _,entity in pairs (event.entities) do
				if is_ghost(entity) then
					if not State[event.player_index] then State[event.player_index] = {} end
					if not State[event.player_index]['selected_entities'] then State[event.player_index]['selected_entities'] = {} end					
					table.insert(State[event.player_index]['selected_entities'], entity)
				end
			end
		end

		if State[event.player_index].construction_enabled then
			toggle_construction2(event)
			toggle_construction2(event)
		else
			toggle_construction2(event)
		end
			
	end
end

-- Clean construction list, and add selected to new one
function OnPlayerAltSelectedArea(event)
	local player = game.players[event.player_index]
	player.print(serpent.line(event))

	if event.item and event.item == "bluebuild-selector" then
		local player = game.players[event.player_index]		
		if State[event.player_index] then
			State[event.player_index]['selected_entities'] = {}
		end
		OnPlayerSelectedArea(event)
	end
end

function OnPlayerDeconstructedArea(event)
	lo_reset_distance(event)
end

script.on_event(defines.events.on_player_selected_area, OnPlayerSelectedArea)
script.on_event(defines.events.on_player_alt_selected_area, OnPlayerAltSelectedArea)
script.on_event(defines.events.on_player_deconstructed_area, OnPlayerDeconstructedArea)

-- LordOdin's [4 of 4] end
