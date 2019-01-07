local keybindused = false

local function onKey(event)
  local player = game.players[event.player_index]
  local entity = player.selected
  keybindused = true
  if entity and entity.valid then
      if entity.name == "switchbutton" then
        player.opened = entity
      end
  end
end

local function onBuilt(event)
  local switchbutton = event.created_entity
  if switchbutton.name == "switchbutton" then
    switchbutton.get_or_create_control_behavior().enabled=false
  end
end

local function onPaste(event)
  local switchbutton = event.destination
  if switchbutton.name == "switchbutton" then
    switchbutton.get_or_create_control_behavior().enabled=false
  end
end

script.on_event(defines.events.on_gui_closed, function(event)
	keybindused = false
end)

script.on_event(defines.events.on_gui_opened, function(event)
  local player = game.players[event.player_index]
  local entity = player.selected

  if entity ~= nil and entity.name == "switchbutton" then
	if keybindused then
		--entity.get_or_create_control_behavior().enabled = false
	else
		local control = entity.get_or_create_control_behavior()
		control.enabled = not control.enabled
		player.opened = nil
	end
  end
end)

script.on_event("switchbutton-keybind", onKey)
script.on_event(defines.events.on_built_entity, onBuilt)
script.on_event(defines.events.on_robot_built_entity, onBuilt)
script.on_event(defines.events.on_entity_settings_pasted,onPaste)
