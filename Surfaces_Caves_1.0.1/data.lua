local noise = require("noise")
local tne = noise.to_noise_expression

-- Very much work in progress
-- I don't know what this is or how it works, but what I do know is that it works
-- TODO: Clean up this mess
local function make_autoplace_settings(is_wall)
    local value = noise.var("straight-basis-noise")
    local control_setting = noise.get_control_setting("caves")
    local fitness

    if is_wall then
        fitness = value - control_setting.size_multiplier + 1
    else
        fitness = control_setting.size_multiplier - value + 1
    end

    return {
        control = "caves",
        default_enabled = false,
        probability_expression = noise.min(fitness * math.huge, fitness)
    }
end

local color

if settings.startup["cave-map"].value then
    color = {r=160.0, g=160.0, b=160.0}
else
    color = {r=0.0, g=0.0, b=0.0}
end

data:extend({
    {
        type = "noise-layer",
        name = "cave-ground"
    },
    {
        type = "noise-layer",
        name = "cave-wall"
    },
    {
        type = "autoplace-control",
        name = "caves",
        category = "terrain",
        richness = false
    },
    {
        type = "noise-expression",
        name = "straight-basis-noise",
        intended_property = "cave-wall",
        expression = {
            type = "function-application",
            function_name = "factorio-basis-noise",
            arguments = {
                x = noise.var("x"),
                y = noise.var("y"),
                seed0 = noise.var("map_seed"), -- i.e. map.seed
                seed1 = tne(123), -- Some random number
                input_scale = noise.var("segmentation_multiplier")/20,
                output_scale = 20/noise.var("segmentation_multiplier")
            }
        }
    },
    {
        type = "tile",
        name = "cave-ground",
        collision_mask = {"ground-tile"},
        autoplace = make_autoplace_settings(false),
        layer = 38,
        variants =
        {
            main =
            {
                {
                    picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/cave-ground1.png",
                    count = 16,
                    size = 1,
                    hr_version =
                    {
                        picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/hr-cave-ground1.png",
                        count = 16,
                        size = 1,
                        scale = 0.5,
                    },
                },
                {
                    picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/cave-ground2.png",
                    count = 16,
                    size = 2,
                    hr_version =
                    {
                        picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/hr-cave-ground2.png",
                        count = 16,
                        size = 2,
                        scale = 0.5,
                    },
                },
                {
                    picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/cave-ground4.png",
                    count = 16,
                    size = 4,
                    hr_version =
                    {
                        picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/hr-cave-ground4.png",
                        count = 16,
                        size = 4,
                        scale = 0.5,
                    }
                },
                {
                    picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/cave-ground8.png",
                    line_length = 4,
                    count = 16,
                    size = 8,
                    hr_version =
                    {
                        picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/hr-cave-ground8.png",
                        line_length = 4,
                        count = 16,
                        size = 8,
                        scale = 0.5,
                    }
                },
                {
                    picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/cave-ground16.png",
                    line_length = 4,
                    count = 16,
                    size = 16,
                    hr_version =
                    {
                        picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/hr-cave-ground16.png",
                        line_length = 4,
                        count = 16,
                        size = 16,
                        scale = 0.5,
                    }
                },
            },
            inner_corner =
            {
                picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/cave-ground-inner-corner.png",
                count = 8,
                hr_version =
                {
                    picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/hr-cave-ground-inner-corner.png",
                    count = 8,
                    scale = 0.5,
                },
            },
            outer_corner =
            {
                picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/cave-ground-outer-corner.png",
                count = 8,
                hr_version =
                {
                    picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/hr-cave-ground-outer-corner.png",
                    count = 8,
                    scale = 0.5,
                },
            },
            side =
            {
                picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/cave-ground-side.png",
                count = 8,
                hr_version =
                {
                    picture = "__Surfaces_Caves__/graphics/terrain/cave-ground/hr-cave-ground-side.png",
                    count = 8,
                    scale = 0.5,
                },
            },
        },
        walking_sound =
        {
            {
                filename = "__base__/sound/walking/grass-01.ogg",
                volume = 0.8
            },
            {
                filename = "__base__/sound/walking/grass-02.ogg",
                volume = 0.8
            },
            {
                filename = "__base__/sound/walking/grass-03.ogg",
                volume = 0.8
            },
            {
                filename = "__base__/sound/walking/grass-04.ogg",
                volume = 0.8
            }
        },
        --map_color={r=160, g=160, b=160},
        map_color={r=0, g=0, b=0},
        ageing=0.0004,
        vehicle_friction_modifier = grass_vehicle_speed_modifier,
        pollution_absorption_per_second = 0.00001
    },

    {
        type = "tile",
        name = "cave-wall",
        collision_mask =
        {
            "water-tile",
            "ground-tile",
            "item-layer",
            "resource-layer",
            "player-layer",
            "doodad-layer",
        },
        minable = {hardness = 0.2, mining_time = 5.0, results = {
          {
            amount_max = 2,
            amount_min = 0,
            name = "stone"
          }
        }},
        autoplace = make_autoplace_settings(true),
        layer = 80,
        needs_correction = false,
        variants =
        {
            main =
            {
                {
                    picture = "__Surfaces_Caves__/graphics/terrain/cave-wall/cave1.png",
                    count = 16,
                    size = 1
                },
                {
                    picture = "__Surfaces_Caves__/graphics/terrain/cave-wall/cave2.png",
                    count = 16,
                    size = 2
                },
                {
                    picture = "__Surfaces_Caves__/graphics/terrain/cave-wall/cave4.png",
                    count = 16,
                    size = 4
                }
            },
            inner_corner =
            {
                picture = "__Surfaces_Caves__/graphics/terrain/cave-wall/cave-inner-corner.png",
                count = 1
            },
            outer_corner =
            {
                picture = "__Surfaces_Caves__/graphics/terrain/cave-wall/cave-outer-corner.png",
                count = 1
            },
            side =
            {
                picture = "__Surfaces_Caves__/graphics/terrain/cave-wall/cave-side.png",
                count = 1
            },
            u_transition = 
            {
                picture = "__Surfaces_Caves__/graphics/terrain/cave-wall/cave-u.png",
                count = 1
            },
            o_transition = 
            {
                picture = "__Surfaces_Caves__/graphics/terrain/cave-wall/cave-o.png",
                count = 1
            },
        },
        allowed_neighbors = nil,
        map_color=color,
        ageing=0.0006,
        pollution_absorption_per_second = 0.0001
    },

    {
        type = "item",
        name = "explosive-landfill-cave-ground",
        icon = "__Surfaces_Caves__/graphics/icons/explosive-landfill.png",
        icon_size = 32,
        subgroup = "terrain",
        order = "a[explosive-landfill-cave-ground]",
        stack_size = 100,
        place_as_tile =
        {
            result = "cave-ground",
            condition_size = 1,
            condition = { }
        }
    },

    {
        type = "recipe",
        name = "explosive-landfill-cave-ground",
        enabled = "true",
        category = "crafting",
        ingredients =
        {
            {name = "explosives", amount = 1},
        },
        energy_required = 2,
        result = "explosive-landfill-cave-ground",
        result_count = 5
    },
})
