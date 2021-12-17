
local function get_map_gen_settings()
    local settings = game.surfaces["nauvis"].map_gen_settings
    settings.seed = global.generator(1000000)
    settings.autoplace_controls = {}
    settings.cliff_settings.richness = 0
    settings.autoplace_settings["tile"] = {
        settings = {
            ["cave-ground"] = {
                frequency = 1,
                richness = 1,
                size = 1
            },
            ["cave-wall"] = {
                frequency = 1,
                richness = 1,
                size = 1
            }
        }
    }
    settings.default_enable_all_autoplace_controls = false
    return settings
end

local function setup_interface()
	remote.add_interface("SurfacesCavesUnderground", {
		create_surface = function(name, layer)
            local surface = game.create_surface(name..":"..layer, get_map_gen_settings())
            surface.daytime = 0.5
            if settings.global["cave-darkness"].value then
                surface.brightness_visual_weights = { 1 / 0.85, 1 / 0.85, 1 / 0.85 }
            end
            surface.freeze_daytime = true
            return surface
        end,
		generate_chunk = function(name, surface, layer, event)
            if settings.global["cave-darkness"].value then
                surface.brightness_visual_weights = { 1 / 0.85, 1 / 0.85, 1 / 0.85 }
            else
                surface.brightness_visual_weights = { 0, 0, 0 }
            end
		end
    })
end

local function config_surfaces()
    -- Tell Surfaces that it may replace Cave Walls with Cave Ground when trying to place a portal
    remote.call("SurfacesAPI", "add_replaceable_tiles", {
        ["cave-wall"] = "cave-ground"
    })
end

script.on_init(function()
    config_surfaces()
    global.generator = game.create_random_generator()
end)

script.on_configuration_changed(function()
    config_surfaces()
end)


setup_interface()


