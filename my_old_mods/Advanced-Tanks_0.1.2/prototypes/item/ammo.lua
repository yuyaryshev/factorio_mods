data:extend(
{  
--shell-brick
  {
    type = "ammo",
    name = "piercing-shotgun-shell-brick",
    icon = "__Advanced-Tanks__/graphics/icons/shell-brick.png",
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "shotgun-shell",
      target_type = "direction",
      source_effects =
      {
        type = "create-entity",
        entity_name = "explosion-gunshot"
      },
      action =
      {
        type = "direct",
        repeat_count = 16,
        action_delivery =
        {
          type = "projectile",
          projectile = "piercing-shotgun-pellet",
          starting_speed = 1,
          direction_deviation = 0.3,
          range_deviation = 0.3,
          max_range = 15,
        }
      }
    },
    magazine_size = 50,
    subgroup = "tank-ammo-infantry",
    order = "b[tank-ammo]",
    stack_size = 50
  },
--bullet-brick
  {
    type = "ammo",
    name = "ap-bullet-brick",
    icon = "__Advanced-Tanks__/graphics/icons/bullet-brick.png",
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "bullet",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          source_effects =
          {
              type = "create-entity",
              entity_name = "explosion-gunshot"
          },
          target_effects =
          {
            {
              type = "create-entity",
              entity_name = "explosion-gunshot"
            },
            {
              type = "damage",
              damage = { amount = 4 , type = "physical"}
            }
          }
        }
      }
    },
    magazine_size = 100,
    subgroup = "tank-ammo-infantry",
    order = "b[tank-ammo]",
    stack_size = 50
  },
--flame-thrower-ammo-tanker
	{
    type = "ammo",
    name = "flame-thrower-ammo-tanker",
    icon = "__Advanced-Tanks__/graphics/icons/flame-thrower-ammo-tanker.png",
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "tank-spray-ammo",
      target_type = "direction",
      action =
      {
        type = "direct",
        action_delivery =
        {
          {
            type = "flame-thrower",
            explosion = "tank-flame-thrower-explosion",
            direction_deviation = 0.07,
            speed_deviation = 0.1,
            starting_frame_deviation = 0.07,
            projectile_starting_speed = 0.2,
            starting_distance = 0.6,
          }
        }
      }
    },
    magazine_size = 500,
    subgroup = "tank-ammo",
    order = "b[tank-ammo]",
    stack_size = 10
  },
--"45mm-auto"
	{
    type = "ammo",
    name = "45mm-auto",
    icon = "__Advanced-Tanks__/graphics/icons/cannon-auto-ammo.png",
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "auto-cannon-ammo",
      target_type = "direction",
      source_effects =
      {
        type = "create-entity",
        entity_name = "explosion-gunshot"
      },
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "45mm-projectile",
          starting_speed = 1,
          direction_deviation = 0.1,
          range_deviation = 0.1,
          max_range = 30
        }
      },
    },
    magazine_size = 3,
    subgroup = "tank-ammo",
    order = "a[tank-ammo]",
    stack_size = 500
  },

--50mm-mortar
	{
    type = "ammo",
    name = "50mm-mortar",
    icon = "__Advanced-Tanks__/graphics/icons/nade_tank_ammo.png",
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "tank-nade-ammo",
      target_type = "direction",
      source_effects =
      {
        type = "create-entity",
        entity_name = "explosion-gunshot"
      },
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "50mm-projectile",
          starting_speed = 1,
          direction_deviation = 0.1,
          range_deviation = 0.1,
          max_range = 750
        }
      },
    },
    magazine_size = 1,
    subgroup = "tank-ammo",
    order = "a[tank-ammo]",
    stack_size = 500
  },
--50mm-mortar-poison
	{
    type = "ammo",
    name = "50mm-mortar-poison",
    icon = "__Advanced-Tanks__/graphics/icons/nade_tank_ammo-poison.png",
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "tank-nade-ammo",
      target_type = "direction",
      source_effects =
      {
        type = "create-entity",
        entity_name = "explosion-gunshot"
      },
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "50mm-projectile-poison",
          starting_speed = 1,
          direction_deviation = 0.1,
          range_deviation = 0.1,
          max_range = 750
        }
      },
    },
    magazine_size = 1,
    subgroup = "tank-ammo",
    order = "a[tank-ammo]",
    stack_size = 500
  },
--minepack
	{
    type = "ammo",
    name = "minepack",
    icon = "__Advanced-Tanks__/graphics/icons/mine-pack.png",
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "tank-mine-ammo",
      target_type = "direction",
      source_effects =
      {
        type = "create-entity",
        entity_name = "explosion-gunshot"
      },
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "tank-mine-projectile",
          starting_speed = 1,
          direction_deviation = 0.1,
          range_deviation = 0.1,
          max_range = 50
        }
      },
    },
    magazine_size = 10,
    subgroup = "tank-ammo",
    order = "a[tank-ammo]",
    stack_size = 10
  },
--minepack-poison
	{
    type = "ammo",
    name = "minepack-poison",
    icon = "__Advanced-Tanks__/graphics/icons/mine-pack-poison.png",
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "tank-mine-ammo",
      target_type = "direction",
      source_effects =
      {
        type = "create-entity",
        entity_name = "explosion-gunshot"
      },
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "tank-mine-projectile-poison",
          starting_speed = 1,
          direction_deviation = 0.1,
          range_deviation = 0.1,
          max_range = 50
        }
      },
    },
    magazine_size = 10,
    subgroup = "tank-ammo",
    order = "a[tank-ammo]",
    stack_size = 10
  },
--rocketpack
  {
    type = "ammo",
    name = "rocketpack",
    icon = "__Advanced-Tanks__/graphics/icons/rocket-pack.png",
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "tank-rocket-ammo",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "tank-rocket",
          starting_speed = 0.2,
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-gunshot"
          }
        }
      }
    },
    magazine_size = 5,
	subgroup = "tank-ammo",
    order = "a[tank-ammo]",
    stack_size = 100
  },
  
  --cannon-shell-2
  {
    type = "ammo",
    name = "cannon-shell-2",
    icon = "__Advanced-Tanks__/graphics/icons/tank-ammo-shell2.png",
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "cannon-shell",
      target_type = "direction",
      source_effects =
      {
        type = "create-entity",
        entity_name = "explosion-gunshot"
      },
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "cannon-projectile",
          starting_speed = 1.5,
          direction_deviation = 0.05,
          range_deviation = 0.05,
          max_range = 50
        }
      },
    },
    subgroup = "tank-ammo",
    order = "a[tank-ammo]",
    stack_size = 500
  },
--tank-wmd-ammo
  {
    type = "ammo",
    name = "tank-wmd-ammo",
    icon = "__Advanced-Tanks__/graphics/icons/tank-ammo-wmd.png",
    flags = {"goes-to-main-inventory"},
    ammo_type =
    {
      category = "tank-wmd-ammo",
      target_type = "direction",
      source_effects =
      {
        type = "create-entity",
        entity_name = "explosion-gunshot"
      },
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "wmd-projectile",
          starting_speed = 1.5,
          direction_deviation = 0.05,
          range_deviation = 0.05,
          max_range = 1250
        }
      },
    },
    subgroup = "tank-ammo",
    order = "a[tank-ammo]",
    stack_size = 500
  },
 }
 )