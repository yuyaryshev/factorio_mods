tin =
{
  name = "tin-ore",
  tint = {r = 0.95, g = 0.95, b = 0.95},
  map_color = {r = 0.600, g = 0.600, b = 0.600},
  hardness = 0.8,
  mining_time = 2,
  enabled = true,
  icon = "__5dim_ores__/graphics/icon/tin-ore.png",
  stage_mult = 10,
  item =
  {
    create = true,
    stack_size = 200
  },
  sprite =
  {
    sheet = 1
  },
  autoplace =
  {
    create = true,
    starting_area = true,
    richness = 1.2,
    size = 1.5
  }
}


data:extend({
-- Item
  {
    type = "item",
    name = "5d-tin-plate",
    icon = "__5dim_core__/graphics/icon/tin-plate.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "plates-plates",
    order = "af",
    stack_size = 200
  },
--Recipe
  {
    type = "recipe",
    name = "5d-tin-plate",
    category = "smelting",
    energy_required = 3.5,
    ingredients = {{ "tin-ore", 1}},
    result = "5d-tin-plate"
  },
  
-- Item
  {
    type = "item",
    name = "5d-tin-gear-wheel",
    icon = "__5dim_core__/graphics/icon/icon_5dim_tin-gear-wheel.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "intermediate-gear",
    order = "b",
    stack_size = 100
  },

--Recipe
  {
    type = "recipe",
    name = "5d-tin-gear-wheel",
    ingredients = {{"5d-tin-plate", 2}},
    result = "5d-tin-gear-wheel"
  },
})