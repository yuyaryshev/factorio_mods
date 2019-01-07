------------------------------------------------------------------------------
-- LTN code for reference
------------------------------------------------------------------------------

--	"logistic-train-stop-input"
--	getCircuitValues(stop.input)
--	"logistic-train-stop-output"


--	local function getCircuitValues(entity)
--	  local greenWire = entity.get_circuit_network(defines.wire_type.green)
--	  local redWire =  entity.get_circuit_network(defines.wire_type.red)
--	  local signals = {}
--	  if greenWire and greenWire.signals then
--	    for _, v in pairs(greenWire.signals) do
--	      if v.signal.type ~= "virtual" or ControlSignals[v.signal.name] then
--	        local item = v.signal.type..","..v.signal.name
--	        signals[item] = v.count
--	      end
--	    end
--	  end
--	  if redWire and redWire.signals then
--	    for _, v in pairs(redWire.signals) do
--	      if v.signal.type ~= "virtual" or ControlSignals[v.signal.name] then
--	        local item = v.signal.type..","..v.signal.name
--	        signals[item] = v.count + (signals[item] or 0) -- 2.7% faster than original non localized access
--	      end
--	    end
--	  end
--	  return signals
--	end

function setCargoFilterBars(x)
--	lo_dbg_print('Setting train filters to '..(item_name or 'nil'))
    if train.cargo_wagons then
    for n,wagon in pairs(train.cargo_wagons) do
      local inventory = wagon.get_inventory(defines.inventory.cargo_wagon)
      if inventory then
          log("Cargo-Wagon["..tostring(n).."]: setting "..tostring(#inventory).." filtered slots to '"..(item_name or 'nil').."'.")
          if x then
			inventory.set_bar(x)
		  else	
			inventory.clear_bar()
		  end
      end
    end
    end
end

function setCargoFiltersToItem(train,item_name)
--	lo_dbg_print('Setting train filters to '..(item_name or 'nil'))
    if train.cargo_wagons then
    for n,wagon in pairs(train.cargo_wagons) do
      local inventory = wagon.get_inventory(defines.inventory.cargo_wagon)
      if inventory then
          log("Cargo-Wagon["..tostring(n).."]: setting "..tostring(#inventory).." filtered slots to '"..(item_name or 'nil').."'.")
          for slotIndex=1, #inventory, 1 do
            inventory.set_filter(slotIndex, item_name)
          end
      end
    end
    end
end

function getStationItems(schedule)
	local r = {load = {}, unload = {}, do_load = false, do_unload = false}
	if schedule.wait_conditions then
		for _,wait_condition in pairs(schedule.wait_conditions) do
			if wait_condition.type == "item_count" then
				local c = wait_condition.condition
				if c.first_signal.type == "item" then				
					if c.comparator == ">" then
						r.load[c.first_signal.name] = c.constant
						r.do_load = true
					elseif (c.comparator == "=" and c.constant == 0) or c.comparator == "<=" then
						r.unloads[c.first_signal.name] = c.constant
						r.do_unload = true
					end
				end
			end
		end
	end
end

function getTotalItems(train)
	local totalItems = {load = {}, unload = {}}
	for recordIndex=1, #train.schedule.records, 1 do
		local res = getStationItems(train.schedule.records[recordIndex])		
		totalItems.load = totalItems.load + res.load
		totalItems.unload = totalItems.unload + res.unload
	end
	return totalItems
end

function setCargoFiltersNew(train)
	if #train.schedule.records > 0 and train.schedule.current ~= nil then
		local do_set_filters = true
		local item_to_set = nil
		local current_schedule = train.schedule.records[train.schedule.current]

		local totalItems = getTotalItems(train)		
		local load_items = {}
		
		-- Переходим от количества item'ов к количеству стеков
		local total_slots = 0
		for k,_ in pairs(totalItems.load) do
			local slots = 1.0*totalItems.load[k]/game.item_prototypes[k].stack_size
			load_items[k] = slots
			total_slots = total_slots+slots
		end

		-- Переходим к относительным величинам и границам интервала [0.0, 1.0]
		local interv = 0
		local load_ranges = {}
		for k,_ in pairs(load_items) do
			local ratio = load_items[k]/total_slots
			local interv_b = interv + ratio
			load_items[k] = ratio
			table.insert(load_ranges, {k=k, a=interv, b=interv_b})
			interv = interv_b
		end

	--	lo_dbg_print('Setting train filters to '..serpent.line(load_ranges))
		if train.cargo_wagons then
		for n,wagon in pairs(train.cargo_wagons) do
		  local inventory = wagon.get_inventory(defines.inventory.cargo_wagon)
		  if inventory then
			  log("Cargo-Wagon["..tostring(n).."]: setting "..tostring(#inventory).." filtered slots to '"..(item_name or 'nil').."'.")
			  for rangeIndex=1, #load_ranges, 1 do
				local r = load_ranges[rangeIndex]
				local a = math.ceil(r.a * #inventory)
				local b = math.ceil(r.b * #inventory)				
				for slotIndex=a, b, 1 do
					inventory.set_filter(slotIndex, r.k)
				end
			  end
		  end
		end
		end
	end
end

function setBarNew(train)
	if #train.schedule.records > 0 and train.schedule.current ~= nil then
		local current_schedule = train.schedule.records[train.schedule.current]
		local station_items = getStationItems(current_schedule)
		setCargoFilterBars(station_items.do_unload and station_items.do_load == false)
	end
end


function setCargoFiltersOld(train)
	if #train.schedule.records > 0 and train.schedule.current ~= nil then
		local do_set_filters = true
		local item_to_set = nil
		local current_schedule = train.schedule.records[train.schedule.current]
		if current_schedule.wait_conditions then
			for _,wait_condition in pairs(current_schedule.wait_conditions) do
				if wait_condition.type == "item_count" then
					local c = wait_condition.condition
					if c.comparator == "=" and c.first_signal.type == "item" and c.constant == 0 then
						if item_to_set then	-- several items?
							do_set_filters = false
						end
						item_to_set = 'iron-axe'	-- Setting this allow removing items only
					elseif c.comparator == ">" and c.first_signal.type == "item" then
						if item_to_set then	-- several items?
							do_set_filters = false
						end
						item_to_set = c.first_signal.name
					end
				end
			end
		end
		
		if do_set_filters and item_to_set then
			setCargoFiltersToItem(train,item_to_set)
		end
	end
end
