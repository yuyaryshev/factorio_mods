data:extend (
	{
	--tank-assembly
	{
    type = "assembling-machine",
    name = "tank-assembling-machine",
    icon = "__Advanced-Tanks__/graphics/icons/tank-assembling-machine.png",
    flags = {"placeable-neutral","placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "tank-assembling-machine"},
    max_health = 300,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    resistances = 
    {
      {
        type = "fire",
        percent = 95
      }
    },
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    working_sound =
    {
      sound = {
        {
          filename = "__base__/sound/assembling-machine-t3-1.ogg",
          volume = 0.8
        },
        {
          filename = "__base__/sound/assembling-machine-t3-2.ogg",
          volume = 0.8
        },
      },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5,
    },
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    animation =
    {
      filename = "__Advanced-Tanks__/graphics/entity/tank-assembling-machine/tank-assembling-machine.png",
      priority = "high",
      width = 142,
      height = 113,
      frame_count = 32,
      line_length = 8,
      shift = {0.84, -0.09}
    },
    crafting_categories = {"tank-crafting"},
    crafting_speed = 1.00,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = 0.05 / 3.5
    },
    energy_usage = "250kW",
    ingredient_count = 6,
    module_specification =
    {
      module_slots = 4,
      module_info_icon_shift = {0, 0.5},
      module_info_multi_row_initial_height_modifier = -0.3
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution"}
  },
	--munition maker
	{
    type = "assembling-machine",
    name = "tank-ammo-assembling-machine",
    icon = "__Advanced-Tanks__/graphics/icons/tank-ammo-assembling-machine.png",
    flags = {"placeable-neutral","placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "tank-ammo-assembling-machine"},
    max_health = 150,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    resistances = 
    {
      {
        type = "fire",
        percent = 95
      }
    },
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    working_sound =
    {
      sound = {
        {
          filename = "__base__/sound/assembling-machine-t3-1.ogg",
          volume = 0.8
        },
        {
          filename = "__base__/sound/assembling-machine-t3-2.ogg",
          volume = 0.8
        },
      },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5,
    },
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    --fast_replaceable_group = "assembling-machine",
    animation =
    {
      filename = "__Advanced-Tanks__/graphics/entity/tank-assembling-machine/tank-assembling-machine.png",
      priority = "high",
      width = 142,
      height = 113,
      frame_count = 32,
      line_length = 8,
      shift = {0.84, -0.09}
    },
    crafting_categories = {"tank-ammo-component"},
    crafting_speed = 1.00,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = 0.05 / 3.5
    },
    energy_usage = "175kW",
    ingredient_count = 6,
    module_specification =
    {
      module_slots = 4,
      module_info_icon_shift = {0, 0.5},
      module_info_multi_row_initial_height_modifier = -0.3
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution"}
  },
  
  --entities?
--tank-flame-thrower-fire-stream
    {
    type = "flame-thrower-explosion",
    name = "tank-flame-thrower-explosion",
    flags = {"not-on-map"},
    animation_speed = 1,
    animations =
    {
      {
        filename = "__base__/graphics/entity/flamethrower-fire-stream/flamethrower-explosion.png",
        priority = "extra-high",
        width = 64,
        height = 64,
        frame_count = 64,
		--scale = 4,
        line_length = 8
      }
    },
    light = {intensity = 0.4, size = 16},
    slow_down_factor = 0.98,
    smoke = "smoke-fast",
    smoke_count = 1,
    smoke_slow_down_factor = 0.95,
    damage = {amount = 0.5, type = "fire"}
  },
--massive-scorchmark
{
    type = "corpse",
    name = "massive-scorchmark",
    icon = "__base__/graphics/icons/small-scorchmark.png",
    flags = {"placeable-neutral", "not-on-map", "placeable-off-grid"},
    collision_box = {{-1.5, -1.5}, {1.5, 1.5}},
    collision_mask = {"doodad-layer", "not-colliding-with-itself"},
    selection_box = {{-1, -1}, {1, 1}},
    selectable_in_game = false,
    time_before_removed = 60 * 60 * 10, -- 10 minutes
    final_render_layer = "ground_patch_higher2",
    subgroup = "remnants",
    order="d[remnants]-b[scorchmark]-a[small]",
    animation =
    {
      sheet=
      {
        width = 110,
        height = 90,
		scale = 5,
        frame_count = 1,
        direction_count = 1,
        filename = "__base__/graphics/entity/scorchmark/small-scorchmark.png",
        variation_count = 3
      }
    },
    ground_patch =
    {
      sheet =
      {
        width = 110,
        height = 90,
		scale = 5,
        frame_count = 1,
        direction_count = 1,
        x = 110 * 2,
        filename = "__base__/graphics/entity/scorchmark/small-scorchmark.png",
        variation_count = 3
      }
    },
    ground_patch_higher =
    {
      sheet =
      {
        width = 110,
        height = 90,
		scale = 5,
        frame_count = 1,
        direction_count = 1,
        x = 110,
        filename = "__base__/graphics/entity/scorchmark/small-scorchmark.png",
        variation_count = 3
      }
    }
  },
--land-mine-poison
  {
    type = "land-mine",
    name = "land-mine-poison",
    icon = "__base__/graphics/icons/land-mine.png",
    flags =
    {
      "placeable-player",
      "placeable-enemy",
      "player-creation",
      "placeable-off-grid"
    },
    minable = {mining_time = 1, result = "land-mine"},
    max_health = 15,
    corpse = "small-remnants",
    collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    dying_explosion = "explosion-gunshot",
    picture_safe =
    {
      filename = "__base__/graphics/entity/land-mine/land-mine.png",
      priority = "medium",
      width = 32,
      height = 32
    },
    picture_set =
    {
      filename = "__base__/graphics/entity/land-mine/land-mine-set.png",
      priority = "medium",
      width = 32,
      height = 32
    },
    trigger_radius = 3.5,
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        source_effects =
        {
          {
            type = "nested-result",
            affects_target = true,
            action =
            {
              type = "area",
              perimeter = 6,
              collision_mask = { "player-layer" },
              action_delivery =
              {
                type = "instant",
                target_effects = 
				{
                  type = "damage",
                  damage = { amount = 20, type = "explosion"}
                },
              }
            },
          },
          {
				type = "create-entity",
				entity_name = "poison-cloud"
          },
          {
            type = "damage",
            damage = { amount = 500, type = "explosion"}
          }
        }
      }
    },
  },
--lazer-cloud
  {
    type = "smoke",
    name = "lazer-cloud",
    flags = {"not-on-map"},
    show_when_smoke_off = true,
    animation =
    {
      filename = "__base__/graphics/entity/cloud/cloud-45-frames.png",
      priority = "low",
      width = 256,
      height = 256,
      frame_count = 45,
      animation_speed = 3,
      line_length = 7,
      scale = 3,
    },
    slow_down_factor = 0,
    wind_speed_factor = 0,
    cyclic = true,
    duration = 60 * 7,
    fade_away_duration = 60 * 2,
    spread_duration = 20,
    color = { r = 0.2, g = 0.2, b = 0.9 },
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "nested-result",
          action =
          {
            type = "area",
            perimeter = 11,
            entity_flags = {"breaths-air"},
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                type = "damage",
                damage = { amount = 15, type = "laser"}
              }
            }
          }
        }
      }
    },
    action_frequency = 30
  },

  
}
)