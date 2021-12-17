require("prototypes.atack-parameters")
require("prototypes.scalecolor")
require("prototypes.damage")

data:extend(
{
--Small
  {
    type = "unit",
    name = "5d-small-spiter-fire",
    icon = "__base__/graphics/icons/creeper.png",
    flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air"},
    max_health = healthsmallspitter,
    order = "b-b-a",
    subgroup="enemies",
    healing_per_tick = 0.01,
    collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
    selection_box = {{-0.4, -0.7}, {0.7, 0.4}},
    attack_parameters = flamersmall(
	{
		type = "projectile",
		range=15,
        cooldown=1,
        damage_modifier=firesmalldmg,
        scale=smallspitterscale,
        tint=firespittertint,
		roarvolume=0.7
	}),
    vision_distance = 30,
    movement_speed = 0.2,
    distance_per_frame = 0.1,
    pollution_to_join_attack = 200,
    distraction_cooldown = 300,
    corpse = "5d-small-spiter-fire-corpse",
    dying_explosion = "blood-explosion-small",
    dying_sound =  make_spitter_dying_sounds(1.0),
    working_sound =  make_biter_calls(0.7),
    run_animation = spitterrunanimation(smallspitterscale, firespittertint)
  },
  {
    type = "corpse",
    name = "5d-small-spiter-fire-corpse",
    icon = "__base__/graphics/icons/big-biter-corpse.png",
    selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
    selectable_in_game = false,
    subgroup="corpses",
    order = "c[corpse]-a[bichoA]-a[small]",
    flags = {"placeable-neutral", "placeable-off-grid", "building-direction-8-way", "not-repairable", "not-on-map"},
    dying_speed = 0.04,
    time_before_removed = 15 * 60 * 60,
    final_render_layer = "corpse",
    animation = spitterdyinganimation(smallspitterscale, firespittertint)
  },
--Medium
  {
    type = "unit",
    name = "5d-medium-spiter-fire",
    icon = "__base__/graphics/icons/creeper.png",
    flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air"},
    max_health = healthmediumspitter,
    order = "b-b-a",
    subgroup="enemies",
    healing_per_tick = 0.01,
    collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
    selection_box = {{-0.7, -1.5}, {0.7, 0.3}},
    sticker_box = {{-0.3, -0.5}, {0.3, 0.1}},
    distraction_cooldown = 300,
    attack_parameters = flamermedium(
	{
		type = "projectile",
		range=15,
        cooldown=1,
        damage_modifier=firemediumdmg,
        scale=mediumspitterscale,
        tint=firespittertint,
		roarvolume=0.7
	}),
    vision_distance = 30,
    movement_speed = 0.185,
    distance_per_frame = 0.15,
    -- in pu
    pollution_to_join_attack = 1000,
    corpse = "5d-medium-spiter-fire-corpse",
    dying_explosion = "blood-explosion-small",
    dying_sound =  make_spitter_dying_sounds(1.0),
    working_sound =  make_biter_calls(0.7),
    run_animation = spitterrunanimation(mediumspitterscale, firespittertint)
  },
  {
    type = "corpse",
    name = "5d-medium-spiter-fire-corpse",
    icon = "__base__/graphics/icons/big-biter-corpse.png",
    selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
    selectable_in_game = false,
    subgroup="corpses",
    order = "c[corpse]-a[bichoA]-a[medium]",
    flags = {"placeable-neutral", "placeable-off-grid", "building-direction-8-way", "not-repairable", "not-on-map"},
    dying_speed = 0.04,
    time_before_removed = 15 * 60 * 60,
    final_render_layer = "corpse",
    animation = spitterdyinganimation(mediumspitterscale, firespittertint)
  },
--Big
  {
    type = "unit",
    name = "5d-big-spiter-fire",
    icon = "__base__/graphics/icons/creeper.png",
    flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air"},
    max_health = healthbigspitter,
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
    attack_parameters = flamerbig(
	{
		type = "projectile",
		range=15,
        cooldown=1,
        damage_modifier=firebigdmg,
        scale=bigspitterscale,
        tint=firespittertint,
		roarvolume=0.7
	}),
    vision_distance = 30,
    movement_speed = 0.17,
    distance_per_frame = 0.2,
    -- in pu
    pollution_to_join_attack = 4000,
    corpse = "5d-big-spiter-fire-corpse",
    dying_explosion = "blood-explosion-small",
    dying_sound =  make_spitter_dying_sounds(1.0),
    working_sound =  make_biter_calls(0.7),
    run_animation = spitterrunanimation(bigspitterscale, firespittertint)
  },
  {
    type = "corpse",
    name = "5d-big-spiter-fire-corpse",
    icon = "__base__/graphics/icons/big-biter-corpse.png",
    selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
    selectable_in_game = false,
    subgroup="corpses",
    order = "c[corpse]-a[bichoA]-a[big]",
    flags = {"placeable-neutral", "placeable-off-grid", "building-direction-8-way", "not-repairable", "not-on-map"},
    dying_speed = 0.04,
    time_before_removed = 15 * 60 * 60,
    final_render_layer = "corpse",
    animation = spitterdyinganimation(bigspitterscale, firespittertint)
  },
})
