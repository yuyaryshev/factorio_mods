local Surfaces = require('script.surfaces')
local Portal = require('script.portal')

local portal_spec_example = {
    type = "entity", -- Types: entity, energy, item
    type_params = {}, -- Parameters depending on the type, used to add restrictions
    relative_target = -1, -- Interger, defines how many layers we should shift
    absolute_target = nil, -- Integer, overrides relatiive_target is defined, target layer
    from = {
        prototype = "", -- Prototype of from portal
        restrictions = {
            main_surface = nil, -- On which surface should this be placed? Empty for any
            layer = nil -- On which layer can this be placed? Empty for any (not implemented yet)
        }
    },
    to = {
        prototype = "", -- Prototype of portal on other side
        main_surface = nil, -- To which surface should this point? Empty for same as from
        clear_radius = 10 -- Radius that should be cleared around the portal in the target dimension
                         -- Defaults to the raduis of the prototype + 1
    },
    allow_reverse = false -- Can this portal be used in 2 directions?
}

local portal_example = {
    type = "entity",
    type_params = {},
    from_entity = {},
    to_entity = {},
}

local function register_surface(name, main_surface, layers, owner)
	Surfaces.register_surface(main_surface, layers, owner, name)
end

local function get_main_surfaces()
	local result = {}
	for k, _ in pairs(global.surfaces) do
		table.insert(result, k)
	end
	return result
end

local function add_main_surface(name)
    Surfaces.add_main_surface(name)
end

local function add_replaceable_tiles(tiles)
	for k, v in pairs(tiles) do
		global.replaceable_tiles[k] = v
	end
end

local function add_replaceable_entities(entities)
	for k, v in pairs(entities) do
		global.replaceable_entities[k] = v
	end
end

local function register_portal(portal)
    Portal.register(portal)
end

local function add_pair(portal_spec, from_entity, to_entity)
    Portal.add_pair(portal_spec, from_entity, to_entity)
end

local function setup_interface()
    remote.add_interface("SurfacesAPI", {
		register_surface = register_surface,
		get_main_surfaces = get_main_surfaces,
        add_main_surface = add_main_surface,
		add_replaceable_tiles = add_replaceable_tiles,
		add_replaceable_entities = add_replaceable_entities,
        register_portal = register_portal,
        add_pair = add_pair,
    })
end

return setup_interface
