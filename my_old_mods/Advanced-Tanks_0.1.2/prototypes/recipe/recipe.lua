data:extend(
{
  {
    type = "recipe",
    name = "tank-assembling-machine",
    enabled = "false",
    ingredients =
    {
      {"iron-plate", 1},
      {"electronic-circuit", 3},
      {"iron-gear-wheel", 5},
      {"assembling-machine-2", 1}
    },
    result = "tank-assembling-machine"
  },
  {
    type = "recipe",
    name = "tank-ammo-assembling-machine",
    enabled = "false",
    ingredients =
    {
      {"iron-plate", 1},
      {"electronic-circuit", 3},
      {"iron-gear-wheel", 5},
      {"assembling-machine-2", 1}
    },
    result = "tank-ammo-assembling-machine"
  },
    {
    type = "recipe",
    name = "tank-light-chasis-wlsk",
    enabled = "false",
	category = "tank-crafting",
    ingredients =
    {
      {"iron-plate", 1},
      --{"electronic-circuit", 3},
      --{"iron-gear-wheel", 5},
      --{"assembling-machine-2", 1}
    },
    result = "tank-light-chasis-wlsk"
  },
--ammo components
    {
    type = "recipe",
    name = "tank-ammo-universal-explosive",
    enabled = "false",
	category = "tank-ammo-component",
    energy_required = 5,
    ingredients =
    {
      {"plastic-bar", 7},
	  {"explosives", 12}
    },
    results=
    {
      {type="item", name="tank-ammo-universal-explosive", amount=3},
    },
    },
    {
    type = "recipe",
    name = "tank-ammo-universal-explosive-synthetic",
    enabled = "false",
	category = "tank-ammo-component",
    energy_required = 60,
    ingredients =
    {
      {"raw-wood", 100},
	  {"stone", 100}
    },
    results=
    {
      {type="item", name="tank-ammo-universal-explosive", amount=9},
    },
    },
	
    {
    type = "recipe",
    name = "tank-ammo-universal-casing",
    enabled = "false",
	category = "tank-ammo-component",
    energy_required = 5,
    ingredients =
    {
      {"steel-plate", 7},
      {"copper-plate", 12}
    },
    results=
    {
      {type="item", name="tank-ammo-universal-casing", amount=3},
    },
    },
--xtras
  {
    type = "recipe",
    name = "land-mine-poison",
    enabled = "false",
    energy_required = 5,
    ingredients =
    {
      {"steel-plate", 1},
      {"explosives", 2},
	  {"sulfur", 1},
    },
    result = "land-mine-poison",
    result_count = 4
  },
}
)
--