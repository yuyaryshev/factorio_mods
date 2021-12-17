local settings_clean_inserters
local settings_auto_refuel
local settings_clear_liquids
local settings_cargo_filters
local settings_trash_stations
local settings_main_switch
local settings_block_stations

function lo_dbg_print(msg)
	game.players[1].print(msg)
end


function dbg_str(state)
if state == defines.train_state.on_the_path            then return 'on_the_path' end
if state == defines.train_state.path_lost              then return 'path_lost' end
if state == defines.train_state.no_schedule            then return 'no_schedule' end
if state == defines.train_state.no_path                then return 'no_path' end
if state == defines.train_state.arrive_signal          then return 'arrive_signal' end
if state == defines.train_state.wait_signal            then return 'wait_signal' end
if state == defines.train_state.arrive_station         then return 'arrive_station' end
if state == defines.train_state.wait_station           then return 'wait_station' end
if state == defines.train_state.manual_control_stop    then return 'manual_control_stop' end
if state == defines.train_state.manual_control         then return 'manual_control' end
return 'nil'
end

function fluidsTotal(train)
	local summ = 0
	for k,v in pairs(train.get_fluid_contents()) do
	 	summ = summ + v
	end	
	return summ
end

function itemsTotal(train)
	local summ = 0
	for k,v in pairs(train.get_contents()) do
	 	summ = summ + v
	end	
	return summ
end

function IsLTNDepot(stationName)
	return stationName == "Depo"
end

function LTNDepotIsNext(train)
  if #train.schedule.records > 0 and train.schedule.current ~= nil then 
	if train.schedule.current < #train.schedule.records then
	  return IsLTNDepot(train.schedule.records[train.schedule.current+1].station)
	elseif train.schedule.current == #train.schedule.records then
	  return IsLTNDepot(train.schedule.records[1].station)
	end
  end
  return false
end

function LTNDepotIsCurrent(train)
	return 
			#train.schedule.records > 0 
		and train.schedule.current ~= nil 
		and IsLTNDepot(train.schedule.records[train.schedule.current].station)
end

function hasSchedule(train, stationName)
if train.schedule == nil then
	return false
end

local i
	for i = 1, #train.schedule.records do
		if train.schedule.records[i].station == stationName then
			return true
		end
	end
return false
end

function isLTNTrain(train)
	return hasSchedule(train,'Depo')
end

function currentStation(train)
	if #train.schedule == 0 then
		return nil
	end
	
	return train.schedule.records[train.schedule.current].station
end

function nextStation(train)
	if #train.schedule == 0 then
		return nil
	elseif #train.schedule == 1 then
		return train.schedule.records[1]
	end

	local n = train.schedule.current + 1
	if n >= #train.schedule then
		n = 1
	end
	return train.schedule.records[n].station
end

function prevStation(train)
	if #train.schedule == 0 then
		return nil
	elseif #train.schedule == 1 then
		return train.schedule.records[1]
	end

	local n = train.schedule.current - 1
	if n <= 0 then
		n = #train.schedule
	end
	return train.schedule.records[n].station
end

function basicScheduleRecord(stationName)
	return {station = stationName,	wait_conditions = {{type = "inactivity", compare_type = "and", ticks = 120 }}}
end


function addScheduleNext(train, new_record)
	if type(new_record) == "string" then
		new_record = basicScheduleRecord(new_record)
	end

	
	if not hasSchedule(train, new_record.station) then
		local new_schedule = 
			{
			current = train.schedule.current
			,records = {}
			}
			
		for i = 1, #train.schedule.records do
			table.insert(new_schedule.records, train.schedule.records[i])
			if train.schedule.current ~= nil and train.schedule.current == i then
				table.insert(new_schedule.records, new_record)
				----lo_dbg_print('Adding train station '..new_record.station)
			end
		end
		train.schedule = new_schedule
	end
end

function getDistance2(a,b)
	local x = a.position.x-b.position.x
	local y = a.position.y-b.position.y
	return x*x+y*y
end

function addScheduleCurrent(train, new_record)
	if type(new_record) == "string" then
		new_record = basicScheduleRecord(new_record)
	end

	
	if not hasSchedule(train, new_record.station) then
		local new_schedule = 
			{
			current = train.schedule.current
			,records = {}
			}
			
		for i = 1, #train.schedule.records do
			if train.schedule.current ~= nil and train.schedule.current == i then
				table.insert(new_schedule.records, new_record)
				----lo_dbg_print('Adding train station '..new_record.station)
			end
			table.insert(new_schedule.records, train.schedule.records[i])
		end
		train.schedule = new_schedule
	end
end

function blockTrainAndStation(train)
	train.manual_mode = true
	local station = train.station or prevStation(train)
	--lo_dbg_print('Blocked train='..train.id..', fluidsTotal(train)='..fluidsTotal(train)..', itemsTotal(train)='..itemsTotal(train)..', station='..(station and station.name or 'nil'))
	
	local firstLoco = train.front_stock
    local px = firstLoco.position.x
    local py = firstLoco.position.y
    local searchArea = {
            {
                px - 15,
                py - 15
            },
            {
                px + 15,
                py + 15
            }
        }
		
	if not station then
		local stations = firstLoco.surface.find_entities_filtered{area=searchArea, type = "train-stop"}
		for _, entity in ipairs(stations) do
			--lo_dbg_print('Blocked train='..train.id..' - near station '..entity.backer_name..'!')
		end
	end
	
	local blockers0 = firstLoco.surface.find_entities_filtered{area=searchArea, type = "constant-combinator", name="switchbutton"}
	if #blockers0 <= 0 then 
		--lo_dbg_print('Blocked train='..train.id..' - no blocker found on station!')
		return 
	end
	
	-- Filter entities, keep only relevant switches
	local blockers = {}	
	for _, entity in ipairs(blockers0) do
		local c_signals = entity.get_control_behavior().parameters.parameters
		for _,item in ipairs(c_signals) do
			if item.signal ~= nil and item.signal.name == "easyltn-block" then
				table.insert(blockers, entity)
				break
			end
		end
	end
	
	local blocker = blockers[1]
	if #blockers > 1 then
		local blocker_d2 = 100000000
		for _, entity in ipairs(blockers) do
			local d2 = getDistance2(entity, firstLoco)
			if blocker_d2 > d2 then
				blocker_d2 = d2
				blocker = entity
			end
		end
	end
	
	local control = blocker.get_or_create_control_behavior()
	control.enabled = false
end

function printSchedule(train)
local i
	for i = 1, #train.schedule.records do
		if train.schedule.current ~= nil and train.schedule.current == i then
			--lo_dbg_print('sch => '..serpent.line(train.schedule.records[i].station))
		else
			--lo_dbg_print('sch    '..serpent.line(train.schedule.records[i].station))
		end
	end
end


function load_settings(event)
	settings_main_switch 		= settings.global["easy_ltn"].value or false
	settings_clean_inserters 	= settings.global["easy_ltn-clear-inserters"].value or false
	settings_auto_refuel		= settings.global["easy_ltn-auto-refuel"].value/100.0 or 0.0			-- double, percent
	settings_clear_liquids		= settings.global["easy_ltn-clear-liquids"].value or 0.0				-- double, max amount to clear
	settings_cargo_filters		= settings.global["easy_ltn-cargo-filters"].value or false			
	settings_trash_stations		= settings.global["easy_ltn-trash-station"].value or false
	settings_block_stations 	= settings.global["easy_ltn-block-stations"].value or false
end

require('trainInsertersPutBack')
require('setCargoFilters')
require('refuel')

load_settings()

script.on_event(defines.events.on_runtime_mod_setting_changed, load_settings)

function on_train_changed_state_func(event)
	if __DebugAdapter then
		lo_dbg_print('inside __DebugAdapter')
		__DebugAdapter.breakpoint("Yya_break_test")
	else
		lo_dbg_print('outside of __DebugAdapter')		
	end 


	if settings_main_switch then
		local train = event.train
		if isLTNTrain(train) then
			local lo_state = 'unknown';
			if event.old_state == defines.train_state.wait_station then
				lo_state = 'leaves';
			elseif event.train.state == defines.train_state.wait_station then
				lo_state = 'stops';
			end
--			--lo_dbg_print('id='..train.id)
--			printSchedule(train)
--			--lo_dbg_print('lo_state='..lo_state)
			
--			--lo_dbg_print('Train event.old_state='..dbg_str(event.old_state)..', train.state='..dbg_str(train.state))

			-- defines.train_state.on_the_path
			if event.old_state == defines.train_state.wait_station then
				-- train leaving a station
				if settings_cargo_filters and IsLTNDepot(prevStation(train)) then
	--				--lo_dbg_print('setCargoFilters')
	--				setCargoFiltersNew(train)
				end
				
				if next(train.get_contents()) then
				
					if settings_clean_inserters then
						trainInsertersPutBack(train)
					end
					
					if settings_clear_liquids and fluidsTotal(train) < settings_clear_liquids then
						train.clear_fluids_inside()
					end
					
					if settings_block_stations and LTNDepotIsCurrent(train) and (fluidsTotal(train) + itemsTotal(train) > 0.1) then
						blockTrainAndStation(train)
					elseif settings_trash_stations and LTNDepotIsCurrent(train) and (fluidsTotal(train) + itemsTotal(train) > 0.1) then
						--lo_dbg_print('Sending to Cleaner train='..train.id..', fluidsTotal(train)='..fluidsTotal(train)..', itemsTotal(train)='..itemsTotal(train)..', station='..(train.station and train.station.name or 'nil'))
						addScheduleCurrent(train, "Cleaner")	  
					end
				end
			
			-- event.old_state == defines.train_state.arrive_signal and 
			elseif event.train.state == defines.train_state.wait_station then
			
			--lo_dbg_print('id='..train.id)
			printSchedule(train)
			--lo_dbg_print('lo_state='..lo_state)
--			--lo_dbg_print('Train event.old_state='..dbg_str(event.old_state)..', train.state='..dbg_str(train.state))
			
				-- train stopped on a station	
				if settings_cargo_filters then
					--lo_dbg_print('setCargoFilters - train stopped on a station	')
					setCargoFiltersOld(train)
				end

				if settings_cargo_filters then
	--				--lo_dbg_print('setCargoFilters')
	--				setBarNew(train)
				end
				
				if settings_auto_refuel > 0.001 then
					refuel(train, settings_auto_refuel)
				end
			end
		end
	end
end

script.on_event(defines.events.on_train_changed_state, function(event) 
	local status, err = pcall(on_train_changed_state_func, event)
	if not status then
		--lo_dbg_print('ERROR Catched by pcall:'..serpent.line(err))
	end
end)


