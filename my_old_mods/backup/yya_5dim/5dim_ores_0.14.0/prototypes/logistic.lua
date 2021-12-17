data:extend({
  {
    type = "recipe",
    name = "5d-repair-pack-2",
    ingredients =
    {
      {"electronic-circuit", 2},
      {"iron-gear-wheel", 1}
    },
    result = "5d-repair-pack-2"
  },
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
  {
    type = "recipe",
    name = "5d-storage",
    enabled = "false",
    ingredients =
    {
      {"logistic-chest-storage", 1},
      --{"smart-chest", 1},
      {"advanced-circuit", 1}
    },
    result = "5d-storage"
  },
  {
    type = "recipe",
    name = "5d-logistic-robot-2",
    enabled = "false",
    ingredients =
    {
      {"logistic-robot", 1},
      {"advanced-circuit", 2}
    },
    result = "5d-logistic-robot-2"
  },
  {
    type = "recipe",
    name = "5d-construction-robot-2",
    enabled = "false",
    ingredients =
    {
      {"construction-robot", 1},
      {"electronic-circuit", 2}
    },
    result = "5d-construction-robot-2"
  },
  {
    type = "recipe",
    name = "5d-roboport-2",
    enabled = "false",
    ingredients =
    {
      {"roboport", 1},
      {"5d-tin-plate", 100},
      {"processing-unit", 20},
    },
    result = "5d-roboport-2",
    energy_required = 15
  },
  {
    type = "recipe",
    name = "5d-requester",
    enabled = "false",
    ingredients =
    {
      {"logistic-chest-requester", 1},
      --{"smart-chest", 1},
      {"advanced-circuit", 1}
    },
    result = "5d-requester"
  },
})