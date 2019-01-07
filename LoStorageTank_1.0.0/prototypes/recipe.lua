data:extend({
  {
    type = "recipe",
    name = "lo-storage-tank",
    energy_required = 30,
    enabled = false,
    ingredients =
    {
      {"storage-tank", 40},
      {"steel-plate", 160}
    },
    result = "lo-storage-tank"
  },
  {
    type = "recipe",
    name = "lo-storage-tank2",
    energy_required = 30,
    enabled = false,
    ingredients =
    {
      {"lo-storage-tank", 32},
      {"steel-plate", 160}
    },
    result = "lo-storage-tank2"
  },
  {
    type = "recipe",
    name = "lo-storage-tank3",
    energy_required = 30,
    enabled = false,
    ingredients =
    {
      {"lo-storage-tank2", 32},
      {"steel-plate", 200}
    },
    result = "lo-storage-tank3"
  },
})