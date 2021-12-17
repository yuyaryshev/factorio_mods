data:extend(
{
  {
    type = "gun",
    name = "tank-cannon-2",
    icon = "__base__/graphics/icons/tank-cannon.png",
    flags = {"goes-to-main-inventory", "hidden"},
    subgroup = "gun",
    order = "z[tank]-a[cannon]",
    attack_parameters =
    {
      type = "projectile",
	  ammo_category = "cannon-shell",
      cooldown = 5,
      movement_slow_down_factor = 0,
      projectile_creation_distance = 0.6,
      range = 200,
      sound =
      {
        {
          filename = "__base__/sound/fight/tank-cannon.ogg",
          volume = 0.3
        }
      }
    },
    stack_size = 5
  },
--tank-flamer
  {
    type = "gun",
    name = "tank-flamer",
    icon = "__base__/graphics/icons/flame-thrower.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "gun",
    order = "e[flame-thrower]",
    attack_parameters =
    {
      type = "projectile",
	  ammo_category = "tank-spray-ammo",
      cooldown = 1,
      movement_slow_down_factor = 0,
      projectile_creation_distance = 0.7,
      range = 150
    },
    stack_size = 1
  },
--tank-auto-cannon
	{
    type = "gun",
    name = "tank-auto-cannon",
    icon = "__base__/graphics/icons/tank-cannon.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "gun",
    order = "z[tank]-a[cannon]",
    attack_parameters =
    {
      type = "projectile",
	  ammo_category = "auto-cannon-ammo",
      cooldown = 1,
      movement_slow_down_factor = 0,
      projectile_creation_distance = 0.6,
      range = 200,
      sound =
      {
        {
          filename = "__base__/sound/fight/tank-cannon.ogg",
          volume = 0.5
        }
      }
    },
    stack_size = 1
    },
--tank-nade-cannon
	{
    type = "gun",
    name = "tank-nade-cannon",
    icon = "__base__/graphics/icons/tank-cannon.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "gun",
    order = "z[tank]-a[cannon]",
    attack_parameters =
    {
      type = "projectile",
	  ammo_category = "tank-nade-ammo",
      cooldown = 10,
      movement_slow_down_factor = 0,
      projectile_creation_distance = 2,
      range = 500,
      sound =
      {
        {
          filename = "__base__/sound/fight/tank-cannon.ogg",
          volume = 1
        }
      }
    },
    stack_size = 1
    },
--tank-mine-cannon
	{
    type = "gun",
    name = "tank-mine-cannon",
    icon = "__base__/graphics/icons/tank-cannon.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "gun",
    order = "z[tank]-a[cannon]",
    attack_parameters =
    {
      type = "projectile",
	  ammo_category = "tank-mine-ammo",
      cooldown = 5,
      movement_slow_down_factor = 0,
      projectile_creation_distance = 2,
      range = 50,
      sound =
      {
        {
          filename = "__base__/sound/fight/tank-cannon.ogg",
          volume = 0.2
        }
      }
    },
    stack_size = 1
    },
--machinegun-array
  {
    type = "gun",
    name = "tank-machinegun-turret",
    icon = "__base__/graphics/icons/submachine-gun.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "gun",
    order = "a[basic-clips]-b[submachine-gun]",
    attack_parameters =
    {
      type = "projectile",
	  ammo_category = "bullet",
      cooldown = 0.1,
      movement_slow_down_factor = 0,
      shell_particle =
      {
        name = "shell-particle",
        direction_deviation = 0.1,
        speed = 0.1,
        speed_deviation = 0.03,
        center = {0, 0.6},
        creation_distance = 0.9,
        starting_frame_speed = 0.4,
        starting_frame_speed_deviation = 0.1
      },
      projectile_creation_distance = 1.6,
      range = 150,
      sound =
      {
        {
          filename = "__base__/sound/fight/heavy-gunshot-1.ogg",
          volume = 0.2
        }
      }
    },
    stack_size = 1
  },
--tank-wmd-cannon
	{
    type = "gun",
    name = "tank-wmd-cannon",
    icon = "__base__/graphics/icons/tank-cannon.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "gun",
    order = "z[tank]-a[cannon]",
    attack_parameters =
    {
      type = "projectile",
	  ammo_category = "tank-wmd-ammo",
      cooldown = 10,
      movement_slow_down_factor = 0,
      projectile_creation_distance = 2,
      range = 1250,
      sound =
      {
        {
          filename = "__base__/sound/fight/tank-cannon.ogg",
          volume = 1
        }
      }
    },
    stack_size = 1
    },
--tank-rocket-cannon
  {
    type = "gun",
    name = "tank-rocket-cannon",
    icon = "__base__/graphics/icons/rocket-launcher.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "gun",
    order =  "z[tank]-a[cannon]",
    attack_parameters =
    {
      type = "projectile",
	  ammo_category = "tank-rocket-ammo",
      movement_slow_down_factor = 0,
      cooldown = 3,
      projectile_creation_distance = 0.6,
      range = 500
    },
    stack_size = 1
  },
 }
)