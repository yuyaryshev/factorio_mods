-- Author : Lord Odin, based on skan-radio mod, simplified and added channels with text names
------------------------------------------------------------------------------------------------------------------------------
require "util"
require "signal_processing"

local updatePeriod = 10
local mod_version = "1.0.5"
local transmittersRequirePower = false
local receiversRequirePower = false
local fullResetCount = 0

local init_done = false

------------------------------------------------------------------------------------------------------------------------------
function destroy_remote_control()
	if global.constant_remote_entity and constant_remote_entity.valid() then
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
local function storeDevice(new_entity)
	local data = {
		  position			= new_entity.position
		, entity			= new_entity
		, network_name		= (stored_entity ~= nil and stored_entity.network_name or "def")
		}
	if isConstant(new_entity) then
		global.lo_wireless_signals.constant_emmiters[getKey(new_entity)] = new_entity	
	end
	global.lo_wireless_signals.devices[getKey(new_entity)] = data
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
		global.constant_remote_entity_target.entity.get_control_behavior().parameters.parameters = global.constant_remote_entity.get_control_behavior().parameters.parameters
		if player.opened ~= global.constant_remote_entity then
			destroy_remote_control()
		end
	end
	
	--- The UI
	for _,player in pairs(game.players) do
--	debugPrint("in UI1")
		if player.opened ~= nil then
			if player.gui.left.wireless_constant_window ~= nil then
				player.gui.left.wireless_constant_window.destroy()
			end
		end
		
		if player.opened ~= nil and isRadioDevice(player.opened) then
			local device = global.lo_wireless_signals.devices[getKey(player.opened)]
--		debugPrint("in UI3")
			if player.gui.left.lo_radio_network_frame == nil then
				lo_radio_network_frame = gui_element(player.gui.left, {type="frame", name="lo_radio_network_frame", caption={"lo-radio-device-settings"}, direction="vertical" })
				gui_element(lo_radio_network_frame, {type="label", name="lbChannel", caption={"lo-radio-device-channel"}})
				gui_element(lo_radio_network_frame, {type="textfield", name="tbChannel", text=device.network_name})
				gui_element(lo_radio_network_frame, {type="label", name="lbChannel", caption={"lo-radio-device-channel-hint"}})
--				gui_element(lo_radio_network_frame, {type="button", name="btnOk", caption={"lo-radio-device-ok"}})
--				gui_element(lo_radio_network_frame, {type="button", name="btnCancel", caption={"lo-radio-device-cancel"}})
			end
		elseif player.gui.left.lo_radio_network_frame ~= nil then
				player.gui.left.lo_radio_network_frame.destroy()
		end
	
	end
	
	-- Process devices: transmitters and recievers
	-- create new temp table networks
	-- stage == 0 : iterate only transmitters, write their signals to corresponding key in networks temp table
	-- stage == 1 : iterate all networks. fill networks with subnames.
	-- stage == 2 : iterate only receivers, read signals from corresponding key in networks temp table

	local networks = {}	
	local networks_dst = {} -- networks with subsignals added
	
	for stage = 0,2 do

		-- stage == 1 : iterate all networks. fill networks with subnames.
		if stage == 1 then
			for network_name, network_src in pairs(networks) do
				for _, subname in pairs(subNames(network_name)) do
					if networks_dst[subname]==nil then
						networks_dst[subname] = {}
					end
					
					merge_signals(networks_dst[subname], network_src)
--					debugPrint("subname = "..subname)
--					print_signals(network_src, "Src")
--					print_signals(networks_dst, "Merged")
				end
			end
--			print_signals(networks_dst, "Merged")
		end
		
		if stage ~= 1 then
			for k, device in pairs(global.lo_wireless_signals.devices) do
--	print_signals(networks, "S1 TTT")
				if device.entity.valid then
					if networks[device.network_name] == nil then
						networks[device.network_name] = {}
					end
--	print_signals(networks, "S2 TTT")
					
					if not transmittersRequirePower or device.entity.energy > 0 then 
						if stage == 0 then
							if isConstant(device.entity) then
								local c_signals = device.entity.get_control_behavior().parameters.parameters
								--print_signals(c_signals,"c_signals")
								merge_signals(networks[device.network_name], c_signals)
							end
						
						
--	print_signals(networks, "S3 TTT")
							if isTransmitter(device.entity) then
								if networks[device.network_name] == nil then
									networks[device.network_name] = {}
								end
--	print_signals(networks, "S4 TTT")
								
								for i = 1, #wire_colors do -- check both red and green wires
									local c = device.entity.get_circuit_network(wire_colors[i])
--	print_signals(networks, "S5 TTT")
									if c then
										merge_signals(networks[device.network_name], c.signals)
--									print_signals(networks[device.network_name], "Transmitter")
										
--									debugPrint("Transmitter device.network_name = '"..device.network_name.."'")


--									merge_signals(active_signals, c.signals)
--									print_signals(active_signals, "Transmitter")
									end -- if c then
--	print_signals(networks, "T1 TTT")
								end -- for i = 1, #wire_colors do
--	print_signals(networks, "T2 TTT")
							end -- if isTransmitter(entity)
--	print_signals(networks, "T3 TTT")
						else -- i.e.   stage != 0
							if isReceiver(device.entity) then
--							debugPrint("Receiver device.network_name = '"..device.network_name.."'")
--  print_signals(networks_dst, "Receiver")
--								local formatted = format_signals(networks[device.network_name] or {})
								local formatted = format_signals(networks_dst[device.network_name] or {})
								if #formatted > 0 then
									device.entity.get_control_behavior().parameters = { parameters = formatted }
								else
									device.entity.get_control_behavior().parameters = nil -- there are no incoming signals, so zero out the output
								end
							end -- if isReceiver(entity)
						end -- if stage
--	print_signals(networks, "T4 TTT")
				end -- if not transmittersRequirePower or device.entity.energy > 0 and device
				else -- !device.entity.valid
					resetInvalidEntity(device)
				end -- if device.entity.valid
--		print_signals(networks, "T5 TTT")
			end -- for k, device in pairs(global.lo_wireless_signals.devices)
--	print_signals(networks, "T6 TTT")
		end
	end --for stage = 0,2
--	print_signals(networks, "T7 TTT")
end
------------------------------------------------------------------------------------------------------------------------------
local signal_everything = {
  condition = {
      comparator = ">",
      first_signal = {type = "virtual", name = "signal-everything"},
      constant = 0
  }
}
------------------------------------------------------------------------------------------------------------------------------
local function onPlaceEntity(event)
    local entity = event.created_entity
    if isTransmitter(entity) then
        entity.get_or_create_control_behavior().connect_to_logistic_network = false -- keep it separate from the logistic network
        entity.get_control_behavior().circuit_condition = signal_everything
		storeDevice(entity)
    elseif isReceiver(entity) then
		storeDevice(entity)
    elseif isConstant(entity) then
		storeDevice(entity)
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
function subNames(s)
	local agg = nil
	local r = {}
	
	for part in string.gmatch(s, "([^.]+)") do
		if agg == nil then
			agg = part
		else
			agg = agg .. "." .. part
		end
		table.insert(r, agg)
	end
return r
end
------------------------------------------------------------------------------------------------------------------------------
onGuiTextChanged = function (event)
	player = game.players[event.player_index]
	element = event.element

	-- Changing device's channel
	if player.opened ~= nil and isRadioDevice(player.opened) then
		if element.name == "tbChannel" then
			local entity = player.opened		
			local device = global.lo_wireless_signals.devices[getKey(entity)]
			if device ~= nil then
				global.lo_wireless_signals.devices[getKey(entity)].network_name = player.gui.left.lo_radio_network_frame.tbChannel.text
			else
				debugPrint("lo_radio_telemetry - onGuiClick failed - no radio device data found for opened entity.")
			end
		end
	else
		return
	end
end 
------------------------------------------------------------------------------------------------------------------------------
onGuiClick = function (event)
	player = game.players[event.player_index]
	element = event.element

	-- Changing device's channel
	if element.name == "wireless_lite" then
		if player.gui.left.wireless_constant_window ~= nil then
			player.gui.left.wireless_constant_window.destroy()
		else 
			wireless_constant_window = gui_element(player.gui.left, {type="frame", name="wireless_constant_window", caption={"lo-wireless-constant-window"}, direction="vertical" })
			
			for _, entity in pairs(global.lo_wireless_signals.constant_emmiters) do
				local key = getKey(entity)
				local device = global.lo_wireless_signals.devices[key]
				gui_element(wireless_constant_window, {type="button", name="bch_"..key, caption=device.network_name})
			end
		end
	elseif string.find(element.name, "bch_", 1, true) == 1 then
		local key = string.sub(element.name,5)
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
		
		destination_device.network_name = source_device.network_name
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
script.on_event(defines.events.on_gui_text_changed, onGuiTextChanged)
script.on_event(defines.events.on_entity_settings_pasted, onEntitySettingsPasted)