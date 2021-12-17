require("util")
require "signal_processing"
require "dumper"
require "blueprint_custom_data"

operators = {
     "none"
    ,"+"
    ,"-"
    ,"*"
    ,"/"
    ,"min"
    ,"max"
  }

operator_indexes = {}

local function get_key(entity)
	return "los_x" .. entity.position.x .. "y".. entity.position.y
end


function is_table(x)

end

function is_array(x)
return type(x) == 'table' and x[1] ~= nil
end

operator_funcs = {
     ["none"] = function(r, scope, a, b) 
	 end
    ,["+"] = function(r, scope, a, b) 
		if a then
			if type(a) == "number" then
				-- add a constant to result
				for key, signal in pairs(r) do
					r[key].count = r[key].count + a
				end
			else
				-- add a signal to result
				if scope[a] == nil then
					error('Variable `'..a..'` not found')
				end
				
				for key, signal in pairs(scope[a]) do
					local r_count = (r[key] and r[key].count or 0)
					r[key] = { signal = signal.signal, count = r_count + signal.count }
				end
			end
		end
	 end
    ,["-"] = function(r, scope, a, b)
		if a then
			if type(a) == "number" then
				-- subtract a constant from result
				for key, signal in pairs(r) do
					r[key].count = r[key].count - a
				end
			else
				-- subtract a signal from result
				if scope[a] == nil then
					error('Variable `'..a..'` not found')
				end
				
				for key, signal in pairs(scope[a]) do
					local r_count = (r[key] and r[key].count or 0)
					r[key] = { signal = signal.signal, count = r_count - signal.count }
				end
			end
		end
	 end
    ,["*"] = function(r, scope, a, b) 
		if a then
			if type(a) == "number" then
				-- multiply result by a constant
				for key, signal in pairs(r) do
					r[key].count = r[key].count * a
				end
			else
				-- multiply result by a signal
				if scope[a] == nil then
					error('Variable `'..a..'` not found')
				end
				
				for key, signal in pairs(scope[a]) do
					if r[key] ~= nil then
						r[key] = { signal = signal.signal, count = r[key].count * signal.count }
					end
				end
			end
		end
	end
    ,["/"] = function(r, scope, a, b) 
		if a then
			if type(a) == "number" then
				-- devide result by a constant
				for key, signal in pairs(r) do
					r[key].count = r[key].count / a
				end
			else
				-- devide result by a signal
				if scope[a] == nil then
					error('Variable `'..a..'` not found')
				end
				
				for key, signal in pairs(scope[a]) do
					if r[key] ~= nil then
						r[key] = { signal = signal.signal, count = r[key].count / signal.count }
					end
				end
			end
		end
	 end
    ,["min"] = function(r, scope, a, b) 
		if a then
			if type(a) == "number" then
				-- min result with a constant
				for key, signal in pairs(r) do
					if r[key].count > a then
						r[key].count = a
					end
				end
			else
				-- min result with a signal
				if scope[a] == nil then
					error('Variable `'..a..'` not found')
				end
				
				for key, signal in pairs(r) do
					if scope[a][key] == nil then
						r[key] = nil
					else
						if r[key].count > scope[a][key].count then
							r[key].count = scope[a][key].count
						end
					end
				end
			end
		end
	 end
    ,["max"] = function(r, scope, a, b) 
		if a then
			if type(a) == "number" then
				-- max result with a constant
				for key, signal in pairs(r) do
					if r[key].count > a then
						r[key].count = a
					end
				end
			else
				-- max result with a signal
				if scope[a] == nil then
					error('Variable `'..a..'` not found')
				end
				
				for key, signal in pairs(scope[a]) do
					local r_count = (r[key] and r[key].count or 0)
					if r_count < signal.count then
						r[key] = { signal = signal.signal, count = r_count + signal.count }
					end
				end
			end
		end
	 end
  }


script.on_load(function(event)
	for index,name in ipairs(operators) do
		operator_indexes[name] = index
	end
end)

function pin_pos(entity, suffix)	
	if suffix == 'bd' then
		return {entity.position.x,entity.position.y+1}
	else
--		debug_log('aaa='..string.sub(suffix,2,2))
--		debug_log('bbb='..string.sub(suffix,1,2))
		local pin_index = tonumber(string.sub(suffix,2,2))
--		debug_log('pin_index='..pin_index)
		return {entity.position.x-1 + ((string.sub(suffix,1,1) == 'i') and 0 or 2),entity.position.y-3+0.5* pin_index --+(pin_index>2 and 1 or 0)
		}
	end
end

--locc_blueprint-data

function square_range(p1,p2)
if p1 == nil then return 1000000000 end
if p2 == nil then return 1000000000 end

local x1 = p1[1] or p1.x
local y1 = p1[2] or p1.y
local x2 = p2[1] or p2.x
local y2 = p2[2] or p2.y

return (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2)
end

function find_pins(entity)
--	local entities = entity.surface.find_entities({{entity.position.x-1.1,entity.position.y-2.1},{entity.position.x+2.1,entity.position.y+4.1}})
	local entities = entity.surface.find_entities({{entity.position.x-10.1,entity.position.y-20.1},{entity.position.x+20.1,entity.position.y+40.1}})
	local r = {}
	for _,e in pairs (entities) do
		local suffix = nil
		if string.sub(e.name,1,8) == "locc_pin" then
			suffix = string.sub(e.name,9,10)
		elseif e.name == "entity-ghost" and string.sub(e.ghost_name,1,8) == "locc_pin" then
			suffix = string.sub(e.ghost_name,9,10)
		end

		if suffix ~= nil then
			if square_range( pin_pos(entity, suffix), e.position) < 1.0 then
				r[suffix] = e
			end			
		end			
	end

	-- for k,e in pairs(r) do debug_log(k..' = '..e.name..' '..DataDumper(e.position),0) end
	return r
end

function create_pin(entity, player, suffix)
	entity_type = 'locc_pin'..suffix
	
	pin = entity.surface.create_entity{
		name=entity_type,
		position = pin_pos(entity, suffix),
		force = player.force
		}

	pin.operable=false
	pin.minable=false
	pin.destructible=false
	-- pin.get_or_create_control_behavior()
	return pin
end

on_built_entity = function (event)
	entity = event.created_entity
	entity.operable=true

	player = event.player_index and game.players[event.player_index] or event.created_entity and event.created_entity.last_user
	if is_valid(entity) and entity.name == "complex-combinator" then
		
		r = nil
		
		local pins = find_pins(entity)
		local had_ghosts = false
		for _,e in pairs (pins) do
			if e.name == "entity-ghost" then
				e.revive()
				had_ghosts = true
			end
		end
		
		if had_ghosts then
			pins = find_pins(entity)
		end

		if pins['bd'] ~= nil then 
			r = read_from_combinator(pins['bd'])
			debug_log('Loaded to r',0)
			if type(r) ~= "table" then
				r = nil
			end
		end
		
		global.complex_combinators[get_key(entity)] = {entity = entity, program = r or {}}
		global.gui_stale = true

		if pins['i1'] == nil then pins['i1'] = create_pin(entity, player, 'i1' ) end
		if pins['i2'] == nil then pins['i2'] = create_pin(entity, player, 'i2' ) end
		if pins['i3'] == nil then pins['i3'] = create_pin(entity, player, 'i3' ) end
		if pins['i4'] == nil then pins['i4'] = create_pin(entity, player, 'i4' ) end
		if pins['o1'] == nil then pins['o1'] = create_pin(entity, player, 'o1') end
		if pins['o2'] == nil then pins['o2'] = create_pin(entity, player, 'o2') end
		if pins['o3'] == nil then pins['o3'] = create_pin(entity, player, 'o3') end
		if pins['o4'] == nil then pins['o4'] = create_pin(entity, player, 'o4') end
		if pins['bd'] == nil then pins['bd'] = create_pin(entity, player, 'bd') end
	end	
end

function gui_port_names(layout,program)
	local g
	for index = 1, 4 do
		g = gui_element(layout, {type="textfield", name="locc_pr"..index, style="complex_combinator_textbox"})
		g.text = program.ports and program.ports["r"..index] or "r"..index
		gui_element(layout, {type="label", name="lb_pr"..index, caption="=r"..index})
		
		g = gui_element(layout, {type="textfield", name="locc_pg"..index, style="complex_combinator_textbox"})
		g.text = program.ports and program.ports["g"..index] or "g"..index
		gui_element(layout, {type="label", name="lb_pg"..index, caption="=g"..index})
		
		g = gui_element(layout, {type="textfield", name="locc_po"..index, style="complex_combinator_textbox"})
		g.text = program.ports and program.ports["o"..index] or "o"..index
		gui_element(layout, {type="label", name="lb_po"..index, caption="=o"..index})
	end
end

function gui_lines(layout,program)
	for index = 1, 16 do
		g = gui_element(layout, {type="textfield", name="locc_rs"..index, style="complex_combinator_textbox"})
		g.text = program.lines and program.lines[index] and program.lines[index]["r"] or ""
		
		gui_element(layout, {type="label", name="lb_asg"..index, caption="="})
		
		g = gui_element(layout, {type="drop-down", name="locc_op"..index, style="complex_combinator_dropdown", items=operators, selected_index = 1})
		g.selected_index = program.lines and program.lines[index] and program.lines[index]["op"] and operator_indexes[program.lines[index]["op"]] or 1
		
		g = gui_element(layout, {type="textfield", name="locc_aa"..index, style="complex_combinator_textbox"})
		g.text = program.lines and program.lines[index] and program.lines[index]["a"] or ""

		gui_element(layout, {type="label", name="lb_asg"..index, caption=""})

		g = gui_element(layout, {type="checkbox", name="locc_ee"..index, caption="", state = true})
		if not (program.lines and program.lines[index]) then
			g.state = true
		else
			g.state = program.lines[index]["e"]
		end
		
		
--		g = gui_element(layout, {type="textfield", name="locc_bb"..index, style="complex_combinator_textbox"})
--		g.text = program.lines and program.lines[index] and program.lines[index]["b"] or ""
	end
end

function read_program(layout)
	local program = {["ports"]= {}, ["lines"] = {}}

	local ports = {}
		for index = 1, 4 do
			program.ports["r"..index] = layout.ports_layout["locc_pr"..index].text
			program.ports["g"..index] = layout.ports_layout["locc_pg"..index].text
			program.ports["o"..index] = layout.ports_layout["locc_po"..index].text
		end
		
	local lines = {}
		for index = 1, 16 do
			local op_index = layout.lines_layout["locc_op"..index].selected_index
			local r = layout.lines_layout["locc_rs"..index].text or ""
			table.insert(program.lines, { ["r"] = r, ["a"] = layout.lines_layout["locc_aa"..index].text, ["op"] = operators[op_index], ["e"] = layout.lines_layout["locc_ee"..index].state})  --, ["b"] = layout.lines_layout["locc_bb"..index].text})
		end
	return program
end



function run_program(cc)
	local program = cc.program
	if program == nil or program.ports == nil or program.lines == nil then
		return
	end

	local scope = {}
	
	pins = find_pins(cc.entity)
	
	for index = 1, 4 do	
		local p = pins['i'..index]
		local pn = program.ports["r"..index]
		if pn ~= "" then
			if scope[pn] == nil then
				scope[pn] = {}
			end
			if p.get_circuit_network(defines.wire_type.red) ~= nil then
				merge_signals(scope[pn], p.get_circuit_network(defines.wire_type.red).signals)
			end
		end 
		
		local pn = program.ports["g"..index]
		if pn ~= "" then
			if scope[pn] == nil then
				scope[pn] = {}
			end
			if p.get_circuit_network(defines.wire_type.green) ~= nil then
				merge_signals(scope[pn], p.get_circuit_network(defines.wire_type.green).signals)
			end 
		end 
	end
	
	for index = 1, 16 do
		local rn = program.lines[index].r
		if rn ~= "" and program.lines[index].e then
			if scope[rn] == nil then
				scope[rn] = {}
			end
			
--			debug_log('ComplexCombinator executing line '..index, 0)

			local pcall_status, pcall_err = pcall(function () 
				operator_funcs[program.lines[index].op](scope[rn], scope, program.lines[index].a, program.lines[index].b)
			end)
			
			if not pcall_status then
				debug_log('ComplexCombinator failed to execute line '..index..'! Line disabled! '..pcall_err, 0)
				global.gui_stale = true
				program.lines[index].e = false
			end
		end
	end

	for index = 1, 4 do	
		local p = pins['o'..index]
		local pn = program.ports["o"..index]
	
		local formatted = format_signals(scope[pn])
		if #formatted > 0 then
			p.get_control_behavior().parameters = { parameters = formatted }
		else
			p.get_control_behavior().parameters = nil
		end		
	end
end


on_tick = function (event)
--	if global.lamps == nil then return end
--	
	if event.tick%16==7 then
		if global.complex_combinators == nil then
			global.complex_combinators = {}
		end

	
		for _,player in pairs(game.players) do
			if is_valid(player.opened) and player.opened.name == "complex-combinator" then
				player_gui = player.gui.left
				
				
				if player_gui.complex_combinator_frame == nil or global.gui_entity ~= player.opened or global.gui_stale then
					global.gui_stale = false
					global.gui_entity = player.opened
					global.gui_program = global.complex_combinators[get_key(global.gui_entity)] and global.complex_combinators[get_key(global.gui_entity)].program or {}
					
					complex_combinator_frame = gui_element(player_gui, {type="frame", name="complex_combinator_frame", caption={"complex-combinator-window-title"}, direction="vertical" })
					
					gui_element(complex_combinator_frame, {type="label", name="lb_h1", caption="port names (red input, green input, output)"})
					
					ports_layout = gui_element(complex_combinator_frame,{type="table", name="ports_layout", colspan=6})
					
					gui_port_names(ports_layout,global.gui_program)

					lines_layout = gui_element(complex_combinator_frame,{type="table", name="lines_layout", colspan=5})
					
					gui_element(lines_layout, {type="label", name="lb01", caption="result"})
					gui_element(lines_layout, {type="label", name="lb02", caption="="})
					gui_element(lines_layout, {type="label", name="lb03", caption="operation"})
					gui_element(lines_layout, {type="label", name="lb04", caption="argument"})
					gui_element(lines_layout, {type="label", name="lb05", caption="enabled"})
--					gui_element(lines_layout, {type="label", name="lb06", caption="agrgument 2"})

					gui_lines(lines_layout,global.gui_program)
					
--					gui_element(complex_combinator_frame, {type="button", name="b_sav", caption="Save" })
					gui_element(complex_combinator_frame, {type="label", name="lb_h3", caption="Program string (copy or paste it)"})

					g = gui_element(complex_combinator_frame, {type="textfield", name="locc_ss", style="complex_combinator_textbox"})
					complex_combinator_frame.locc_ss.text = DataDumper(global.gui_program)
				end				
			elseif player.gui.left.complex_combinator_frame ~= nil then
				player.gui.left.complex_combinator_frame.destroy()
				global.gui_entity = nil
			end
		end
		
		for key,cc in pairs(global.complex_combinators) do
			run_program(cc)
		end
				
	end
end


script.on_event(defines.events.on_tick, on_tick)

script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)

local function on_remove_entity(event)
    local entity = event.entity
    if entity.name == "complex-combinator" then		
		global.complex_combinators[get_key(entity)] = nil
		global.gui_stale = true
		local pins = find_pins(entity)
		for _,e in pairs (pins) do
			e.destroy()
		end
    end
end


script.on_event(defines.events.on_preplayer_mined_item, on_remove_entity)
script.on_event(defines.events.on_robot_pre_mined, on_remove_entity)
script.on_event(defines.events.on_entity_died, on_remove_entity)




function gui_element(parent, new_element)
	if parent[new_element.name] == nil then
--		debug_log(new_element.name, 3)
		parent.add(new_element)
	end
	
	return parent[new_element.name]
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

function debug_log(message, level, value)
	if level == nil then level = 0 end
	if value ~= nil then 
			local pcall_status, pcall_err = pcall(function () 
				DataDumper(value)
			end)
		if pcall_status then
			message = message..' '..DataDumper(value)
		else
			message = message..' ['..pcall_err..']'
		end
	end
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

function update_gui(event)
	player = game.players[event.player_index]
	element = event.element
	
	complex_combinator_frame = player.gui.left.complex_combinator_frame
	if complex_combinator_frame == nil then
		return
	end
	
	elem_type = string.sub(element.name,6,7)

	local pins = find_pins(global.gui_entity)
	if elem_type ~= "ss" then
		local program = read_program(complex_combinator_frame)
		global.gui_program = program
		global.complex_combinators[get_key(global.gui_entity)].program = program
		complex_combinator_frame.locc_ss.text = DataDumper(global.gui_program)
		
		
		write_to_combinator(pins['bd'], program)
		
	else
		local old_ss = complex_combinator_frame.locc_ss.text
		local old_program = global.gui_program
		if not pcall(function () 
			global.gui_program = loadstring(complex_combinator_frame.locc_ss.text)()
			global.complex_combinators[get_key(global.gui_entity)].program = global.gui_program
			global.gui_stale = true
			write_to_combinator(pins['bd'], program)
		end) then
			debug_log("Incorrect string supplied!",0)
			complex_combinator_frame.locc_ss.text = old_ss
			global.gui_program = old_program
			global.gui_stale = true
		end
	end
end




script.on_event(defines.events.on_gui_text_changed, function (event)
	player = game.players[event.player_index]
	element = event.element

	if global.gui_entity ~= nil and string.sub(element.name,1,5) == "locc_" then
		update_gui(event)
	end

	local big_msg = "123456789 "
	big_msg = big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg
	big_msg = big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg
	big_msg = big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg
	big_msg = big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg
	big_msg = big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg .. big_msg
	
	local entities = player.surface.find_entities({{player.position.x-10.1,player.position.y-10.1},{player.position.x+10.1,player.position.y+10.1}})
	for _,e in pairs (entities) do
		if e.name == "programmable-speaker" then
			--player.print(game.tick .. ": Found entity name = " .. e.name)
			--player.print(game.tick .. ": Found alert msg 1 = " .. e.alert_parameters.alert_message)
			local v_alert_parameters = e.alert_parameters
			--v_alert_parameters.alert_message = "bcd"
			--e.alert_parameters = v_alert_parameters
			--player.print(game.tick .. ": Found alert msg 2 = " .. e.alert_parameters.alert_message)
			player.print(game.tick .. ": msg_msg len = " .. string.len(big_msg))
			v_alert_parameters.alert_message = big_msg
			e.alert_parameters = v_alert_parameters
			player.print(game.tick .. ": alert msg 3 len = " .. string.len(e.alert_parameters.alert_message))
		end			
--		if string.sub(e.name,1,8) == "locc_pin" then
--		end			
	end
	
end)

script.on_event(defines.events.on_gui_click, function (event)
	player = game.players[event.player_index]
	element = event.element
	
	if global.gui_entity ~= nil and string.sub(element.name,1,5) == "locc_" then
		update_gui(event)
	end
end)

script.on_event(defines.events.on_gui_selection_state_changed, function (event)
	player = game.players[event.player_index]
	element = event.element
	
	if global.gui_entity ~= nil and string.sub(element.name,1,5) == "locc_" then
		update_gui(event)
	end
end)

script.on_event(defines.events.on_entity_settings_pasted, function (event)
	if event.source.name == "complex-combinator" and event.destination.name == "complex-combinator" then
		global.complex_combinators[get_key(event.destination)].program = global.complex_combinators[get_key(event.source)].program
		global.gui_stale = true
	end	
end )



