
local function config_surfaces()
    -- For each configured main surface
	for _, surface_name in ipairs(remote.call("SurfacesAPI", "get_main_surfaces")) do
        remote.call(
            "SurfacesAPI", "register_surface", -- Call the register_surface function
            surface_name.."-caves", -- Name of the surfaces. We include the main surface name to make sure they are all unique
            surface_name, -- Name of the main surface
            {"bottom", -1}, -- Selection of layers, we want all the layers below the main surface
            "SurfacesCavesUnderground" -- Name of the interface as mentioned by the surface generation mod, Surfaces Original in this case
        )
    end
end

script.on_init(function()
    -- Called when creating a new save file
    config_surfaces()
end)

script.on_configuration_changed(function()
    -- Called when mods are updated
    config_surfaces()
end)

