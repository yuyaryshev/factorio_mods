data:extend(
{
	{
		type = "custom-input",
		name = "powerisolate-lock-electric-network",
		key_sequence = "l",
	},
	{
		type = "selection-tool",
		name = "isolate-planner",
		icon = "__PowerIsolate__/graphics/icons/isolate-planner.png",
		icon_size = 32,
		flags = { "goes-to-quickbar" },
		subgroup = "tool",
		order = "c[automated-construction]-a[blueprint]",
		stack_size = 1,
		draw_label_for_cursor_render = true,
		selection_color = { r = 0, g = 0, b = 1 },
		alt_selection_color = { r = 1, g = 0, b = 0 },
		selection_mode = { "blueprint", "matches-force" },
		alt_selection_mode = { "blueprint", "matches-force" },
		selection_cursor_box_type = "entity",
		alt_selection_cursor_box_type = "entity"
	},
	{
		type = "recipe",
		name = "isolate-planner",
		energy_required = 0.01,
		ingredients = {},
		result = "isolate-planner",
		enabled = true
	},
})