function MergingChests.CreateWideChestItem(width)
	local name = "wide-chest-"..width
	return
	{
		type = "item",
		name = name,
		localised_name = name,
		icon = "__base__/graphics/icons/steel-chest.png",
		flags = {"goes-to-quickbar"},
		subgroup = "storage",
		order = "d[items]-b[steel-chest]h"..string.format("%02d", width),
		place_result = name,
		stack_size = 50
	}
end

function MergingChests.CreateHighChestItem(height)
	local name = "high-chest-"..height
	return
	{
		type = "item",
		name = name,
		localised_name = name,
		icon = "__base__/graphics/icons/steel-chest.png",
		flags = {"goes-to-quickbar"},
		subgroup = "storage",
		order = "d[items]-b[steel-chest]w"..string.format("%02d", height),
		place_result = name,
		stack_size = 50
	}
end

for i = 2, MergingChests.MaxSize do
	data:extend({MergingChests.CreateWideChestItem(i), MergingChests.CreateHighChestItem(i)})
end

data:extend(
{
	{
		type = "selection-tool",
		name = "merge-chest-selector",
		localised_name = "Steel Chest Merge Tool",
		icon = "__WideChests__/graphics/icons/merge-chest-selector.png",
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
		alt_selection_cursor_box_type = "copy"
	},
})