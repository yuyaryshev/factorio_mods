boilerfires3 =
{
  down =
  {
    filename = "__5dim_energy__/graphics/icon/boiler-fire-down_3.png",
    priority = "extra-high",
    width = 11,
    height = 11,
    frame_count = 32,
    line_length = 8,
    shift = {0.03125, 0.28125}
  },
  left =
  {
    filename = "__5dim_energy__/graphics/icon/boiler-fire-left_3.png",
    priority = "extra-high",
    width = 5,
    height = 7,
    frame_count = 14,
    shift = {-0.4375, -0.09375}
  },
  right =
  {
    filename = "__5dim_energy__/graphics/icon/boiler-fire-right_3.png",
    priority = "extra-high",
    width = 6,
    height = 9,
    frame_count = 14,
    shift = {0.46875, -0.0625}
  }
}

data:extend({
-- Item
  {
    type = "item",
    name = "5d-boiler-2",
    icon = "__5dim_energy__/graphics/icon/icon_5d_boiler_3_.png",
    flags = {"goes-to-quickbar"},
    subgroup = "energy-boiler",
    order = "c",
    place_result = "5d-boiler-2",
    stack_size = 50
  },

--Recipe
  {
    type = "recipe",
    name = "5d-boiler-2",
    enabled = "false",
    ingredients = 
	{
		{"steel-furnace", 1},
		{"5d-boiler", 1},
		{"pipe", 3},
	},
    result = "5d-boiler-2"
  },

--Entity
  {
    type = "boiler",
    name = "5d-boiler-2",
    icon = "__5dim_energy__/graphics/icon/icon_5d_boiler_3_.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "5d-boiler-2"},
    max_health = 100,
    corpse = "small-remnants",
    resistances =
    {
      {
        type = "fire",
        percent = 80
      }
    },
    fast_replaceable_group = "pipe",
    collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    fluid_box =
    {
      base_area = 5,
      pipe_covers = pipecoverspictures(),
      pipe_connections =
      {
        { position = {0, -1} },
        { position = {1, 0} },
        { position = {0, 1} },
        { position = {-1, 0} }
      },
    },
    energy_consumption = "390kW",
    burner =
    {
      effectivity = 1.0,
      fuel_inventory_size = 1,
      emissions = 0.1 / 6.5,
      smoke =
      {
        {
          name = "smoke",
          deviation = {0.1, 0.1},
          frequency = 1
        }
      }
    },
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/boiler.ogg",
        volume = 0.8
      },
      max_sounds_per_type = 3
    },
    structure =
    {
      left =
      {
        filename = "__5dim_energy__/graphics/icon/icon_5d_boiler-left_3.png",
        priority = "extra-high",
        width = 46,
        height = 46,
        shift = {0.03125, 0}
      },
      down =
      {
        filename = "__5dim_energy__/graphics/icon/icon_5d_boiler-down_3.png",
        priority = "extra-high",
        width = 66,
        height = 72 --, shift = {0.05, 0}
      },
      left_down =
      {
        filename = "__5dim_energy__/graphics/icon/icon_5d_boiler-left-down_3.png",
        priority = "extra-high",
        width = 60,
        height = 50 --, shift = {0, -0.02}
      },
      right_down =
      {
        filename = "__5dim_energy__/graphics/icon/icon_5d_boiler-right-down_3.png",
        priority = "extra-high",
        width = 44,
        height = 50
      },
      left_up =
      {
        filename = "__5dim_energy__/graphics/icon/icon_5d_boiler-left-up_3.png",
        priority = "extra-high",
        width = 66,
        height = 74 --, shift = {0.05, 0}
      },
      right_up =
      {
        filename = "__5dim_energy__/graphics/icon/icon_5d_boiler-right-up_3.png",
        priority = "extra-high",
        width = 46,
        height = 72 --, shift = {0.15, 0}
      },
      t_down =
      {
        filename = "__5dim_energy__/graphics/icon/icon_5d_boiler-t-down_3.png",
        priority = "extra-high",
        width = 44,
        height = 50 --, shift = {0, 0}
      },
      t_up =
      {
        filename = "__5dim_energy__/graphics/icon/icon_5d_boiler-t-up_3.png",
        priority = "extra-high",
        width = 46,
        height = 70 --, shift = {0, 0}
      }
    },
    fire =
    {
      left = boilerfires3.down,
      down = boilerfires3.left,
      left_down = boilerfires3.right,
      right_down = boilerfires3.left,
      left_up = boilerfires3.down,
      right_up = boilerfires3.down,
      t_up = boilerfires3.down
    },
    burning_cooldown = 20,
    -- these are the pipe pictures - boiler is a pipe as well
    pictures = pipepictures()
  },
})