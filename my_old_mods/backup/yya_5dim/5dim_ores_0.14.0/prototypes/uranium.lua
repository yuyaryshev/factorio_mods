uranium =
{
  name = "uranium-ore",
  tint = {r = 0, g = 0.75, b = 0},
  map_color = {r = 0, g = 0.375, b = 0},
  hardness = 2.6,
  mining_time = 2,
  enabled = true,
  icon = "__5dim_nuclear__/graphics/icon/uranium-ore.png",
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
    control = "uranium-ore",
    sharpness = 1,
    richness_multiplier = 11000,
    richness_base = 200,
    size_control_multiplier = 0.06,
    peaks =
    {
      {
        influence = 0.2,
        starting_area_weight_optimal = 0,
        starting_area_weight_range = 0,
        starting_area_weight_max_range = 2,
      },
      {
        influence = 0.65,
        noise_layer = "uranium-ore",
        noise_octaves_difference = -2.3,
        noise_persistence = 0.35,
        starting_area_weight_optimal = 0,
        starting_area_weight_range = 0,
        starting_area_weight_max_range = 2,
      },
    },
  }
}


