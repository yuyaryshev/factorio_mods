data:extend(
{
	{
		type = "selection-tool",
		name = "dump-entities-planner",
		icon = "__DumpEntitiesPlanner__/graphics/icons/dump-entities-planner.png",
		icon_size = 32,
		flags = { "goes-to-quickbar" },
		subgroup = "tool",
		order = "1",
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
		name = "dump-entities-planner",
		energy_required = 0.01,
		ingredients = {},
		result = "dump-entities-planner",
		enabled = true
	},
})