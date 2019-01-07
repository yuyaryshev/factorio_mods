-- Author : Lord Odin, based on skan-radio mod, simplified and added channels with text names
------------------------------------------------------------------------------------------------------------------------------
require "util"
require "signal_processing"

local updatePeriod = 100
local mod_version = "1.0.5"
local transmittersRequirePower = false
local receiversRequirePower = false
local fullResetCount = 0

local init_done = false

------------------------------------------------------------------------------------------------------------------------------
local function channelSignal(channel)
	return {index = 1, count = channel or 0, signal = {type = "virtual", name = "lo-wireless-channel"}}
end
------------------------------------------------------------------------------------------------------------------------------
function destroy_remote_control()
	if global.constant_remote_entity and global.constant_remote_entity.valid then
		global.constant_remote_entity_target.entity.get_control_behavior().parameters = global.constant_remote_entity.get_control_behavior().parameters
		global.constant_remote_entity.destroy()
		global.constant_remote_entity = nil
		global.constant_remote_entity_target = nil
	end
end
------------------------------------------------------------------------------------------------------------------------------
local function getKey(entity)
	return "los_x" .. entity.position.x .. "y".. entity.position.y
end
------------------------------------------------------------------------------------------------------------------------------
local function isRadioDevice(entity)
	return entity ~= nil and (entity.name == "lo-radio-transmitter" or entity.name == "lo-radio-receiver" or entity.name == "lo-radio-constant")
end
------------------------------------------------------------------------------------------------------------------------------
local function isTransmitter(entity)
	return entity ~= nil and (entity.name == "lo-radio-transmitter")
end
------------------------------------------------------------------------------------------------------------------------------
local function isConstant(entity)
	return entity ~= nil and (entity.name == "lo-radio-constant")
end
------------------------------------------------------------------------------------------------------------------------------
local function isReceiver(entity)
	return entity ~= nil and (entity.name == "lo-radio-receiver")
end
------------------------------------------------------------------------------------------------------------------------------
local wire_colors =
{
    defines.wire_type.red,
    defines.wire_type.green
}
------------------------------------------------------------------------------------------------------------------------------
local function debugPrint(string)
    local p = game.players[1]
    p.print(string)
end
------------------------------------------------------------------------------------------------------------------------------
local function init_global()
	init_done = true
	
	for _, force in pairs(game.forces) do
		if force.technologies["lo-radio-telemetry"].researched then
			force.recipes["lo-radio-constant"].enabled = true
		end
	end
	
    if not global.lo_wireless_signals then
        global.lo_wireless_signals = {devices = {}}
    end
	
    if not global.lo_wireless_signals.constant_emmiters then
		global.lo_wireless_signals.constant_emmiters = {}
    end
	
	
	for index, _ in pairs(game.players) do
		if game.players[index].gui.top.wireless_lite == nil then
			gui_element(game.players[index].gui.top, {type="button", name="wireless_lite", caption="Wifi"})
		end
	end	
end
------------------------------------------------------------------------------------------------------------------------------
local function onInit()
    init_global()
end
------------------------------------------------------------------------------------------------------------------------------
local function onConfigChange(data)
    if data.mod_changes and data.mod_changes["lo-wireless-signals"] then
        if not data.mod_changes["lo-wireless-signals"].old_version then -- mod added to existing save
            init_global()
        end
    end
end
------------------------------------------------------------------------------------------------------------------------------
local function resetInvalidEntity(stored_entity, entityType)
-- workaround for game incorrectly thinking devices are invalid on load
if stored_entity.position ~= nil then
	actual_entity = game.surfaces["nauvis"].find_entity(entityType, stored_entity.position)
	if actual_entity and actual_entity.valid then
		stored_entity.entity = actual_entity
		--debugPrint("Invalid entity found and recovered")
	end
end
end
------------------------------------------------------------------------------------------------------------------------------
local function setDeviceChannel(device, channel)
	channel = channel or 0
	local entity = device.entity
	if isTransmitter(entity) then
		device.entity.get_control_behavior().circuit_condition = { condition = { comparator = ">", first_signal = {type = "virtual", name = "lo-wireless-channel"}, constant = channel } }
	elseif isConstant(entity) or isReceiver(entity) then
		if not device.entity.get_control_behavior().parameters.parameters then
			device.entity.get_control_behavior().parameters = {parameters = {channelSignal(1)}}
		else
			local tmp = device.entity.get_control_behavior().parameters
			tmp.parameters[1] = channelSignal(channel)
			device.entity.get_control_behavior().parameters = tmp
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------
local function deviceChannel(device)
	local r = 0
	if isTransmitter(device.entity) then
		r = device.entity.get_control_behavior().circuit_condition.constant or 0
	elseif isConstant(device.entity) then --or isReceiver(device.entity) then
		local p = device.entity.get_control_behavior().parameters.parameters
		r = p and #p and p[1].count or 0
	elseif isReceiver(device.entity) then
		local p = device.entity.get_control_behavior().parameters.parameters
		r = p and #p and p[1].count or 0
	end
	
	if r == 0 then
		setDeviceChannel(device,1)
		return 1
	end
	
	return r
end
------------------------------------------------------------------------------------------------------------------------------
local function storeDevice(new_entity)
	local data = {
		  position			= new_entity.position
		, entity			= new_entity
		}
	if isConstant(new_entity) then
		global.lo_wireless_signals.constant_emmiters[getKey(new_entity)] = new_entity	
	end
	global.lo_wireless_signals.devices[getKey(new_entity)] = data
	return data
end
------------------------------------------------------------------------------------------------------------------------------
function gui_element(parent, new_element)
	if parent[new_element.name] == nil then
		parent.add(new_element)
	end
	return parent[new_element.name]
end
------------------------------------------------------------------------------------------------------------------------------
local function onTick(event)
    if ((event.tick % updatePeriod) ~= 0) then return end
	if not init_done then
		init_global()
	end
	
	if global.constant_remote_entity then
		global.constant_remote_entity_target.entity.get_control_behavior().parameters = global.constant_remote_entity.get_control_behavior().parameters
		if player.opened ~= global.constant_remote_entity then
			destroy_remote_control()
		end
	end
	
	-- Process devices: transmitters and recievers
	-- create new temp table channels
	-- stage == 0 : iterate only transmitters, write their signals to corresponding key in channels temp table
	-- stage == 1 : iterate only receivers, read signals from corresponding key in channels temp table

	local channels = {}	
	
	for stage = 0,1 do
			for k, device in pairs(global.lo_wireless_signals.devices) do
--	print_signals(channels, "S1 TTT")
				if device.entity.valid then
					local channel = deviceChannel(device)
					if channels[channel] == nil then
						channels[channel] = {}
					end
--	print_signals(channels, "S2 TTT")
					
					if not transmittersRequirePower or device.entity.energy > 0 then 
						if stage == 0 then
							if isConstant(device.entity) then
								local c_signals = device.entity.get_control_behavior().parameters.parameters
								--print_signals(c_signals,"c_signals")
								table.remove(c_signals, 1)
--								c_signals[1].count = 0
								merge_signals(channels[channel], c_signals)
							end
						
						
--	print_signals(channels, "S3 TTT")
							if isTransmitter(device.entity) then
--	print_signals(channels, "S4 TTT")
								
								for i = 1, #wire_colors do -- check both red and green wires
									local c = device.entity.get_circuit_network(wire_colors[i])
--	print_signals(channels, "S5 TTT")
									if c then
										merge_signals(channels[channel], c.signals)
--									print_signals(channels[channel], "Transmitter")
										
--									debugPrint("Transmitter channel = '"..channel.."'")


--									merge_signals(active_signals, c.signals)
--									print_signals(active_signals, "Transmitter")
									end -- if c then
--	print_signals(channels, "T1 TTT")
								end -- for i = 1, #wire_colors do
--	print_signals(channels, "T2 TTT")
							end -- if isTransmitter(entity)
--	print_signals(channels, "T3 TTT")
						else -- i.e.   stage != 0
							if isReceiver(device.entity) then
--							debugPrint("Receiver channel = '"..channel.."'")
--  print_signals(channels, "Receiver")
								formatted = format_signals(channels[channel] or {}, {signal = {type = "virtual", name = "lo-wireless-channel"}, count = channel} )
								if #formatted > 0 then
									device.entity.get_control_behavior().parameters = { parameters = formatted }
								else
									device.entity.get_control_behavior().parameters = nil -- there are no incoming signals, so zero out the output
								end
							end -- if isReceiver(entity)
						end -- if stage
--	print_signals(channels, "T4 TTT")
				end -- if not transmittersRequirePower or device.entity.energy > 0 and device
				else -- !device.entity.valid
					resetInvalidEntity(device)
				end -- if device.entity.valid
--		print_signals(channels, "T5 TTT")
			end -- for k, device in pairs(global.lo_wireless_signals.devices)
--	print_signals(channels, "T6 TTT")
	end --for stage = 0,1
--	print_signals(channels, "T7 TTT")
end
------------------------------------------------------------------------------------------------------------------------------
local function onPlaceEntity(event)
    local entity = event.created_entity
	local device = nil
    if isTransmitter(entity) then
        entity.get_or_create_control_behavior().connect_to_logistic_network = false -- keep it separate from the logistic network
		local device = storeDevice(entity)
		setDeviceChannel(device, deviceChannel(device))

    elseif isReceiver(entity) or isConstant(entity) then
		local device = storeDevice(entity)
		setDeviceChannel(device, deviceChannel(device))		
    end
end
------------------------------------------------------------------------------------------------------------------------------
local function onRemoveEntity(event)
    local entity = event.entity
    if isRadioDevice(entity) then
		global.lo_wireless_signals.devices[getKey(entity)] = nil
		global.lo_wireless_signals.constant_emmiters[getKey(entity)] = nil
    end
end
------------------------------------------------------------------------------------------------------------------------------
function strSplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t = {} ; 
		local i = 1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end
------------------------------------------------------------------------------------------------------------------------------
onGuiClick = function (event)
	player = game.players[event.player_index]
	element = event.element

	-- Constant transmitter
	if element.name == "wireless_lite" then
		if player.gui.left.wireless_constant_window ~= nil then
			player.gui.left.wireless_constant_window.destroy()
		else 
			wireless_constant_window = gui_element(player.gui.left, {type="frame", name="wireless_constant_window", caption={"lo-wireless-constant-window"}, direction="vertical" })
			
			for _, entity in pairs(global.lo_wireless_signals.constant_emmiters) do
				local key = getKey(entity)
				local device = global.lo_wireless_signals.devices[key]
				gui_element(wireless_constant_window, {type="button", name="bch_"..key, caption=""..deviceChannel(device)})
			end
		end
	elseif string.find(element.name, "bch_", 1, true) == 1 then		local key = string.sub(element.name,5)
		local device = global.lo_wireless_signals.devices[key]
		if player.gui.left.wireless_constant_window ~= nil then
			player.gui.left.wireless_constant_window.destroy()
		end
		
		destroy_remote_control()
 
		global.constant_remote_entity = player.surface.create_entity({
			name = "lo-radio-constant-remote",
			position = player.position,
			force = player.force,
			})
			
		global.constant_remote_entity_target = device
		global.constant_remote_entity.get_control_behavior().parameters = device.entity.get_control_behavior().parameters

		player.opened = global.constant_remote_entity
	end	
end 
------------------------------------------------------------------------------------------------------------------------------
onEntitySettingsPasted = function (event)
	if isRadioDevice(event.source) and isRadioDevice(event.destination) then
		local source_device			= global.lo_wireless_signals.devices[getKey(event.source)]
		local destination_device	= global.lo_wireless_signals.devices[getKey(event.destination)]
		
		if source_device == nil or destination_device == nil then
			return
		end
		
		setDeviceChannel(destination_device, deviceChannel(source_device))
	end
end 
------------------------------------------------------------------------------------------------------------------------------



script.on_init(onInit)

script.on_configuration_changed(onConfigChange)

script.on_event(defines.events.on_built_entity, onPlaceEntity)
script.on_event(defines.events.on_robot_built_entity, onPlaceEntity)

script.on_event(defines.events.on_pre_player_mined_item, onRemoveEntity)
script.on_event(defines.events.on_robot_pre_mined, onRemoveEntity)
script.on_event(defines.events.on_entity_died, onRemoveEntity)

script.on_event(defines.events.on_tick, onTick)
script.on_event(defines.events.on_gui_click, onGuiClick)
script.on_event(defines.events.on_entity_settings_pasted, onEntitySettingsPasted)