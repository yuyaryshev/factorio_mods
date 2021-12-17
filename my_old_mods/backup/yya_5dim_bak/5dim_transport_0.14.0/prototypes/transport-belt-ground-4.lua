data:extend({
-- Item
  {
    type = "item",
    name = "5d-mk4-transport-belt-to-ground",
    icon = "__5dim_transport__/graphics/icon/icon_5d_ground-structure_4_.png",
    flags = {"goes-to-quickbar"},
    subgroup = "transport-ground",
    order = "d",
    place_result = "5d-mk4-transport-belt-to-ground",
    stack_size = 50
  },

--Recipe
  {
    type = "recipe",
    name = "5d-mk4-transport-belt-to-ground",
    enabled = "false",
    energy_required = 1,
    ingredients =
    {
      {"iron-plate", 10},
      {"5d-mk4-transport-belt", 5}
    },
    result_count = 2,
    result = "5d-mk4-transport-belt-to-ground"
  },

--Entity
  {
    type = "underground-belt",
    name = "5d-mk4-transport-belt-to-ground",
    icon = "__base__/graphics/icons/express-underground-belt.png",
    flags = {"placeable-neutral", "player-creation", "fast-replaceable-no-build-while-moving"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "5d-mk4-transport-belt-to-ground"},
    max_health = 60,
    corpse = "small-remnants",
    max_distance = 5,
    underground_sprite =
    {
      filename = "__core__/graphics/arrows/underground-lines.png",
      priority = "high",
      width = 32,
      height = 32,
      x = 32
    },
    resistances = 
    {
      {
        type = "fire",
        percent = 60
      }
    },
    collision_box = {{-0.4, -0.15}, {0.4, 0.1}},
    selection_box = {{-0.5, -0.25}, {0.5, 0.75}},
    distance_to_enter = 0.35,
    animation_speed_coefficient = 32,
    belt_horizontal = mk4_belt_horizontal, -- specified in transport-belt-pictures.lua
    belt_vertical = mk4_belt_vertical,
    ending_top = mk4_belt_ending_top,
    ending_bottom = mk4_belt_ending_bottom,
    ending_side = mk4_belt_ending_side,
    starting_top = mk4_belt_starting_top,
    starting_bottom = mk4_belt_starting_bottom,
    starting_side = mk4_belt_starting_side,
    fast_replaceable_group = "transport-belt-to-ground",
    speed = 0.09375,
    structure =
    {
      direction_in =
      {
        sheet =
        {
          filename = "__5dim_transport__/graphics/icon/icon_5d_ground-structure_4.png",
          priority = "extra-high",
          shift = {0.26, 0},
          width = 57,
          height = 43,
          y = 43
        }
      },
      direction_out =
      {
        sheet =
        {
          filename = "__5dim_transport__/graphics/icon/icon_5d_ground-structure_4.png",
          priority = "extra-high",
          shift = {0.26, 0},
          width = 57,
          height = 43
        }
      }
    },
    ending_patch = ending_patch_prototype
  },
})