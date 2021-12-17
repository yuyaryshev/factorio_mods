require("prototypes.atack-parameters")
require("prototypes.scalecolor")
require("prototypes.damage")

data:extend(
{
--Small
  {
    type = "unit",
    name = "5d-small-biter-explosive",
    icon = "__base__/graphics/icons/small-biter.png",
    flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air"},
    max_health = healthsmallbitter,
    order = "b-b-a",
    subgroup="enemies",
    healing_per_tick = 0.01,
    collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
    selection_box = {{-0.4, -0.7}, {0.7, 0.4}},
    attack_parameters = explosivesmall(
	{
		type = "projectile",
		range=1,
        cooldown=1,
        damage_modifier=explosivesmalldmg,
        scale=smallbitterscale,
        tint=bichoA_tint1,
		roarvolume=0.7
	}),
    vision_distance = 30,
    movement_speed = 0.4,
    distance_per_frame = 0.1,
    pollution_to_join_attack = 200,
    distraction_cooldown = 300,
    corpse = "5d-small-biter-explosive-corpse",
    dying_explosion = "blood-explosion-small",
    dying_sound =  make_biter_dying_sounds(1.0),
    working_sound =  make_biter_calls(0.7),
    run_animation = biterrunanimation(smallbitterscale, explosive_biter_tint1, explosive_biter_tint2)
  },
  {
    type = "corpse",
    name = "5d-small-biter-explosive-corpse",
    icon = "__base__/graphics/icons/small-biter-corpse.png",
    selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
    selectable_in_game = false,
    subgroup="corpses",
    order = "c[corpse]-a[bichoA]-a[small]",
    flags = {"placeable-neutral", "placeable-off-grid", "building-direction-8-way", "not-repairable", "not-on-map"},
    dying_speed = 0.04,
    time_before_removed = 15 * 60 * 60,
    final_render_layer = "corpse",
    animation = biterdieanimation(smallbitterscale, explosive_biter_tint1, explosive_biter_tint2)
  },
--Medium
  {
    type = "unit",
    name = "5d-medium-biter-explosive",
    icon = "__base__/graphics/icons/medium-biter.png",
    flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air"},
    max_health = healthmediumbitter,
    order = "b-b-a",
    subgroup="enemies",
    healing_per_tick = 0.01,
    collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
    selection_box = {{-0.7, -1.5}, {0.7, 0.3}},
    sticker_box = {{-0.3, -0.5}, {0.3, 0.1}},
    distraction_cooldown = 300,
    attack_parameters = explosivemedium(
	{
		type = "projectile",
		range=1,
        cooldown=1,
        damage_modifier=explosivemediumdmg,
        scale=mediumbitterscale,
        tint=bichoA_tint1,
		roarvolume=0.7
	}),
    vision_distance = 30,
    movement_speed = 0.185,
    distance_per_frame = 0.15,
    -- in pu
    pollution_to_join_attack = 1000,
    corpse = "5d-medium-biter-explosive-corpse",
    dying_explosion = "blood-explosion-small",
    dying_sound =  make_biter_dying_sounds(1.0),
    working_sound =  make_biter_calls(0.7),
    run_animation = biterrunanimation(mediumbitterscale, explosive_biter_tint1, explosive_biter_tint2)
  },
  {
    type = "corpse",
    name = "5d-medium-biter-explosive-corpse",
    icon = "__base__/graphics/icons/medium-biter-corpse.png",
    selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
    selectable_in_game = false,
    subgroup="corpses",
    order = "c[corpse]-a[bichoA]-a[medium]",
    flags = {"placeable-neutral", "placeable-off-grid", "building-direction-8-way", "not-repairable", "not-on-map"},
    dying_speed = 0.04,
    time_before_removed = 15 * 60 * 60,
    final_render_layer = "corpse",
    animation = biterdieanimation(mediumbitterscale, explosive_biter_tint1, explosive_biter_tint2)
  },
--Big
  {
    type = "unit",
    name = "5d-big-biter-explosive",
    icon = "__base__/graphics/icons/big-biter.png",
    flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air"},
    max_health = healthbigbitter,
    order = "b-b-a",
    subgroup="enemies",
    resistances =
    {
      {
        type = "physical",
        decrease = 8,
      },
      {
        type = "explosion",
        percent = 10
      }
    },
    spawning_time_modifier = 2,
    healing_per_tick = 0.02,
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.7, -1.5}, {0.7, 0.3}},
    sticker_box = {{-0.6, -0.8}, {0.6, 0}},
    distraction_cooldown = 300,
    attack_parameters = explosivebig(
	{
		type = "projectile",
		range=1,
        cooldown=1,
        damage_modifier=explosivebigdmg,
        scale=bigbitterscale,
        tint=bichoA_tint1,
		roarvolume=0.7
	}),
    vision_distance = 30,
    movement_speed = 0.17,
    distance_per_frame = 0.2,
    -- in pu
    pollution_to_join_attack = 4000,
    corpse = "5d-big-biter-explosive-corpse",
    dying_explosion = "blood-explosion-small",
    dying_sound =  make_biter_dying_sounds(1.0),
    working_sound =  make_biter_calls(0.7),
    run_animation = biterrunanimation(bigbitterscale, explosive_biter_tint1, explosive_biter_tint2)
  },
  {
    type = "corpse",
    name = "5d-big-biter-explosive-corpse",
    icon = "__base__/graphics/icons/big-biter-corpse.png",
    selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
    selectable_in_game = false,
    subgroup="corpses",
    order = "c[corpse]-a[bichoA]-a[big]",
    flags = {"placeable-neutral", "placeable-off-grid", "building-direction-8-way", "not-repairable", "not-on-map"},
    dying_speed = 0.04,
    time_before_removed = 15 * 60 * 60,
    final_render_layer = "corpse",
    animation = biterdieanimation(bigbitterscale, explosive_biter_tint1, explosive_biter_tint2)
  },
})
