
local function register_portals()
    -- A portal to go down
    remote.call("SurfacesAPI", "register_portal", {
        type = "entity", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = -1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "shaft-down", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "shaft-up", -- Prototype of portal on other side
        },
        allow_reverse = true -- Can this portal be used in 2 directions?
    })

    -- The complementary portal for the previous one
    remote.call("SurfacesAPI", "register_portal", {
        type = "entity", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = 1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "shaft-up", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "shaft-down", -- Prototype of portal on other side
        },
        allow_reverse = true -- Can this portal be used in 2 directions?
    })

    -- Item portal
    remote.call("SurfacesAPI", "register_portal", {
        type = "itemchest", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = -1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "chest-down", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "chest-up", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    remote.call("SurfacesAPI", "register_portal", {
        type = "itemchest", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = 1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "chest-up", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "chest-down", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    -- Energy
    remote.call("SurfacesAPI", "register_portal", {
        type = "energy", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = -1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "accumulator-down", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "accumulator-up", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    remote.call("SurfacesAPI", "register_portal", {
        type = "energy", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = 1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "accumulator-up", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "accumulator-down", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    -- Fluid
    remote.call("SurfacesAPI", "register_portal", {
        type = "fluid", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = -1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "storage-tank-down", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "storage-tank-up", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    remote.call("SurfacesAPI", "register_portal", {
        type = "fluid", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = 1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "storage-tank-up", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "storage-tank-down", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    remote.call("SurfacesAPI", "register_portal", {
        type = "linked_belt", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = -1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "linked-belt-down", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "linked-belt-up", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    remote.call("SurfacesAPI", "register_portal", {
        type = "linked_belt", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = 1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "linked-belt-up", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "linked-belt-down", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })
end

script.on_init(function()
    register_portals()
end)

script.on_configuration_changed(function()
    register_portals()
end)
