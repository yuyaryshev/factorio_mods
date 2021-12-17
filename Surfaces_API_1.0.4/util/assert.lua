local Is = require('__stdlib__/stdlib/utils/is')

local Assert = {}

function Assert.Surface(surface)
    Is.Assert(
        type(surface) == "string" and Is.Valid(game.surfaces[surface])
        or Is.Table(surface) and Is.Valid(surface),
        "Invalid argument for surface")
end

function Assert.SurfaceOwner(owner)
    Is.Assert.Table(owner, "Owner must be a table")
    Is.Assert.String(owner.name, "Owner name must be a string")
    Is.Assert.String(owner.interface, "Owner interface must be a string")
    Is.Assert(remote.interfaces[owner.interface] ~= nil,
        "Invalid owner interface, are you sure the interface is registered?")
    Is.Assert(remote.interfaces[owner.interface]["create_surface"] ~= nil,
        "Invalid owner interface: create_surface is not a function")
    Is.Assert(remote.interfaces[owner.interface]["generate_chunk"] ~= nil,
        "Invalid owner interface: generate_chunk is not a function")
end

function Assert.LayerTable(layer_table)
    Is.Assert.Table(layer_table, "The given argument must be a table")
    Is.Assert((type(layer_table) == "number" or type(layer_table) == "table" and #layer_table == 1)
           or (type(layer_table) == "table" and #layer_table == 2), "Invalid layer table")
end

function Assert.Portal(portal)
    Is.Assert.Table(portal, "The given argument must be a table")
    Is.Assert.Valid(portal.from_entity, "The source entity of this portal is invalid")
    Is.Assert.Valid(portal.to_entity, "The target entity of this portal is invalid")
    Is.Assert.Table(portal.type_params, "Type params must be a table")
    Is.Assert.String(portal.type, "Portal type must be a string")
end

function Assert.PortalSpec(portal_spec)
    Is.Assert.Table(portal_spec, "The given argument must be a table")
    -- TODO
end

return Assert
