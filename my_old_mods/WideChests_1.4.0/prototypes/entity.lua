function MergingChests.CreateWideChestEntity(width)
	local name = "wide-chest-"..width
	return
	{
		type = "container",
		name = name,
		localised_name = "Steel chest "..width.." wide",
		icon = "__base__/graphics/icons/steel-chest.png",
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 2, result = "steel-chest", count = width},
		max_health = 350,
		corpse = "medium-remnants",
		dying_explosion = "medium-explosion",
		open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
		close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
		vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		resistances =
		{
			{
				type = "fire",
				percent = 90
			}
		},
		collision_box = {{-width / 2 + 0.3, -0.35}, {width / 2 - 0.3, 0.35}},
		selection_box = {{-width / 2, -0.5}, {width / 2, 0.5}},
		fast_replaceable_group = "container",
		inventory_size = 48 * width,
		picture =
		{
			filename = "__WideChests__/graphics/entity/chests.png",
			priority = "high",
			y = 32 + 32 * (width - 2),
			width = 32 * width + 14,
			height = 32,
			frame_count = 1,
			shift = {0.1875, 0}
		},
		circuit_wire_connection_point =
		{
			shadow =
			{
				red = {0.734375 - ((width - 1) / 2), 0.453125},
				green = {0.609375 - ((width - 1) / 2), 0.515625},
			},
			wire =
			{
				red = {0.40625 - ((width - 1) / 2), 0.21875},
				green = {0.40625 - ((width - 1) / 2), 0.375},
			}
		},
		circuit_connector_sprites = get_circuit_connector_sprites({0.1875 - ((width - 1) / 2), 0.15625}, nil, 18),
		circuit_wire_max_distance = 50,
	}
end

function MergingChests.CreateHighChestEntity(height)
	local name = "high-chest-"..height
	return
	{
		type = "container",
		name = name,
		localised_name = "Steel chest "..height.." high",
		icon = "__base__/graphics/icons/steel-chest.png",
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 2, result = "steel-chest", count = height},
		max_health = 350,
		corpse = "medium-remnants",
		dying_explosion = "medium-explosion",
		open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
		close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
		vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		resistances =
		{
			{
				type = "fire",
				percent = 90
			}
		},
		collision_box = {{-0.35, -height / 2 + 0.3}, {0.35, height / 2 - 0.3}},
		selection_box = {{-0.5, -height / 2}, {0.5, height / 2}},
		fast_replaceable_group = "container",
		inventory_size = 48 * height,
		picture =
		{
			filename = "__WideChests__/graphics/entity/chests.png",
			priority = "high",
			x = 78 + 46 * (height - 2),
			width = 46,
			height = 32 * height,
			frame_count = 1,
			shift = {0.1875, 0}
		},
		circuit_wire_connection_point =
		{
			shadow =
			{
				red = {0.734375, 0.453125 + (height - 1) / 2},
				green = {0.609375, 0.515625 + (height - 1) / 2},
			},
			wire =
			{
				red = {0.40625, 0.21875 + (height - 1) / 2},
				green = {0.40625, 0.375 + (height - 1) / 2},
			}
		},
		circuit_connector_sprites = get_circuit_connector_sprites({0.1875, 0.15625 + (height - 1) / 2}, nil, 18),
		circuit_wire_max_distance = 50,
	}
end

for i = 2, MergingChests.MaxSize do
	data:extend({MergingChests.CreateWideChestEntity(i), MergingChests.CreateHighChestEntity(i)})
end