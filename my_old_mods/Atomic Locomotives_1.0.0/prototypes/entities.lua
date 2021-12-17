atom_loco = util.table.deepcopy(data.raw["locomotive"]["diesel-locomotive"])
atom_loco.name = "atomic-locomotive"
atom_loco.icon = "__Atomic Locomotives__/graphics/icons/atomic-locomotive.png"
atom_loco.minable.result = "atomic-locomotive"
atom_loco.weight = 4000
atom_loco.max_power = "1200kW"
atom_loco.braking_force = 30
atom_loco.energy_source.fuel_inventory_size = 0
atom_loco.energy_source.smoke = nil
atom_loco.color = { r = 0, g = 0.75, b = 0.5, a = 0.5 }
atom_loco.working_sound.sound.filename = "__base__/sound/idle1.ogg"
atom_loco.working_sound.sound.volume = 1


atom_shuttle = util.table.deepcopy(atom_loco)
atom_shuttle.max_speed = 5.0
atom_shuttle.name = "atomic-shuttle"
atom_shuttle.icon = "__Atomic Locomotives__/graphics/icons/atomic-shuttle.png"
atom_shuttle.minable.result = "atomic-shuttle"
atom_shuttle.weight = 1000
atom_shuttle.max_power = "1000kW"
atom_shuttle.braking_force = 100
atom_shuttle.energy_source.fuel_inventory_size = 0
atom_shuttle.energy_source.smoke = nil
atom_shuttle.color = { r = 0, g = 1.0, b = 0.0, a = 0.5 }
atom_shuttle.working_sound.sound.filename = "__base__/sound/idle1.ogg"
atom_shuttle.working_sound.sound.volume = 1
atom_shuttle.air_resistance = 0.0005
atom_shuttle.reversing_power_modifier = 0.9





data:extend({
  atom_loco,
  atom_shuttle
})