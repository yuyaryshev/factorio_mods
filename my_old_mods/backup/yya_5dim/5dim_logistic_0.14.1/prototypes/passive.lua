data:extend({
-- Item
  {
    type = "item",
    name = "5d-passive",
    icon = "__5dim_logistic__/graphics/icon/5d_icon_logistic-chest-passive-provider_2_.png",
    flags = {"goes-to-quickbar"},
    subgroup = "logistic-pasive",
    order = "b",
    place_result = "5d-passive",
    stack_size = 50
  },

--Recipe
  {
    type = "recipe",
    name = "5d-passive",
    enabled = "false",
    ingredients =
    {
      {"logistic-chest-passive-provider", 1},
      --{"smart-chest", 1},
      {"advanced-circuit", 1}
    },
    result = "5d-passive"
  },

--Entity
  {
    type = "logistic-container",
    name = "5d-passive",
    icon = "__5dim_logistic__/graphics/icon/5d_icon_logistic-chest-passive-provider_2_.png",
    flags = {"placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "5d-passive"},
    max_health = 150,
    corpse = "small-remnants",
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    fast_replaceable_group = "container",
    inventory_size = 96,
    logistic_mode = "passive-provider",
    open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
    close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
    picture =
    {
      filename = "__5dim_logistic__/graphics/icon/5d_icon_logistic-chest-passive-provider_2.png",
      priority = "extra-high",
      width = 38,
      height = 32,
      shift = {0.1, 0}
    },
    circuit_wire_max_distance = 7.5
  },
})