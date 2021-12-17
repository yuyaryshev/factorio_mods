-- Wire Language

require "parser"

local pc = nil
-------------------------------
-- General description
-------------------------------
--	pc.queues
--	- Priorities
--			Each queue is cycled 
--			Priorities of queue
--			- 7 Stopped - special priority - never processed
--			- 6 Lowest
--			- 5 Low
--			- 4 Normal
--			- 3 Higher
--			- 2 Highest
--			- 1 Realtime - special priority, each member of this queue is processed each time
-------------------------------


script.on_init(function()
	local old_version, new_version = nil
	local new_version_str = game.active_mods[MOD_NAME]
	if new_version_str then
		new_version = string.format("%02d.%02d.%02d", string.match(new_version_str, "(%d+).(%d+).(%d+)"))
	end
	
	pc = global.programmable_combinator
	if not pc.queues then
		pc.queues = {{},{},{},{},{},{},{},{}}
	end
end)

-- BELOW - TODO 

-------------------------------
-- Global options
-------------------------------
--	Each queue have params: 
--		- period - number of ticks to skip before processing next item from this queue
--		- lines - number of lines of code to process on each cycle
--		- max_lines - number of lines of code executed before turning combinator off
-------------------------------


-------------------------------
-- Queue functions
-------------------------------
function double_linked_add(prev_item, new_item)
	prev_item.next = new_item
	
	new_item.prev = prev_item
	new_item.next = prev_item.next
	
	prev_item.next.prev = new_item
end

function double_linked_remove(item)
	item.prev.next = item.next
	item.next.prev = item.prev
	item.prev = nil
	item.next = nil
end


-- Change combinator's queue - removes from old queue and puts it into new one
function programmable_combinator__reset_priority(this, put_first)
	if item.base_priority ~= item.current_priority then
		double_linked_remove(this)
		double_linked_add(pc_queues[item.base_priority], this)
	end
end
--	-	change_programmable_combinator_queue(item, bool put_first) 		
-------------------------------

-- order of arguments matters:
-- 	This function wires input_entity.output to output_entity.input.
-- 	Example input entity is a decider combinator, output is an arithmetic combinator
--	This function will link decider's output to arithmetic input
local function make_wire(input_entity, output_entity, color)
	local input_index = 1
	if input_entity.name == "decider-combinator" or input_entity.name == "arithmetic-combinator" then
		input_index = 2
	end
	input_entity.connect_neighbour({
		wire = color,
		target_entity = output_entity,
		source_circuit_id = input_index,
		target_circuit_id = 1,
		})
end

local function make_entity(context, combinator_type)
--	local context = 
--		{
--		 position = {0,0}
--		,player = game.players[1]
--		,force = game.players[1].force
--		}
	local prefix = ""

	if combinator_type == "d" then		-- decider
		local c3 = surface.create_entity({
				name = prefix.."decider-combinator",
				position = context.position,
				force = context.force,
				})

		c3.get_control_behavior().parameters = {parameters={
			 first_signal = {type="virtual",name="signal-red"}
			,constant = 10
			,comparator = ">"
			,output_signal = {type="virtual",name="signal-blue"}
			,copy_count_from_input = false
			}}
			
		local c4 = surface.create_entity({
				name = prefix.."decider-combinator",
				position = context.position,
				force = context.force,
				})
		c4.get_control_behavior().parameters = {parameters={
			 first_signal = {type="virtual",name="signal-red"}
			,constant = 12
			,comparator = ">"
			,output_signal = {type="virtual",name="signal-yellow"}
			,copy_count_from_input = false
			}}
	
	elseif combinator_type == "a" then	-- arithmetic
		local c2 = surface.create_entity({
				name = prefix.."arithmetic-combinator",
				position = test_positions[2],
				force = player.force,
				})
		c2.get_control_behavior().parameters = {parameters={
			 first_signal = {type="virtual",name="signal-green"}
	--		,second_signal = {type="virtual",name="signal-green"}
			,second_constant = 3
			,operation = "+"
			,output_signal = {type="virtual",name="signal-red"}
			}}
			
	elseif combinator_type == "c" then  -- constant
		local c1 = surface.create_entity({
				name = prefix.."constant-combinator",
				position = test_positions[1],
				force = player.force,
				})
		c1.get_control_behavior().parameters = {parameters={{index = 1, signal = {type="virtual",name="signal-green"}, count = 15 }}}
	elseif combinator_type == "s" then  -- power-switch
	end
			
			
			
			
	
			
		
	c1.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = c2,
		source_circuit_id = 1,
		target_circuit_id = 1,
		})
	
	c1.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = poles[1],
		source_circuit_id = 1,
		target_circuit_id = 1,
		})
			
	
	c2.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = c3,
		source_circuit_id = 2,
		target_circuit_id = 1,
		})
	
	c2.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = poles[2],
		source_circuit_id = 2,
		target_circuit_id = 1,
		})
	
	c3.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = poles[3],
		source_circuit_id = 2,
		target_circuit_id = 1,
		})
	
	c2.connect_neighbour({
		wire = defines.wire_type.green,
		target_entity = c4,
		source_circuit_id = 2,
		target_circuit_id = 1,
		})
		
	c4.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = poles[4],
		source_circuit_id = 2,
		target_circuit_id = 1,
		})		
end

function lo_assert(condition)
	if not condition then
		game.players[1].print("Assertion failed!")
	end
end

function implement_circuit_ast(stmt)
	if stmt.type == "operator" and stmt.operator == "function_call" then
		local function_identifer = stmt.args[1]
		lo_assert(function_identifer.type == "identifer" and function_identifer.name)
		
		local fn = function_identifer.name
		
		-- A > B => each
		-- each > B => each
		if fn == "decider" then			-- decider(condition, first, second, output)
		elseif fn == "arithmetic" then
		end
		
		function_identifer.name
	end


	
----------------------
--	if stmt.type == "operator" and stmt.operator == "function_call" then
--		local function_identifer = stmt.args[1]
--		lo_assert(function_identifer.type == "identifer" and function_identifer.name)
--		
--		local fn = function_identifer.name
--		
--		-- A > B => each
--		-- each > B => each
--		if fn == "decider" then			-- decider(condition, first, second, output)
--		elseif fn == "arithmetic" then
--		end
--		
--		function_identifer.name
--	end
end

function implement_circuit(source_code)
	local ast = apply_parser(source_code).ast
	implement_circuit_ast(ast)
end

-------------------------------
-- on_tick
-------------------------------
--	- For each queue item - run it's functions
-------------------------------



-------------------------------
-- Combinator fields
-------------------------------
--	- prev						-- previous combinator in queue
--	- next						-- next combinator in queue
--	- entity
--	- ports						-- map(port_number, port_entity)
--	- base_priority				-- int [0..9] - initial queue combinator belonged to
--	- current_priority			-- int [0..9] - current queue combinator belongs to
--	- compiled_lines			-- array of functions to be executed in loop
--	- next_line_to_execute		-- next line to be executed
--	- scope						-- current scope
-------------------------------
-- Combinator methods
-------------------------------
--	- register			- new combinator is built
--	- unregister		- combinator is removed or destroyed
--	- edit				- combinator is opened
--	- compile			- program is changed
--	- link				- some inputs are changed
--	- save				- saves combinator to string
--	- load				- loads combinator from string
-------------------------------




-------------------------------
-- Commands
-------------------------------
-- X = port(port_number)
-- priority(0-9, cycles_count)		-- Temporary changes priority for given number of cycles. After this number of cycles the priority is reset to base
-- base_priority(0-9)				-- Changes priority for given combinator permanently
-------------------------------



-------------------------------
-- GUI
-------------------------------
--	- Edit combinator
--		- Set initial priority
--		- Show averenge refresh period
--		- Program editor
--		- Errors list

--		- ?Debug mode
--		- ?Watches
-------------------------------


function on_tick_handler(event)
	local surface = game.surfaces.nauvis
	local player = game.players[1]
	local entities = surface.find_entities({{-100, -100},{100, 100}} )
	
	for _,entity in pairs(entities) do
		if entity.name == "medium-electric-pole" then
			return
		end
	end

	for _,entity in pairs(entities) do
		if not(entity.name == "player") then
			player.print("entity.name="..entity.name)
			entity.destroy()
		end
	end
	
	player.print("Creating test")


	surface.create_entity({
		name = "solar-panel",
		position = {-3,0},
		force = player.force,
		})

	
	local poles = {
	surface.create_entity({
		name = "medium-electric-pole",
		position = {0,0},
		force = player.force,
		}),
		
	surface.create_entity({
		name = "medium-electric-pole",
		position = {3,0},
		force = player.force,
		}),
		
	surface.create_entity({
		name = "medium-electric-pole",
		position = {6,0},
		force = player.force,
		}),
		
	surface.create_entity({
		name = "medium-electric-pole",
		position = {9,0},
		force = player.force,
		}),
		




	surface.create_entity({
		name = "medium-electric-pole",
		position = {0,8},
		force = player.force,
		}),
		
	surface.create_entity({
		name = "medium-electric-pole",
		position = {3,8},
		force = player.force,
		}),
		
	surface.create_entity({
		name = "medium-electric-pole",
		position = {6,8},
		force = player.force,
		}),
		
	surface.create_entity({
		name = "medium-electric-pole",
		position = {9,8},
		force = player.force,
		}),		
	}
	
	local test_positions = {{0,2},{3,2},{6,2},{9,2}}
	local prefix = ""
	local do_test = 0
	
	if do_test then
		prefix = "invisible-"
		test_positions = {{3,2},{3,2},{3,2},{3,2}}
	end
	
	local c1 = surface.create_entity({
			name = test_prefix.."constant-combinator",
			position = test_positions[1],
			force = player.force,
			})
	c1.get_control_behavior().parameters = {parameters={{index = 1, signal = {type="virtual",name="signal-green"}, count = 15 }}}
			
			
	local c2 = surface.create_entity({
			name = test_prefix.."arithmetic-combinator",
			position = test_positions[2],
			force = player.force,
			})
	c2.get_control_behavior().parameters = {parameters={
		 first_signal = {type="virtual",name="signal-green"}
--		,second_signal = {type="virtual",name="signal-green"}
		,second_constant = 3
		,operation = "+"
		,output_signal = {type="virtual",name="signal-red"}
		}}
			
			
	local c3 = surface.create_entity({
			name = test_prefix.."decider-combinator",
			position = test_positions[3],
			force = player.force,
			})
	c3.get_control_behavior().parameters = {parameters={
		 first_signal = {type="virtual",name="signal-red"}
		,constant = 10
		,comparator = ">"
		,output_signal = {type="virtual",name="signal-blue"}
		,copy_count_from_input = false
		}}
	
			
	local c4 = surface.create_entity({
			name = test_prefix.."decider-combinator",
			position = test_positions[4],
			force = player.force,
			})
	c4.get_control_behavior().parameters = {parameters={
		 first_signal = {type="virtual",name="signal-red"}
		,constant = 12
		,comparator = ">"
		,output_signal = {type="virtual",name="signal-yellow"}
		,copy_count_from_input = false
		}}
		
	c1.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = c2,
		source_circuit_id = 1,
		target_circuit_id = 1,
		})
	
	c1.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = poles[1],
		source_circuit_id = 1,
		target_circuit_id = 1,
		})
			
	
	c2.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = c3,
		source_circuit_id = 2,
		target_circuit_id = 1,
		})
	
	c2.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = poles[2],
		source_circuit_id = 2,
		target_circuit_id = 1,
		})
	
	c3.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = poles[3],
		source_circuit_id = 2,
		target_circuit_id = 1,
		})
	
	c2.connect_neighbour({
		wire = defines.wire_type.green,
		target_entity = c4,
		source_circuit_id = 2,
		target_circuit_id = 1,
		})
		
	c4.connect_neighbour({
		wire = defines.wire_type.red,
		target_entity = poles[4],
		source_circuit_id = 2,
		target_circuit_id = 1,
		})		
end

script.on_event(defines.events.on_tick, on_tick_handler) --subscribe ticker when train stops exist
