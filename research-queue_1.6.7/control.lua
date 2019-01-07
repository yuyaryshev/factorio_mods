require "story"
require("functions.help_functions")
require("functions.update_queue")
require("functions.draw_grid")
require("functions.initialise")
local mod_gui = require("mod-gui")

script.on_configuration_changed(function(event)
	if event.mod_changes ~= nil and event.mod_changes["research-queue"] ~= nil then
		init()
		for index, _ in pairs(game.players) do
			player_init(index)
			local top = mod_gui.get_button_flow(game.players[index])
            top.research_Q.caption = "RQ"
		end
	end
	for name,force in pairs(game.forces) do
		if global.researchQ[name] ~= nil and #global.researchQ[name] > 0 then check_queue(force) end
	end
	
end)

script.on_init(function()
	init()
end)

script.on_event(defines.events.on_gui_closed, function(event)
    local gui_type = event.gui_type
    local element = event.element
    local player = game.players[event.player_index]
    if (gui_type == defines.gui_type.custom) and element then
        local element_name = string.match(element.name, "Q")
        if element_name then
            player.gui.center.Q.destroy()
            player.play_sound{path = "utility/gui_click"}
        end
    end
end)

script.on_event(defines.events.on_gui_text_changed, function(event)
    if event.element.name == "rq-text-filter" then
		local player = game.players[event.player_index]
		local force = player.force
		
		global.text_filter = event.element.text
		global.offset_tech[player.index] = 0
		drawGrid(force)
	end
end)

script.on_event(defines.events.on_gui_checked_state_changed, function(event)
	local player = game.players[event.player_index]
	local force = player.force
	global.offset_tech[player.index] = 0
    if string.find(event.element.name, "rq-science", 1, true) == 1 then
		local tool = string.gsub(event.element.name, "rq%-science", "")
		global.science[tool][player.index] = not global.science[tool][player.index]
		drawGrid(force)
		
	elseif event.element.name == "rqtext" then
		global.showIcon[player.index] = not global.showIcon[player.index]
		drawGrid(force)
		
	elseif event.element.name == "rqscience" then
		global.showResearched[player.index] = not global.showResearched[player.index]
		drawGrid(force)
		
	elseif event.element.name == "rq-bobsmodules" then
		global.showBobsmodules[player.index] = not global.showBobsmodules[player.index]
		for name, science in pairs(global.science) do
			if global.bobsmodules[name] then science[player.index] = global.showBobsmodules[player.index] end
		end
		drawGrid(force)
		
	elseif event.element.name == "rq-bobsaliens" then
		global.showBobsaliens[player.index] = not global.showBobsaliens[player.index]
		for name, science in pairs(global.science) do
			if global.bobsaliens[name] then science[player.index] = global.showBobsaliens[player.index] end
		end
		drawGrid(force)
	end
end)

function toggle_gui_window(event)
	local player = game.players[event.player_index]
	local force = player.force

	if player.gui.center.Q then
		player.gui.center.Q.destroy()
		global.offset_tech[player.index] = 0
		global.offset_tech[player.index] = 0
		global.showIcon[player.index] = true
	else
		local Q = player.gui.center.add{type = "flow", name = "Q", style = "rq-flow"}
		updateQ(force)
		drawGrid(force)
	end
end

script.on_event(defines.events.on_gui_click, function(event)
	local player = game.players[event.player_index]
	local force = player.force
	
    if event.element.name == "rq-text-filter" and event.button == defines.mouse_button_type.right then
		local player = game.players[event.player_index]
		local force = player.force
		global.text_filter = ""
		global.offset_tech[player.index] = 0
		drawGrid(force)
	elseif event.element.name == "research_Q" then
		toggle_gui_window(event)
	elseif string.find(event.element.name, "rq-add", 1, true) == 1 then
		local tech = string.gsub(event.element.name, "rq%-add", "")
		add_research(force, tech)
		if not force.current_research and #global.researchQ[force.name] > 0 then
			force.current_research = global.researchQ[force.name][1]
		end
		updateQ(force)
		drawGrid(force)
		
	elseif string.find(event.element.name, "rqcancelbutton", 1, true) == 1 then
		local tech = string.gsub(event.element.name, "rqcancelbutton", "")
		remove_research(force, tech)	
		if force.current_research.name == tech and #global.researchQ[force.name] > 0 then
			force.current_research = global.researchQ[force.name][1]
		end
		updateQ(force)
		drawGrid(force)
		
	elseif string.find(event.element.name, "rqupbutton", 1, true) == 1 then
		local tech = string.gsub(event.element.name, "rqupbutton", "")
		if event.button ~= defines.mouse_button_type.left or event.control then
			up(player, tech,999999)
		elseif event.alt or event.shift or event.control then
			up(player, tech,5)
		else
			up(player, tech,1)
		end
		updateQ(force)
		
	elseif string.find(event.element.name, "rqdownbutton", 1, true) == 1 then
		local tech = string.gsub(event.element.name, "rqdownbutton", "")
		if event.button ~= defines.mouse_button_type.left or event.control then
			down(force, tech,999999)
		elseif event.alt or event.shift or event.control then
			down(force, tech,5)
		else
			down(force, tech,1)
		end		
		updateQ(force)
	
	elseif event.element.name == "rqscrollqueueup" then
		global.offset_queue[player.index] = global.offset_queue[player.index] -1
		updateQ(force)
		
	elseif event.element.name == "rqscrollqueuedown" then
		global.offset_queue[player.index] = global.offset_queue[player.index] +1
		updateQ(force)	
			
	elseif event.element.name == "rqextend-button" then
		global.offset_tech[player.index] = 0
		global.showExtended[player.index] = not global.showExtended[player.index]
		if not global.showExtended[player.index] then global.offset_tech[player.index] = 0 end
		for name, science in pairs(global.science) do
			if global.bobsmodules[name] then science[player.index] = global.showBobsmodules[player.index] end
			if global.bobsaliens[name] then science[player.index] = global.showBobsaliens[player.index] end
		end
		drawGrid(force)
		
	elseif event.element.name == "rqscrolltechup" then
		global.offset_tech[player.index] = global.offset_tech[player.index] -1
		drawGrid(force)
		
	elseif event.element.name == "rqscrolltechdown" then
		global.offset_tech[player.index] = global.offset_tech[player.index] +1
		drawGrid(force)	
		
	elseif event.element.name == "rq-overwrite-yes" then
		force.current_research = global.researchQ[force.name][1]
		if player.gui.center.warning then player.gui.center.warning.destroy() end
		if not player.gui.center.Q then player.gui.center.add{type = "flow", name = "Q", style = "rq-flow"} end
		updateQ(force)
		drawGrid(force)
		
	elseif event.element.name == "rq-overwrite-no" then
		if player.gui.center.warning then player.gui.center.warning.destroy() end
		if not player.gui.center.Q then player.gui.center.add{type = "flow", name = "Q", style = "rq-flow"} end
		updateQ(force)
		drawGrid(force)
		
	end
end)

script.on_event(defines.events.on_research_finished, function(event)
	
	if global.researchQ == nil then init() end
	
	for index,player in pairs(event.research.force.players) do
		player.print("Research finished:")
		player.print(event.research.localised_name)
	end
	
	if #global.researchQ[event.research.force.name] > 0 then
		for i, tech in ipairs(global.researchQ[event.research.force.name]) do
			if tech == event.research.name or game.forces[event.research.force.name].technologies[tech].researched then
				table.remove(global.researchQ[event.research.force.name], i)
			end
		end
	end
	if #global.researchQ[event.research.force.name] > 0 then		
		game.forces[event.research.force.name].current_research = global.researchQ[event.research.force.name][1]
	else
        for _, player in pairs(event.research.force.players) do
            if player.mod_settings["research-queue_popup-on-queue-finish"].value then
                if not player.gui.center.Q then
                    local Q = player.gui.center.add{type = "flow", name = "Q", style = "rq-flow"}
                    updateQ(player.force)
                    drawGrid(player.force)
                end
            end
        end
    end
	for index, player in pairs(event.research.force.players) do
     if global.offset_queue[index] ~= nil then --Check for nil
      if global.offset_queue[index] > 0 then global.offset_queue[index] = global.offset_queue[index] -1 end
      if player.gui.center.Q then 
         updateQ(player.force)
         drawGrid(player.force) 
      end
     end
   end
end)

script.on_event(defines.events.on_player_created, function(event)
	player_init(event.player_index)
end)

script.on_event(defines.events.on_force_created, function(event)
	if global.researchQ == nil then init() end
	if global.researchQ[event.force.name] == nil then global.researchQ[event.force.name] = {} end
	if global.labs[event.force.name] == nil then global.labs[event.force.name] = find_all_entities({type = "lab", force = event.force}) end
end)

script.on_event(defines.events.on_built_entity, function(event)
	if event.created_entity.type == "lab" then
		table.insert(global.labs[event.created_entity.force.name],event.created_entity)
	end
end)

script.on_event(defines.events.on_entity_died, function(event)
	if event.entity.type == "lab" then
		for key,lab in pairs(global.labs[event.entity.force.name]) do
			if lab == event.entity then table.remove(global.labs[event.entity.force.name],key) end
		end
	end
end)

script.on_event(defines.events.on_pre_player_mined_item, function(event)
	if event.entity.type == "lab" then
		for key,lab in pairs(global.labs[event.entity.force.name]) do
			if lab == event.entity then table.remove(global.labs[event.entity.force.name],key) end
		end
	end
end)

script.on_event(defines.events.on_robot_pre_mined, function(event)
	if event.entity.type == "lab" then
		for key,lab in pairs(global.labs[event.entity.force.name]) do
			if lab == event.entity then table.remove(global.labs[event.entity.force.name],key) end
		end
	end
end)

script.on_event(defines.events.on_tick, function(event)
	if event.tick % 60 == 0 then
		for index,player in pairs(game.players) do
			if player.gui.center.Q then updateQ(player.force) end
		end
	end
end)

script.on_event("open-research-queue", function(event)
	toggle_gui_window(event)
end)