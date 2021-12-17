-- Author : Lord Odin, based on skan-radio mod, simplified and added channels with text names
------------------------------------------------------------------------------------------------------------------------------
require "util"

local updatePeriod = 2
local mod_version = "1.0.0"
local transmittersRequirePower = false
local receiversRequirePower = false
local fullResetCount = 0

------------------------------------------------------------------------------------------------------------------------------
local function getKey(position)
	return "los_x" .. position.x .. "y".. position.y
end
------------------------------------------------------------------------------------------------------------------------------
local function isRadioDevice(entity)
	return entity.name == "lo-radio-transmitter" or entity.name == "lo-radio-receiver"
end
------------------------------------------------------------------------------------------------------------------------------
local function isTransmitter(entity)
	return entity.name == "lo-radio-transmitter" 
end
------------------------------------------------------------------------------------------------------------------------------
local function isReceiver(entity)
	return entity.name == "lo-radio-receiver"
end
------------------------------------------------------------------------------------------------------------------------------
local wire_colors =
{
    defines.wire_type.red,
    defines.wire_type.green
}
------------------------------------------------------------------------------------------------------------------------------
function merge_signals(state, signals)
    for _,signal in ipairs(signals) do
        local key = signal.signal.type .. ":" .. signal.signal.name
        --debugPrint("Found a signal: " .. key)
        local previous = state[key]
        if not previous then
            state[key] = { signal = signal.signal, count = signal.count }
        else
            state[key] = { signal = signal.signal, count = signal.count + previous.count }
        end
    end
end
------------------------------------------------------------------------------------------------------------------------------
--function merge_state(state, a)
--    for key, signal in pairs(a) do
--        local previous = state[key]
--        if not previous then
--            state[key] = signal
--        else
--            state[key] = { signal = signal.signal, count = signal.count + previous.count }
--        end
--    end
--end
------------------------------------------------------------------------------------------------------------------------------
local function init_global()
    if not global.lo_wireless_signals then
        global.lo_wireless_signals = {devices = {}}
    end
end
------------------------------------------------------------------------------------------------------------------------------
local function debugPrint(string)
    local p = game.players[1]
    p.print(string)
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
local function storeEntity(storage_table, new_entity)
	local data = {
		  position			= new_entity.position
		, entity			= new_entity
		, network_name		= (stored_entity ~= nil and stored_entity.network_name or "default")
		}
	storage_table[getKey(new_entity)] = data
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

	--- The UI
	for _,player in pairs(game.players) do
		if is_valid(player.opened) and isRadioDevice(player.opened) then
			lo_radio_network_frame = gui_element(player.gui.left, {type="frame", name="lo_radio_network_frame", caption={"Wireless device"}, direction="vertical" })
			gui_element(lo_radio_network_frame, {type="label", name="lbChannel", caption="Channel"})
			gui_element(lo_radio_network_frame, {type="textfield", name="tbChannel"})
		elseif player.gui.left.lo_radio_network_frame ~= nil then
				player.gui.left.lo_transmitter_frame.destroy()
		end
	end
	
	-- Process devices: transmitters and recievers
	-- create new temp table networks
	-- stage == 0 : iterate only transmitters, write their signals to corresponding key in networks temp table
	-- stage == 1 : iterate only receivers, read signals from corresponding key in networks temp table

	local networks = {}	
	for stage = 0,1 do
		for k, device in pairs(global.lo_wireless_signals.devices) do
			if device.entity.valid then
				if not transmittersRequirePower or device.entity.energy > 0 then 
					if stage == 0 then
						if isTransmitter(entity) then
							for i = 1, #wire_colors do -- check both red and green wires
								local c = device.entity.get_circuit_network(wire_colors[i])
								if c then
									merge_signals(networks[device.network_name], c.signals)
								end -- if c then
							end -- for i = 1, #wire_colors do
						end -- if isTransmitter(entity)
					else -- i.e.   stage != 0
						if isReceiver(entity) then
							device.entity.get_control_behavior().parameters = networks[device.network_name]
						end -- if isReceiver(entity)
					end -- if stage
				end -- if not transmittersRequirePower or device.entity.energy > 0 and device
			else -- !device.entity.valid
				resetInvalidEntity(device)
			end -- if device.entity.valid
		end -- for k, device in pairs(global.lo_wireless_signals.devices)
	end --for stage = 0,1
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
        entity.operable = false -- disable the UI
        entity.get_or_create_control_behavior().connect_to_logistic_network = false -- keep it separate from the logistic network
        entity.get_control_behavior().circuit_condition = signal_everything
		storeEntity(global.lo_wireless_signals.transmitters, entity)
    elseif isReceiver(entity) then
        entity.operable = false
		storeEntity(global.lo_wireless_signals.receivers, entity)
    end
end
------------------------------------------------------------------------------------------------------------------------------
local function onRemoveEntity(event) -- the removed device needs to be removed from the global list(s)
    local entity = event.entity
    if isRadioDevice(entity) then
		table.remove(global.lo_wireless_signals.devices, getKey(entity))
    end
end
------------------------------------------------------------------------------------------------------------------------------
onGuiClick = function (event)
	player = game.players[event.player_index]
	element = event.element
	
	-- Changing device's channel
	if is_valid(player.opened) and isRadioDevice(player.opened) and element.name == "tbChannel" then
		local entity = player.opened		
		local device = global.lo_wireless_signals.devices[getKey(entity.position)]
		if device ~= nil then
			global.lo_wireless_signals.devices[getKey(entity.position)].network_name = element.text
		else
			debugPrint("lo_radio_telemetry - onGuiClick failed - no radio device data found for opened entity.")
		end
	else
		return
	end
end 
------------------------------------------------------------------------------------------------------------------------------

script.on_init(onInit)

script.on_configuration_changed(onConfigChange)

script.on_event(defines.events.on_built_entity, onPlaceEntity)
script.on_event(defines.events.on_robot_built_entity, onPlaceEntity)

script.on_event(defines.events.on_preplayer_mined_item, onRemoveEntity)
script.on_event(defines.events.on_robot_pre_mined, onRemoveEntity)
script.on_event(defines.events.on_entity_died, onRemoveEntity)

script.on_event(defines.events.on_tick, onTick)
script.on_event(defines.events.on_gui_click, onGuiClick)
