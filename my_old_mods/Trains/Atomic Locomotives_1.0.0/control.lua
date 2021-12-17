LOCO_ENTITY_NAME = "atomic-locomotive"
LOCO_ENERGY = 1200000 / 56.25

function init_global()
  global = global or {}
  global.active_locos = global.active_locos or {}
end

script.on_init(init_global)

function add_loco(loco)
  -- Uncomment the line below to add the unit number to name of newly-placed locomotives
  -- loco.backer_name = loco.backer_name .. " " .. loco.unit_number
  loco.energy = LOCO_ENERGY
  global.active_locos[loco.unit_number] = loco
end

function remove_loco(loco)
  global.active_locos[loco.unit_number] = nil
end

script.on_event(defines.events.on_built_entity, function(event)
  if event.created_entity.name == LOCO_ENTITY_NAME then
    add_loco(event.created_entity)
  end
end)

script.on_event(defines.events.on_preplayer_mined_item, function(event)
  if event.entity.name == LOCO_ENTITY_NAME then
    remove_loco(event.entity)
  end
end)
script.on_event(defines.events.on_robot_pre_mined, function(event)
  if event.entity.name == LOCO_ENTITY_NAME then
    remove_loco(event.entity)
  end
end)
script.on_event(defines.events.on_entity_died, function(event)
  if event.entity.name == LOCO_ENTITY_NAME then
    remove_loco(event.entity)
  end
end)

function update_locos()
  local locos = global.active_locos
  for _,loco in pairs(locos) do
    loco.energy = LOCO_ENERGY
  end
end

script.on_event(defines.events.on_tick, update_locos)