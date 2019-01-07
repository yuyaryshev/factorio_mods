data:extend(
{
	{
		type = "selection-tool",
		name = "bluebuild-selector",
		localised_name = "Bluebuild Selector",
		icon = "__ght-lo-bluebuild__/graphics/icons/bluebuild-selector.png",
		flags = { "goes-to-quickbar" },
		subgroup = "tool",
		order = "c[automated-construction]-a[blueprint]",
		stack_size = 1,
		stackable = false,
		draw_label_for_cursor_render = true,
		item_to_clear = "electronic-circuit",
		selection_color = { r = 0, g = 0, b = 1 },
		alt_selection_color = { r = 0, g = 0, b = 1 },
		selection_mode = { "blueprint" },
		alt_selection_mode = { "blueprint" },
		selection_cursor_box_type = "copy",
		alt_selection_cursor_box_type = "copy",
		icon_size = 32,		
	},
})