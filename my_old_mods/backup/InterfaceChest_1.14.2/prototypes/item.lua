data:extend(
	{
		{
		type = "item",
		name = "interface-chest",
		icon = "__InterfaceChest__/graphics/icon/interfacechest.png",
		flags = {"goes-to-quickbar"},
		subgroup = "storage",
		order = "a[items]-e[interface-chest]",
		place_result = "interface-chest",
		stack_size = 50
		},
		{
		type = "item",
		name = "interface-chest-trash",
		icon = "__InterfaceChest__/graphics/icon/trashchest.png",
		flags = {"goes-to-quickbar"},
		subgroup = "storage",
		order = "a[items]-f[interface-chest]",
		place_result = "interface-chest-trash",
		stack_size = 50
		}
		,
		{
		type = "item",
		name = "interface-belt-balancer",
		icon = "__InterfaceChest__/graphics/icon/belt-balancer.png",
		flags = {"goes-to-quickbar"},
		subgroup = "belt",
		order = "a[transport-belt]-d[interface-belt-balancer]",
		place_result = "interface-belt-balancer",
		stack_size = 50
		}
	}
)