--Explosive
function explosivesmall(data)
  return
  {
    type = "projectile",
    ammo_category = "explosive-rocket",
    cooldown = data.cooldown,
    range = data.range,
    projectile_creation_distance = 0.5,
    damage_modifier = data.damage_modifier,
    warmup = 5,
    ammo_type =
    {
      category = "biological",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "explosive-rocket",
          starting_speed = 0.1,
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-hit"
          }
        }
      }
    },
    sound = make_spitter_roars(data.roarvolume),
    animation = biterattackanimation(smallbitterscale, explosive_biter_tint1, explosive_biter_tint2),
  }
end

function explosivemedium(data)
  return
  {
    type = "projectile",
    ammo_category = "explosive-rocket",
    cooldown = data.cooldown,
    range = data.range,
    projectile_creation_distance = 0.5,
    damage_modifier = data.damage_modifier,
    warmup = 5,
    ammo_type =
    {
      category = "biological",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "explosive-rocket",
          starting_speed = 0.1,
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-hit"
          }
        }
      }
    },
    sound = make_spitter_roars(data.roarvolume),
    animation = biterattackanimation(mediumbitterscale, explosive_biter_tint1, explosive_biter_tint2),
  }
end

function explosivebig(data)
  return
  {
    type = "projectile",
    ammo_category = "explosive-rocket",
    cooldown = data.cooldown,
    range = data.range,
    projectile_creation_distance = 0.5,
    damage_modifier = data.damage_modifier,
    warmup = 5,
    ammo_type =
    {
      category = "biological",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "explosive-rocket",
          starting_speed = 0.1,
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-hit"
          }
        }
      }
    },
    sound = make_spitter_roars(data.roarvolume),
    animation = biterattackanimation(bigbitterscale, explosive_biter_tint1, explosive_biter_tint2),
  }
end

--Flamer
data:extend({
  {
    type = "flame-thrower-explosion",
    name = "flame-thrower-bicho",
    flags = {"not-on-map"},
    animation_speed = 1,
    animations =
    {
      {
        filename = "__5dim_battlefield__/graphics/icon/flame-thrower-bicho.png",
        priority = "extra-high",
        width = 64,
        height = 64,
        frame_count = 64,
        line_length = 8
      }
    },
    light = {intensity = 0.2, size = 20},
    slow_down_factor = 1,
    smoke = "smoke-fast",
    smoke_count = 1,
    smoke_slow_down_factor = 0.95,
    damage = {amount = 0.25, type = "acid"}
  },
})
  
function flamersmall(data)
  return
  {
    type = "projectile",
    ammo_category = "flame-thrower-ammo",
    cooldown = data.cooldown,
    range = data.range,
    projectile_creation_distance = 1.5,
    damage_modifier = data.damage_modifier,
    warmup = 1,
    ammo_type =
    {
      category = "biological",
      action =
      {
        type = "direct",
        action_delivery =
        {
			type = "flame-thrower",
            explosion = "flame-thrower-bicho",
            direction_deviation = 0.07,
            speed_deviation = 0.1,
            starting_frame_deviation = 0.07,
            projectile_starting_speed = 0.2,
            starting_distance = 0.6,
        }
      }
    },
    sound = make_spitter_roars(data.roarvolume),
    animation = spitterattackanimation(smallspitterscale, firespittertint),
  }
end

function flamermedium(data)
  return
  {
    type = "projectile",
    ammo_category = "flame-thrower-ammo",
    cooldown = data.cooldown,
    range = data.range,
    projectile_creation_distance = 1.5,
    damage_modifier = data.damage_modifier,
    warmup = 1,
    ammo_type =
    {
      category = "biological",
      action =
      {
        type = "direct",
        action_delivery =
        {
			type = "flame-thrower",
            explosion = "flame-thrower-bicho",
            direction_deviation = 0.07,
            speed_deviation = 0.1,
            starting_frame_deviation = 0.07,
            projectile_starting_speed = 0.2,
            starting_distance = 0.6,
        }
      }
    },
    sound = make_spitter_roars(data.roarvolume),
    animation = spitterattackanimation(mediumspitterscale, firespittertint),
  }
end

function flamerbig(data)
  return
  {
    type = "projectile",
    ammo_category = "flame-thrower-ammo",
    cooldown = data.cooldown,
    range = data.range,
    projectile_creation_distance = 1.5,
    damage_modifier = data.damage_modifier,
    warmup = 1,
    ammo_type =
    {
      category = "biological",
      action =
      {
        type = "direct",
        action_delivery =
        {
            type = "flame-thrower",
            explosion = "flame-thrower-bicho",
            direction_deviation = 0.07,
            speed_deviation = 0.1,
            starting_frame_deviation = 0.07,
            projectile_starting_speed = 0.2,
            starting_distance = 0.6,
        }
      }
    },
    sound = make_spitter_roars(data.roarvolume),
    animation = spitterattackanimation(bigspitterscale, firespittertint),
  }
end

--Rocket
function rocketlaunchersmall(data)
  return
  {
    type = "projectile",
    ammo_category = "explosive-rocket",
    cooldown = data.cooldown,
    range = data.range,
    projectile_creation_distance = 1.5,
    damage_modifier = data.damage_modifier,
    warmup = 50,
    ammo_type =
    {
      category = "biological",
      action =
      {
             type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "acid-projectile-purple",
          starting_speed = 0.1,
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-hit"
          }
        }
      }
    },
    sound = make_spitter_roars(data.roarvolume),
    animation = biterattackanimation(smallspitterscale, rocketspittertint),
  }
end

function rocketlaunchermedium(data)
  return
  {
    type = "projectile",
    ammo_category = "explosive-rocket",
    cooldown = data.cooldown,
    range = data.range,
    projectile_creation_distance = 1.5,
    damage_modifier = data.damage_modifier,
    warmup = 50,
    ammo_type =
    {
      category = "biological",
      action =
      {
             type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "acid-projectile-purple",
          starting_speed = 0.1,
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-hit"
          }
        }
      }
    },
    sound = make_spitter_roars(data.roarvolume),
    animation = biterattackanimation(mediumspitterscale, rocketspittertint),
  }
end

function rocketlauncherbig(data)
  return
  {
    type = "projectile",
    ammo_category = "explosive-rocket",
    cooldown = data.cooldown,
    range = data.range,
    projectile_creation_distance = 1.5,
    damage_modifier = data.damage_modifier,
    warmup = 50,
    ammo_type =
    {
      category = "biological",
      action =
      {
             type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "acid-projectile-purple",
          starting_speed = 0.1,
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-hit"
          }
        }
      }
    },
    sound = make_spitter_roars(data.roarvolume),
    animation = biterattackanimation(bigspitterscale, rocketspittertint),
  }
end

--Other