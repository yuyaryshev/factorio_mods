gold =
{
  name = "gold-ore",
  tint = {r = 1, g = 0.75, b = 0},
  map_color = {r=0.9, g=0.63, b=0},
  hardness = 0.6,
  mining_time = 2,
  enabled = true,
  icon = "__5dim_ores__/graphics/icon/gold-ore.png",
  stage_mult = 10,
  item =
  {
    create = true,
    stack_size = 200
  },
  sprite =
  {
    sheet = 2
  },
  autoplace =
  {
    create = true,
    starting_area = false,
    richness = 1,
    size = 1.2
  }
}

data:extend({
-- Item
  {
    type = "item",
    name = "gold-plate",
    icon = "__5dim_core__/graphics/icon/gold-plate.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "plates-plates",
    order = "ag",
    stack_size = 200
  },

--Recipe
  {
    type = "recipe",
    name = "5d-gold-plate",
    category = "smelting",
    energy_required = 7,
    ingredients = {{ "gold-ore", 2}},
    result = "gold-plate"
  },
  
-- Item
  {
    type = "item",
    name = "5d-gold-wire",
    icon = "__5dim_core__/graphics/icon/5dim_icon_goldwire.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "logistic-wire",
    order = "d",
    stack_size = 500
  },

--Recipe
  {
    type = "recipe",
    name = "5d-gold-wire",
    ingredients = {{"gold-plate", 1}},
    result_count = 3,
    result = "5d-gold-wire"
  },
  
-- Item
  {
    type = "item",
    name = "5d-gold-circuit",
    icon = "__5dim_core__/graphics/icon/icon_5dim-circuit.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "intermediate-chip",
    order = "d",
    stack_size = 500
  },

--Recipe
  {
    type = "recipe",
    name = "5d-gold-circuit",
    ingredients = 
	{
		{"5d-gold-wire", 4},
		{"iron-plate", 1},
		{"5d-tin-plate", 5},
	},
    result = "5d-gold-circuit"
  },
})