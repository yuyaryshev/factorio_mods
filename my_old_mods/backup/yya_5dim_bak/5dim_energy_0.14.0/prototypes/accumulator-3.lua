data:extend({
-- Item
  {
    type = "item",
    name = "5d-basic-accumulator-3",
    icon = "__5dim_energy__/graphics/icon/icon_5d_acumulator3_.png",
    flags = {"goes-to-quickbar"},
    subgroup = "energy-accumulator",
    order = "c",
    place_result = "5d-basic-accumulator-3",
    stack_size = 50
  },

--Recipe
  {
    type = "recipe",
    name = "5d-basic-accumulator-3",
    energy_required = 10,
    enabled = "false",
    ingredients =
    {
      {"copper-plate", 5},
      {"iron-plate", 4},
      {"battery", 7},
      {"5d-basic-accumulator-2", 1},
    },
    result = "5d-basic-accumulator-3"
  },

--Entity
  {
    type = "accumulator",
    name = "5d-basic-accumulator-3",
    icon = "__5dim_energy__/graphics/icon/icon_5d_acumulator3_.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "5d-basic-accumulator-3"},
    max_health = 150,
    corpse = "medium-remnants",
    collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
    selection_box = {{-1, -1}, {1, 1}},
    energy_source =
    {
      type = "electric",
      buffer_capacity = "20MJ",
      usage_priority = "terciary",
      input_flow_limit = "1200kW",
      output_flow_limit = "1200kW"
    },
    picture =
    {
      filename = "__5dim_energy__/graphics/icon/icon_5d_acumulator_3.png",
      priority = "extra-high",
      width = 124,
      height = 103,
      shift = {0.7, -0.2}
    },
    charge_animation =
    {
      filename = "__5dim_energy__/graphics/icon/item_5d_basic-accumulator-charge_3.png",
      width = 138,
      height = 135,
      line_length = 8,
      frame_count = 24,
      shift = {0.482, -0.638},
      animation_speed = 0.5
    },
    charge_cooldown = 30,
    charge_light = {intensity = 0.3, size = 7},
    discharge_animation =
    {
      filename = "__5dim_energy__/graphics/icon/item_5d_basic-accumulator-discharge_3.png",
      width = 147,
      height = 128,
      line_length = 8,
      frame_count = 24,
      shift = {0.395, -0.525},
      animation_speed = 0.5
    },
    discharge_cooldown = 60,
    discharge_light = {intensity = 0.7, size = 7},
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/accumulator-working.ogg",
        volume = 1
      },
      idle_sound = {
        filename = "__base__/sound/accumulator-idle.ogg",
        volume = 0.4
      },
      max_sounds_per_type = 5
    },
  },
})