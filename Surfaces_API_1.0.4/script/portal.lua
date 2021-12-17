local Event = require('__stdlib__/stdlib/event/event')
local Surfaces = require('script.surfaces')
local Is = require('__stdlib__/stdlib/utils/is')
local Position = require('__stdlib__/stdlib/area/position')
local Area = require('__stdlib__/stdlib/area/area')
local Surface = require('__stdlib__/stdlib/area/surface')
local Assert = require('util.assert')
local Globals = require('util.globals')

local Portal = {}

-- --------------------------------
-- Local functions
-- --------------------------------

local function load_globals()
    global.pair_map = global.pair_map or {}
    global.portal_registry = global.portal_registry or {}
    global.portal_filters = global.portal_filters or {}
end

local function set_event_filters()
    if #global.portal_filters > 0 then
        script.set_event_filter(defines.events.on_built_entity, global.portal_filters)
        script.set_event_filter(defines.events.on_player_mined_entity, global.portal_filters)
        script.set_event_filter(defines.events.on_robot_built_entity, global.portal_filters)
    end
end

local function load_tables()
    Portal.map = global.pair_map
    Portal.registry = global.portal_registry
    Portal.filters = global.portal_filters
end

local function clear_area(surface, position, radius)
    local area = Area.load(Position.expand_to_area(position, radius))
    Is.Assert.Area(area)

    -- Destroy replaceable entities in the area
    for _, v in ipairs(Surface.find_all_entities({ area = area, surface = surface })) do
        if global.replaceable_entities[v.name] ~= nil then
            v.destroy()
        end
    end

    local tiles = {}

    -- Replace colliding tiles with their replacement tile
    for x, y in Area.iterate(area) do
        local tile = surface.get_tile(x, y)

        if not tile then
            return false
        end

        if tile.collides_with("player-layer") or tile.collides_with("doodad-layer") or tile.collides_with("item-layer") then
            local replacement = global.replaceable_tiles[tile.name]
            if replacement ~= nil then
                table.insert(tiles, { name = replacement, position = tile.position })
            end
        end
    end

    surface.set_tiles(tiles)

    return true
end

-- Prepares the target surface for a portal placed on the given surface at the given position
local function prepare_target_surface(portal_spec, surface, position)
    Assert.PortalSpec(portal_spec)
    Assert.Surface(surface)
    Is.Assert.Position(Position.load(position))

    -- Derive information from surface of the placed portal
    local main_surface = Surfaces.get_main_surface(surface)
    local layer = Surfaces.get_index(surface)

    -- Check if the information is valid
    if layer == nil then return nil end
    if not main_surface then return nil end

    -- Main surface restriction check
    local from_surface = portal_spec.from.restrictions.main_surface
    if main_surface ~= from_surface and from_surface ~= nil then
        return nil
    end

    -- Find target layer
    local target_layer

    if portal_spec.absolute_target ~= nil then
        target_layer = portal_spec.absolute_target
    else
        target_layer = layer + portal_spec.relative_target
    end

    if target_layer == nil then return nil end

    -- Request target surface

    local target_main_surface = portal_spec.to.main_surface or main_surface

    local target_surface = Surfaces.request_surface(target_main_surface, target_layer, position)

    if not target_surface then return nil end

    return target_surface
end

local function destroy_portal(unit_number)
    local portal = Portal.map[unit_number]

    if portal ~= nil then
        Portal.remove(portal)
    end
end

-- Inverts from and to entities in a portal
local function invert_portal(portal)
    return {
        type = portal.type,
        type_params = portal.type_params,
        from_entity = portal.to_entity,
        to_entity = portal.from_entity
    }
end

-- --------------------------------
-- Event handlers
-- --------------------------------

Event.on_init(function()
    load_globals()
    load_tables()
    set_event_filters()
end).on_configuration_changed(function()
    load_globals()
    load_tables()
    set_event_filters()
end).on_load(function()
    load_tables()
    set_event_filters()
end).on_event(defines.events.on_built_entity, function(event)
    local portal_spec = Portal.registry[event.created_entity.name]

    if portal_spec ~= nil then
        -- Try to create a portal entity on the other surface
        local result = Portal.create(portal_spec, event.created_entity.surface, event.created_entity)
        if not result then
            -- If it failed, the portal cannot be created and the player will be forced to mine the entity it just placed
            game.players[event.player_index].mine_entity(event.created_entity, true)
        end
    end
end).on_event(defines.events.on_robot_built_entity, function(event)
    local portal_spec = Portal.registry[event.created_entity.name]

    if portal_spec ~= nil then
        -- Try to create a portal entity on the other surface
        local result = Portal.create(portal_spec, event.created_entity.surface, event.created_entity)
        if not result then
            -- If it failed, the portal cannot be created and the placed entity
            -- will be marked for deconstruction, so the same robot will probably pick it up again
            event.created_entity.order_deconstruction(event.robot.force)
        end
    end
end).on_event(defines.events.script_raised_built, function(event)
    local portal_spec = Portal.registry[event.entity.name]

    if portal_spec ~= nil then
        -- Try to create a portal entity on the other surface
        local result = Portal.create(portal_spec, event.entity.surface, event.entity)
        if not result then
            -- If it failed, the portal cannot be created and the placed entity
            -- will be marked for deconstruction, so the same robot will probably pick it up again
            event.entity.destroy()
        end
    end
end).on_event(defines.events.on_player_mined_entity, function(event)
    destroy_portal(event.entity.unit_number)
end).on_event(defines.events.on_robot_mined_entity, function(event)
    destroy_portal(event.entity.unit_number)
end).on_event(defines.events.script_raised_destroy, function(event)
    destroy_portal(event.entity.unit_number)
end)

-- --------------------------------
-- Public methods
-- --------------------------------

function Portal.register(portal_spec)
    Assert.PortalSpec(portal_spec)

    -- Register portal specification
    Portal.registry[portal_spec.from.prototype] = portal_spec

    -- Update event filters
    table.insert(global.portal_filters, { filter = "name", name = portal_spec.from.prototype })
    table.insert(global.portal_filters, { filter = "name", name = portal_spec.to.prototype })
    set_event_filters()
end

-- Adds two portal entities to the portal map
-- The portal_spec must have a type and may optionally have type_params and allow_reverse
function Portal.add_pair(portal_spec, from_entity, to_entity)
    -- Create portal object and add to the global table
    local portal = {
        type = portal_spec.type,
        type_params = portal_spec.type_params,
        from_entity = from_entity,
        to_entity = to_entity
    }

    Portal.map[from_entity.unit_number] = portal

    local inverse = invert_portal(portal)
    Portal.map[to_entity.unit_number] = inverse


    -- Queue the portals in the transport update queue
    local queue_pos = game.tick % Globals.CYCLIC_BUFFER_SIZE + 1
    local new_slot = global.update_queue[queue_pos]

    if portal_spec.allow_reverse then
        table.insert(global.transport_init_queue, inverse)
        new_slot[1 + #new_slot] = inverse
    end

    table.insert(global.transport_init_queue, portal)
    new_slot[1 + #new_slot] = portal
end

-- Create the other entity when the given entity was placed on the given surface
function Portal.create(portal_spec, surface, entity)
    Assert.PortalSpec(portal_spec)
    Assert.Surface(surface)

    local position = entity.position
    Is.Assert.Position(Position.load(position))

    local target_surface = prepare_target_surface(portal_spec, surface, position)
    local clear_radius = portal_spec.to.clear_radius or game.entity_prototypes[portal_spec.to.prototype].radius + 1

    if target_surface then
        if Surfaces.can_be_cleared(target_surface, position, clear_radius) then
            clear_area(target_surface, position, clear_radius)

            -- Create the target portal entity
            local other_entity = target_surface.create_entity({
                name = portal_spec.to.prototype,
                position = position,
                force = entity.force,
                raise_built = false
            })

            Portal.add_pair(portal_spec, entity, other_entity)

            return true
        end
    end

    return false
end

-- Remove the other entity when the from entity from the given portal was removed
function Portal.remove(portal)
    Assert.Portal(portal)

    Portal.map[portal.from_entity.unit_number] = nil
    Portal.map[portal.to_entity.unit_number] = nil

    portal.to_entity.destroy({ raise_destroy = false })
end

return Portal
