data:extend(
{
    {
        type = "lamp",
        name = "lo-radio-transmitter",
        icon = "__lo-radio-telemetry__/resources/icons/radio-transmitter.png",
        flags = {"placeable-neutral", "player-creation"},
        minable = {hardness = 0.2, mining_time = 0.75, result = "lo-radio-transmitter"},
        max_health = 125,
        corpse = "medium-remnants",
        collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
        selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
        vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
        fast_replaceable_group = "lo-radio-equipment",
        light =
        {
            intensity = 0.0,
            size = 0
        },
        picture_off =
        {
            filename = "__lo-radio-telemetry__/resources/entity/radio-transmitter.png",
            priority = "high",
            width = 235,
            height = 207,
            frame_count = 1,
            axially_symmetrical = false,
            direction_count = 1,
            shift = {2.69, -1.91},
        },
        picture_on =
        {
            filename = "__lo-radio-telemetry__/resources/blank.png",
            priority = "high",
            width = 1,
            height = 1,
            frame_count = 1,
            axially_symmetrical = false,
            direction_count = 1,
            shift = {0.0, 0.0},
        },
        circuit_wire_connection_point =
        {
            shadow =
            {
                red = {1.09, -0.19},
                green = {0.34, 0.56},
            },
            wire =
            {
                red = {0.66, -0.53},
                green = {-0.13, 0.22},
            }
        },
        circuit_wire_max_distance = 7.5
  },
    {
        type = "constant-combinator",
        name = "lo-radio-receiver",
        icon = "__lo-radio-telemetry__/resources/icons/radio-receiver.png",
        flags = {"placeable-neutral", "player-creation"},
        minable = {hardness = 0.2, mining_time = 0.75, result = "lo-radio-receiver"},
        max_health = 100,
        corpse = "medium-remnants",
        collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
        selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
        fast_replaceable_group = "lo-radio-equipment",
        item_slot_count = 20,
        --energy_source =
        --{
            --type = "electric",
            --usage_priority = "secondary-input",
            --buffer_capacity = "50kJ",
        --},
        --energy_usage_per_tick = "50kW",
        --apparently, constant combinators can't use electricity even if they want to
        sprites =
        {
            north =
            {
                filename = "__lo-radio-telemetry__/resources/entity/radio-receiver.png",
                width = 203,
                height = 179,
                frame_count = 1,
                shift = {2.25, -1.91},
            },
            east =
            {
                filename = "__lo-radio-telemetry__/resources/entity/radio-receiver.png",
                width = 203,
                height = 179,
                frame_count = 1,
                shift = {2.25, -1.91},
            },
            south =
            {
                filename = "__lo-radio-telemetry__/resources/entity/radio-receiver.png",
                width = 203,
                height = 179,
                frame_count = 1,
                shift = {2.25, -1.91},
            },
            west =
            {
                filename = "__lo-radio-telemetry__/resources/entity/radio-receiver.png",
                width = 203,
                height = 179,
                frame_count = 1,
                shift = {2.25, -1.91},
            }
        },
        activity_led_sprites =
        {
            north =
            {
                filename = "__lo-radio-telemetry__/resources/blank.png",
                width = 1,
                height = 1,
                frame_count = 1
            },
            east =
            {
                filename = "__lo-radio-telemetry__/resources/blank.png",
                width = 1,
                height = 1,
                frame_count = 1
            },
            south =
            {
                filename = "__lo-radio-telemetry__/resources/blank.png",
                width = 1,
                height = 1,
                frame_count = 1
            },
            west =
            {
                filename = "__lo-radio-telemetry__/resources/blank.png",
                width = 1,
                height = 1,
                frame_count = 1
            }
        },
        activity_led_light =
        {
            intensity = 0,
            size = 0
        },
        activity_led_light_offsets =
        {
            {0, 0},
            {0, 0},
            {0, 0},
            {0, 0}
        },
        circuit_wire_connection_points =
        {
            {
                shadow =
                {
                    red = {-0.09, 0.19},
                    green = {0.81, 0.47},
                },
                wire =
                {
                    red = {-0.41, -0.19},
                    green = {0.37, 0.0},
                }
            },
            {
                shadow =
                {
                    red = {-0.09, 0.19},
                    green = {0.81, 0.47},
                },
                wire =
                {
                    red = {-0.41, -0.19},
                    green = {0.37, 0.0},
                }
            },
            {
                shadow =
                {
                    red = {-0.09, 0.19},
                    green = {0.81, 0.47},
                },
                wire =
                {
                    red = {-0.41, -0.19},
                    green = {0.37, 0.0},
                }
            },
            {
                shadow =
                {
                    red = {-0.09, 0.19},
                    green = {0.81, 0.47},
                },
                wire =
                {
                    red = {-0.41, -0.19},
                    green = {0.37, 0.0},
                }
            }
        },
        circuit_wire_max_distance = 7.5
    },
}
)