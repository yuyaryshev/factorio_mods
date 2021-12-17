data:extend(
{
	{
		type = "item",
		name = "lo-radio-transmitter",
		icon = "__lo-radio-telemetry__/resources/icons/radio-transmitter.png",
		flags = {"goes-to-quickbar"},
		subgroup = "circuit-network",
		order = "c[radio]-a[transmitter]",
		place_result = "lo-radio-transmitter",
		stack_size = 200,
	},
	{
		type = "item",
		name = "lo-radio-receiver",
		icon = "__lo-radio-telemetry__/resources/icons/radio-receiver.png",
		flags = {"goes-to-quickbar"},
		subgroup = "circuit-network",
		order = "c[radio]-d[receiver]",
		place_result = "lo-radio-receiver",
		stack_size = 200,
	},
}
)