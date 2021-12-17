data:extend(
{
    {
        type = "technology",
        name = "lo-radio-telemetry",
        icon = "__lo-radio-telemetry__/resources/icons/telemetry.png",
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "lo-radio-transmitter"
            },
            {
                type = "unlock-recipe",
                recipe = "lo-radio-receiver"
            },
        },
        prerequisites = {"circuit-network"},
        unit =
        {
            count = 50,
            ingredients =
            {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
            },
            time = 30
        },
        order = "a-d-e",
    },
}
)