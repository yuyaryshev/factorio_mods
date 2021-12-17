local Event = require('__stdlib__/stdlib/event/event')
local Is = require('__stdlib__/stdlib/utils/is')
local Position = require('__stdlib__/stdlib/area/position')
local Area = require('__stdlib__/stdlib/area/area')
local Surface = require('__stdlib__/stdlib/area/surface')
local Assert = require('util.assert')

local Surfaces = {}

-- --------------------------------
-- Local functions
-- --------------------------------

local function generate_chunk(event)
    local surface_name = event.surface.name

    if not global.surface_index_table[surface_name] then
        return
    end

    local owner = global.surface_index_table[surface_name].owner

    if owner ~= nil then
        Assert.SurfaceOwner(owner)

        remote.call(owner.interface, "generate_chunk", owner.name, event.surface, Surfaces.get_index(event.surface), event)
    end
end

local function create_tables()
    global.surface_index_table = global.surface_index_table or {}
    global.replaceable_tiles = {}
    global.replaceable_entities = {}

    global.surfaces = global.surfaces or {}
    local surfaces_setting = settings.global["main-surface"].value..","
    for surface_name in surfaces_setting:gmatch("(.-),") do
        Assert.Surface(surface_name)
        if global.surfaces[surface_name] == nil then
            global.surfaces[surface_name] = {}
            global.surfaces[surface_name].surface_table = {}
            global.surfaces[surface_name].surface_owner_table = { min = -1, max = 1, owners = {} }
            Surfaces.set_surface(game.surfaces[surface_name], 0, game.surfaces[surface_name])
        end
    end
end

local function create_surface(main_surface, surface_layer)
    Assert.Surface(main_surface)
    Is.Assert.Int(surface_layer)

    local main_surface_name = type(main_surface) == "string" and main_surface or main_surface.name

    local min = global.surfaces[main_surface_name].surface_owner_table.min
    local max = global.surfaces[main_surface_name].surface_owner_table.max
    local owner

    if surface_layer <= min then
        owner = global.surfaces[main_surface_name].surface_owner_table.min_owner
    end

    if surface_layer >= max then
        owner = global.surfaces[main_surface_name].surface_owner_table.max_owner
    end

    if surface_layer > min and surface_layer < max then
        owner = global.surfaces[main_surface_name].surface_owner_table.owners[Surfaces.index_to_key(surface_layer)]
    end

    if owner == nil then
        return nil
    else
        Assert.SurfaceOwner(owner)
    end

    local surface = remote.call(owner.interface, "create_surface", owner.name, surface_layer)
    Surfaces.set_surface(main_surface_name, surface_layer, surface)
    Surfaces.set_owner(surface, owner)

    return surface
end

-- --------------------------------
-- Event handlers
-- --------------------------------

Event.on_init(function()
    create_tables()
end).on_configuration_changed(function()
    create_tables()
end).register(defines.events.on_chunk_generated, function(event)
    generate_chunk(event)
end)

-- --------------------------------
-- Public methods
-- --------------------------------

function Surfaces.add_main_surface(name)
    local value = settings.global["main-surface"].value
    value = value..","..name
    settings.global["main-surface"] = value
end

function Surfaces.can_be_cleared(surface, position, radius)
    local area = Area.load(Position.to_area(position - Position.construct(radius, radius), radius * 2, radius * 2))
    Is.Assert.Area(area)

    for _, v in ipairs(Surface.find_all_entities({ area = area, surface = surface })) do
        if global.replaceable_entities[v.name] == nil then
            return false
        end
    end

    for x, y in Area.iterate(area) do
        local tile = surface.get_tile(x, y)

        if not tile then
            return false
        end

        if tile.collides_with("player-layer") or tile.collides_with("doodad-layer") or tile.collides_with("item-layer") then
            if global.replaceable_tiles[tile.name] == nil then
                return false
            end
        end
    end

    return true
end

function Surfaces.get_main_surface(surface)
    Assert.Surface(surface)

    local surface_name = type(surface) == "string" and surface or surface.name
    return global.surface_index_table[surface_name] and global.surface_index_table[surface_name].main_surface or nil
end

function Surfaces.get_index(surface)
    Assert.Surface(surface)

    local surface_name = type(surface) == "string" and surface or surface.name
    return global.surface_index_table[surface_name] and global.surface_index_table[surface_name].index or nil
end

function Surfaces.set_owner(surface, owner)
    Assert.Surface(surface)
    Assert.SurfaceOwner(owner)

    local surface_name = type(surface) == "string" and surface or surface.name
    if global.surface_index_table[surface_name] then
        global.surface_index_table[surface_name].owner = owner
    end
end

function Surfaces.get_surface(main_surface, index)
    Assert.Surface(main_surface)
    Is.Assert.Int(index, "The given index is not an integer")

    local surface_name = type(main_surface) == "string" and main_surface or main_surface.name
    return global.surfaces[surface_name] and global.surfaces[surface_name].surface_table[Surfaces.index_to_key(index)] or nil
end

function Surfaces.set_surface(main_surface, index, surface, overwrite)
    Assert.Surface(surface)
    Assert.Surface(main_surface)
    Is.Assert.Int(index, "The given index is not an integer")

    local surface_name = type(surface) == "string" and surface or surface.name
    local main_surface_name = type(main_surface) == "string" and main_surface or main_surface.name
    local key = Surfaces.index_to_key(index)
    if global.surfaces[main_surface_name].surface_table[key] == nil or overwrite then
        global.surfaces[main_surface_name].surface_table[key] = surface
        global.surface_index_table[surface_name] = { index = index, main_surface = main_surface_name }
        return true
    end
    return false
end

-- This function does a lot of weird stuff to parse the input,
-- future documentation should clarify how to interface with this function.
-- So know one will really need to know how this magic works.
function Surfaces.register_surface(main_surface, layer_table, interface, name)
    Assert.Surface(main_surface)
    Assert.LayerTable(layer_table)
    local owner = { interface = interface, name = name }
    Assert.SurfaceOwner(owner)

    local main_surface_name = type(main_surface) == "string" and main_surface or main_surface.name
    local owner_table = global.surfaces[main_surface_name].surface_owner_table

    if type(layer_table) == "number" or type(layer_table) == "table" and #layer_table == 1 then
        -- It's a single value
        local layer = (type(layer_table) == "number" and layer_table) or (type(layer_table) == "table" and layer_table[1])
        owner_table.owners[Surfaces.index_to_key(layer)] = owner
        owner_table.max = owner_table.max > layer and owner_table.max or layer + 1
        owner_table.min = owner_table.min < layer and owner_table.min or layer - 1
        return true
    elseif type(layer_table) == "table" and #layer_table == 2 then
        -- It's a range of values

        if layer_table[1] == "bottom" then
            -- The first value is nil, meaning that this owner will control all bottom surfaces
            owner_table.min_owner = owner
            if type(layer_table[2]) == "number" then
                owner_table.min = layer_table[2]
                owner_table.max =
                owner_table.max > owner_table.min           -- if
                and owner_table.max							-- then
                or owner_table.min + 1						-- else
                return true
            end
        end

        if layer_table[2] == "top" then
            -- The second value is nil, meaning that this owner will control all top surfaces
            owner_table.max_owner = owner
            if type(layer_table[1]) == "number" then
                owner_table.max = layer_table[1]
                owner_table.min =
                owner_table.min < owner_table.max           -- if
                and owner_table.min							-- then
                or owner_table.max - 1						-- else
                return true
            end
        end

        if layer_table[1] == "bottom" and layer_table[2] == "top" then
            -- If they are both nil, the owner will control all surfaces, including the main surface
            owner_table.min = 0
            owner_table.max = 0
            return true
        end

        if type(layer_table[1]) == "number" and type(layer_table[2]) == "number" and layer_table[1] <= layer_table[2] then
            -- A finite amount of keys can all be stored in a table

            for i = layer_table[1], layer_table[2] do
                owner_table.owners[Surfaces.index_to_key(i)] = owner
            end

            return true
        end
    end
    return false
end

function Surfaces.request_surface(main_surface, layer, position)
    local surface = Surfaces.get_surface(main_surface, layer)
    if not surface then
        surface = create_surface(main_surface, layer)
        if not surface then return false end
    end

    surface.request_to_generate_chunks(position, 1)
    surface.force_generate_chunk_requests()

    return surface
end


-- These functions may seem cumbersome at first, but
-- all they do is map integers to natural numbers, since
-- layers can be negative and keys can't.
-- This will work as long as the layer depth does not exceed
-- half of the maximum value of an integer, which is unlikely to ever happen.
function Surfaces.index_to_key(index)
    if index >= 0 then
        return index * 2 + 1
    else
        return -index * 2
    end
end

function Surfaces.key_to_index(key)
    if key % 2 == 0 then
        return -(key / 2)
    else
        return (key - 1) / 2
    end
end

return Surfaces
