require("util")
require("new_class")
require("output")

minTicksBetweenAlerts = 600
global.ticks = global.ticks or {}	
	
function On_Init()
	for i, force in pairs(game.forces) do
		global.ticks[force.name] = game.tick + minTicksBetweenAlerts		
	end
end

script.on_event(defines.events.on_forces_merging, function(event)
	if global.ticks[event.source.name] then
		global.ticks[event.source.name] = nil
	end
end)

script.on_event(defines.events.on_player_created, function(event)
	local player = game.players[event.player_index]
	--if (playerJoinedGameAlert == false) or (player.force.technologies["alert-systems"].researched == false) then
		--return
	--end	
	global.ticks[player.force.name] = event.tick + minTicksBetweenAlerts	
end)



on_built_entity = function (event)
	if is_valid(event.created_entity) and event.created_entity.name == "alert-combinator" then				
		if global.lamps == nil then 
			global.lamps = {} 
		end
		
		lamp = {}						
		lamp.alertMessage = ""
		lamp.alert_state = {}
		lamp.player = game.players[event.player_index]
		lamp.position = event.created_entity.position
		lamp.alert_lamp = event.created_entity
				
		lamp.last_condition_state = false
		lamp.condition_state = false
		
		player = lamp.player
		surface = player.surface
		lamp.output = output:new(player.surface.create_entity{name = "constant-combinator-trans_alert", position = event.created_entity.position, force=player.force})
		lamp.output.entity.connect_neighbour{ wire=defines.wire_type.red, target_entity=lamp.alert_lamp}
		lamp.output.entity.connect_neighbour{ wire=defines.wire_type.green, target_entity=lamp.alert_lamp}

		--defines.circuit_connector.red or defines.circuit_connector.green
		table.insert(global.lamps,lamp)
	end
	
end


function refreshAlertListForPlayer(player, toggle)	
	local show = (not toggle and player.gui.left["alert_list"] ~= nil) or (player.gui.left["alert_list"] == nil and toggle)
	
	-- First destroy list
	if player.gui.left.alert_list ~= nil then
		player.gui.left.alert_list.destroy()
	end
	
	-- if list should be shown, recreate it
	if show then
		local alert_list = gui_or_new(player.gui.left,"alert_list",{type="frame", name="alert_list", caption="Active Alerts", direction="vertical"})		
		local cnt = 0
		
		for _, lamp in pairs(global.lamps) do						
			if lamp.condition_state == true then
				cnt = cnt + 1
				gui_or_new(alert_list,"alert_".._, {type="label", name="alert_".._, caption=lamp.alertMessage})		
			end			
		end
		if cnt == 0 then
			gui_or_new(alert_list,"alert_empty", {type="label", name="alert_empty", caption="No active alerts!"})		
		end
	end
end

function updateAlertListGui()
	for _,player in pairs(game.players) do
		gui_or_new(player.gui.top,"alert_button",{type="button", name="alert_button", caption="Alerts"})
		refreshAlertListForPlayer(player, false)				
	end
end

has_alerts = false
on_tick = function (event)

	if global.lamps == nil then return end
	
	if event.tick%10==7 then
		for _,player in pairs(game.players) do
			if is_valid(player.opened) and player.opened.name == "alert-combinator" then
				if not player.gui.left.alert_lamp then
					new_gui(player, find_lamp(global.lamps, player.opened))
				end
			elseif player.gui.left.alert_lamp ~= nil then
				player.gui.left.alert_lamp.destroy()
			end
		end
	end
	if event.tick%30==23 then
		has_alerts = false
		to_delete = {}
		updateGui = false
		for i,lamp in ipairs(global.lamps) do
			if not is_valid(lamp.alert_lamp) then
				table.insert(to_delete,i)
			else
				update_condition_state(lamp)
				has_alerts = has_alerts or lamp.condition_state
				if lamp.condition_state ~= lamp.last_condition_state then
					-- todo: liste aktualisieren
					updateGui = true
					
					if lamp.condition_state then						
						run_command(lamp)					
					end
				end
				lamp.last_condition_state = lamp.condition_state
			end
		end
		for i,j in ipairs(to_delete) do
			temp_lamp = global.lamps[j-i+1]
			if temp_lamp.output and is_valid(temp_lamp.output.entity) then
				temp_lamp.output.entity.destroy()
			end
			if is_valid(temp_lamp.chest) then
				temp_lamp.chest.destroy()
			end
			table.remove(global.lamps,j-i+1)
		end
	end
	
	for _,player in pairs(game.players) do
		if event.tick%60==0 then
			local gui_main_button = gui_or_new(player.gui.top,"alert_button",{type="button", name="alert_button", caption="Alerts"})	
			if has_alerts then
				gui_main_button.caption = "ALERTS"
			else
				gui_main_button.caption = "Alerts"
			end
		elseif event.tick%60==30 and has_alerts then
			local gui_main_button = gui_or_new(player.gui.top,"alert_button",{type="button", name="alert_button", caption="Alerts"})	
			gui_main_button.caption = " ALERTS !!!!!!!!!!!!!!!!!!!!"
		end
	end
	
	if updateGui then
		updateAlertListGui()
	end
end

on_gui_click = function (event)
	player = game.players[event.player_index]
	element = event.element
	
	if element.name == "alert_save" then
		local entity
		if is_valid(player.opened) and player.opened.name == "alert-combinator" then
			entity = player.opened
		else
			return
		end
		
	
		lamp = find_lamp(global.lamps,entity)
		update_lamp(player.gui.left.alert_lamp,lamp)
		lamp.last_condition_state = false
		--debug_log("Arrr " .. lamp.alertMessage)
		--lamp = find_lamp(global.lamps,entity)
		--debug_log("Arrasdasdasdr " .. lamp.alertMessage)
		--update_gui(player.gui.left.alert_lamp,lamp)	
	
	elseif element.name == "alert_button" then	
		refreshAlertListForPlayer(player, true)
	end
end 

on_init = function(event)
On_Init()
	if global.lamps ~= nil then
		for _,lamp in pairs(global.lamps) do
			lamp.output = output:new(lamp.output.entity)
		end
	end	
end

script.on_event(defines.events.on_gui_click, on_gui_click)

script.on_event(defines.events.on_tick, on_tick)

script.on_init(on_init)
script.on_configuration_changed(on_init)

script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)


function update_condition_state(lamp)
	lamp.condition_state = get_condition(lamp.alert_lamp,1)
end

local function compare_condition(val1, val2, comparator)
  if comparator == "<" then
    return (val1 < val2)
  elseif comparator == "=" then
    return (val1 == val2)
  else
    return (val1 > val2)  
  end
end

local function get_logistic_condition_state(entity,condition) 
	local signal = condition.condition.first_signal	
	if signal == nil or signal.name == nil then return(nil)	end
	
-- game.players[1].print( "cond=("  .. signal.name .. ")" )
	
	local network = entity.logistic_network
	
	if network == nil then return(nil) end
	
	local val = network.get_item_count(signal.name)
  
	local signal2 = condition.condition.second_signal	
  
  local comp_val = 0
  
  if (signal2 == nil or signal2.name == nil) then
    comp_val = condition.condition.constant
  else
    comp_val = network.get_item_count(signal2.name)
  end
  
  local result = false

  result = compare_condition(val,comp_val,condition.condition.comparator)
  
--  game.players[1].print( comp_val )
  
  return result
end

local function get_signal_value(network_r,network_g,signal)
  local result = 0
  if (network_r ~= nil) then result = network_r.get_signal(signal) end
  if (network_g ~= nil) then result = result + network_g.get_signal(signal) end
  return result  
end

local function get_signals(network_r,network_g)
  local result = {}
  local sign_id = nil
  if network_r ~= nil then 
  	for _,signal in pairs(network_r.signals) do
      result[signal.signal.name] = signal.count
    end
  end  
  if network_r ~= nil then 
  	for _,signal in pairs(network_g.signals) do
      if (result[signal.signal.name] == nil) then 
        result[signal.signal.name] = signal.count
      else
        result[signal.signal.name] = result[signal.signal.name] + signal.count
      end
    end
  end
  
  return result  
end

local function get_circuit_condition_state(entity,condition) 
	local signal = condition.condition.first_signal	
	if signal == nil or signal.name == nil then return(nil)	end
	
--	game.players[1].print( "cond=("  .. signal.name .. ")" )
	
	local network_r = entity.get_circuit_network(defines.wire_type.red)
	
    local network_g = entity.get_circuit_network(defines.wire_type.green)
	
	if network_g == nil and network_r == nil then return(nil) end
	
	local val = get_signal_value(network_r,network_g, signal)
  
	local signal2 = condition.condition.second_signal	
  
  local comp_val = 0
  
  if (signal2 == nil or signal2.name == nil) then
    comp_val = condition.condition.constant
  else
    comp_val = get_signal_value(network_r,network_g,signal2)
  end
  
  local result = false

  if (signal.name == "signal-everything") then
    signals = get_signals(network_g,network_r);
  
    result = true
		for signal_name,signal_count in pairs(signals) do
      if compare_condition(signal_count,comp_val,condition.condition.comparator) == false then
        result = false
        break
      end
    end
    
  elseif (signal.name == "signal-anything") then
    signals = get_signals(network_g,network_r);
		for signal_name,signal_count in pairs(signals) do
      if compare_condition(signal_count,comp_val,condition.condition.comparator) == true then
        result = true
        break
      end
    end
  else
    result = compare_condition(val,comp_val,condition.condition.comparator)
  end  
  
--  game.players[1].print( comp_val )
  
  return result
end

local function get_condition_state(entity)
	local behavior = entity.get_control_behavior()
	if behavior == nil then	return(nil)	end
	
	local condition = behavior.circuit_condition
	if condition == nil then
    return(nil) 
  end

  local result = nil

  result = get_circuit_condition_state(entity,condition)
  
  if (result ~= false and behavior.connect_to_logistic_network) then
	  condition = behavior.logistic_condition
  	if condition ~= nil then
      result = get_logistic_condition_state(entity,condition)  
    end
  end
  
  return result
end

function get_condition(alert_lamp,colour)
--	return alert_lamp.get_circuit_condition(colour).fulfilled
  return get_condition_state(alert_lamp)
end

script_headder = "for _,player in pairs(game.players) do player.print(\""
script_footer = "\") end"
function run_command(lamp) -- player.print("Hello World!")
	if lamp.alertMessage ~= nil and lamp.alertMessage ~= "" then		
		
				
		--if unitLostAlert then
			--playSoundForForce("alarm1", event.entity.force)
			--global.ticks[event.entity.force.name] = event.tick + minTicksBetweenAlerts
		--end
		
	
		
		debug_log("Run " .. lamp.alertMessage, 3)
		global.variable = get_variable(lamp)

		funct, err = loadstring(script_headder ..  lamp.alertMessage .. script_footer)		
		if err then
			lamp.player.print(err)
		else
			empty,err = pcall(funct)
			if err then 
				lamp.player.print(err)
			end
		end
		global.variable = nil
	end
end


function banner(text,position,color,player)
	player.surface.create_entity{name="flying-text-banner_alert", position=position, text="Hello", color=color}
end

function get_variable(lamp)
	variable = {}
	variable.lamp = lamp
	variable.condition = {}
	variable.condition.value = lamp.condition_state
	variable.condition.changed = lamp.condition_state == not lamp.last_condition_state
	variable.alert_state = lamp.alert_state
	global.lamp_global = table_or_new(global.lamp_global)
	variable.global = global.lamp_global
  
  variable.circuit_network_red = lamp.alert_lamp.get_circuit_network(defines.wire_type.red);
  variable.circuit_network_green = lamp.alert_lamp.get_circuit_network(defines.wire_type.green);
  variable.circuit_network_signals = get_signals(variable.circuit_network_red,variable.circuit_network_green);
	return variable
end

function find_lamp(lamps,lampA)
	for _,lampB in pairs(lamps) do
		if is_valid(lampA) and is_valid(lampB.alert_lamp) and lampB.alert_lamp == lampA then
			return lampB
		end
	end
end

function new_gui(player,lamp)
	player_gui = player.gui.left
	gui = gui_or_new(player_gui,"alert_lamp",{type="frame", name="alert_lamp", caption={"msg-window-title"}, direction="vertical" })	
	
	gui_or_new(gui,"label",{type="label", name="label",caption={"msg-checkbox-console"}})
	
	command = gui_or_new(gui,"command",{type="flow", name="command",direction="horizontal"})
	alert_command = gui_or_new(command,"alert_command",{type="textfield", name="alert_command", text=lamp.alertMessage , style="wide_textbox_style_alert"})
	alert_command.text = lamp.alertMessage
	alert_save = gui_or_new(gui,"alert_save",{type="button", name="alert_save", caption={"msg-button-save"}, })
	return gui
end

function update_gui(gui,lamp)
	if gui ~= nil and is_valid(lamp) then
		gui.command.alert_command.text = lamp.alertMessage
	end
end

function update_lamp(gui,lamp)
	if gui ~= nil then		
		lamp.alertMessage = gui.command.alert_command.text
	end
end

function gui_or_new(parent,name,new_element)
	if parent[name] == nil then
		debug_log(name, 3)
		parent.add(new_element)
	end
	
	return parent[name]
end

function table_or_new(table_a)
	if table_a == nil then
		return {}
	else
		return table_a
	end
end
	
function is_valid(entity)
	return (entity ~= nil and entity.valid)
end

function set_debug(value)
	global.debug_level = value
end

function debug_log(message, level)
	if global.debug_level == nil then set_debug(0) end
	if global.debug_level >= level then
		if message == nil then
			 message = "nil"
		elseif message == true then
			message = "true"
		elseif message == false then
			message = "false"
		end
		for _,player in pairs(game.players) do
			player.print(game.tick .. ": " .. message)
		end
	end
end

function playSoundForForce(sound, force)
	if #force.players == 0 then
		return
	end
	for i, player in pairs(force.players) do		
		player.surface.create_entity({name = sound, position = player.position})		
	end
end