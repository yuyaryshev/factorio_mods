require("config")

local bcombs = {}

belt_polling_rate = math.max(math.min(belt_polling_rate,60),1)

local polling_cycles = math.floor(60/belt_polling_rate)

---[[
traversal_step = 0
local function print(...)
  return game.player.print(step.. ' ' .. ...)
end
--]]

--swap comment to toggle debug prints
local function debug() end
-- local debug = print


local function onLoad()
  if global.belt_combinators==nil then
    --unlock if needed; we're relying on a vanilla tech that may have already been researched.
    for _,force in pairs(game.forces) do
      force.reset_recipes()
      force.reset_technologies()

      local techs=force.technologies
      local recipes=force.recipes
      if techs["circuit-network"].researched then
        recipes["belt-combinator"].enabled=true
      end
    end

    global.belt_combinators={}
  end

  bcombs=global.belt_combinators
end

local function pos2s(pos)
  if pos.x then
    return pos.x..','..pos.y
  elseif pos[1] then
    return pos[1]..','..pos[2]
  end
  return ''
end

local function lines2s(lines)
  out = ''
  for k,v in ipairs(lines) do
    out = out .. ',' .. k .. '=' .. (v and 'yes' or 'no')
  end
  return out
end

local function any(t)
  for _,v in pairs(t) do
    if v then return true end
  end
  return false
end

line_counts = {["transport-belt"]=2,["transport-belt-to-ground"]=4,["splitter"]=8}

-- fake belts are used to prime the belt-following process starting at a belt combinator
local function fake_belt(entity,dir) 
  return {
    name="fake-transport-belt",
    position={x=entity.position.x,y=entity.position.y},
    direction=dir,
    type="transport-belt",
    get_transport_line=function(_) return nil end,
    surface=entity.surface,
    valid=true
  }
end

local function rotate_posd(posd,rotation)
  local x,y,d = posd[1],posd[2],posd[3]
  if     rotation==defines.direction.south then
    d=(d+4)%8
    x = -x
    y = -y
  elseif rotation==defines.direction.east then
    d=(d+2)%8
    t = x
    x = -y
    y = t
  elseif rotation==defines.direction.west then
    d=(d+6)%8
    t = x
    x = y
    y = -t
  end
  return x,y,d
end

local function rotate_pos(x,y,rotation)
  return rotate_posd({x,y,0},rotation)
end

-- starting_entity is a belt(-like) entity, or a belt combinator
-- lines are which side to follow, array of 2-8 booleans
local function walk_belt_lines(starting_entity,lines)
  if not starting_entity or not starting_entity.valid then return {} end
  debug('walk_belt_lines '..starting_entity.name..' '..pos2s(starting_entity.position)..' '..lines2s(lines))
  local queue = {}
  if starting_entity.name=="belt-combinator" then
    queue = {
      {entity=fake_belt(starting_entity,defines.direction.north),lines={true,true}},
      {entity=fake_belt(starting_entity,defines.direction.south),lines={true,true}},
      {entity=fake_belt(starting_entity,defines.direction.east ),lines={true,true}},
      {entity=fake_belt(starting_entity,defines.direction.west ),lines={true,true}},
    }
  else
    queue = {{entity=starting_entity,lines=lines}}
  end
  local done = {} -- table of y coords mapped to tables of x coords mapped to arrays of lines
  local result = {} -- list of LuaTransportLine to return
  traversal_step = 0
  while traversal_step<9999 and #queue>0 do
    traversal_step=traversal_step+1 -- for debug output and endless loop bailout
    local entity = queue[#queue].entity
    local lines = queue[#queue].lines -- lines to check
    table.remove(queue,#queue)
    if entity and entity.valid then
      debug(#queue .. ' dequeue '..entity.name..' '..pos2s(entity.position)..' '..lines2s(lines)..' '..entity.direction)
      local lines_to_proceed = {}
      local num_lines = line_counts[entity.type]
      if num_lines then
        local num_incoming_lines = num_lines<3 and num_lines or num_lines/2
        for l=1,num_incoming_lines do
          lines_to_proceed[l] = false
          if lines[l] then
            if not done[entity.position.x] then done[entity.position.x] = {} end
            if not done[entity.position.x][entity.position.y] then done[entity.position.x][entity.position.y] = {} end
            if not done[entity.position.x][entity.position.y][l] or
              entity.position.x == starting_entity.position.x and
              entity.position.y == starting_entity.position.y
             then
              lines_to_check = {l} -- the incoming line
              if num_lines>2 then
                lines_to_check[#lines_to_check+1] = l+num_lines/2 -- outgoing line
                if num_lines>4 then
                  lines_to_check[#lines_to_check+1] = (l+1)%4+1+num_lines/2 -- other side of splitter
                end
              end
              for _,l in pairs(lines_to_check) do
                done[entity.position.x][entity.position.y][l] = true
                local tl = entity.get_transport_line(l)
                if tl then result[#result+1] = tl end
                lines_to_proceed[l] = true
              end
            end
          end
        end
        if any(lines_to_proceed) then
          if entity.type=="transport-belt-to-ground" and 
            entity.belt_to_ground_type=="input" and
            entity.neighbours then
            -- queue up the other end of the underground belt
            local ls = {false,false}
            -- 
            if lines_to_proceed[3] then ls[1] = true end
            if lines_to_proceed[4] then ls[2] = true end
            queue[#queue+1] = {entity=entity.neighbours[1],lines=ls}
          else
            local pdls = {}
            if entity.type=="transport-belt" or entity.type=="transport-belt-to-ground" then
              -- prepare to look ahead of a single tile
              pdls[1] = {pos=entity.position,dir=entity.direction,lines={lines_to_proceed[1],lines_to_proceed[2]}}
            else -- splitter
              local pos
              local dx,dy = rotate_pos(-0.5,0,dir)
              pos = {
                {x=entity.position.x+dx,y=entity.position.y+dy},
                {x=entity.position.x-dx,y=entity.position.y-dy}
              }
              local ls = {{false,false},{false,false}}
              if lines_to_proceed[5] then ls[1][1] = true end
              if lines_to_proceed[6] then ls[1][2] = true end
              if lines_to_proceed[7] then ls[2][1] = true end
              if lines_to_proceed[8] then ls[2][2] = true end
              pdls[1] = {pos=pos[1],dir=entity.direction,lines=ls[1]}
              pdls[2] = {pos=pos[2],dir=entity.direction,lines=ls[2]}
            end

            for _,source in pairs(pdls) do
              local pos = source.pos
              local dir = source.dir
              local lines = source.lines
              -- debug('pdls '..pos.x..','..pos.y..' '..dir..' '..lines2s(lines))
              local dx,dy = rotate_pos(0,-1,dir)
              local tpos = {pos.x+dx,pos.y+dy}
              -- debug("tpos "..pos2s(tpos))
              local entities = game.get_surface(entity.surface.index).find_entities({tpos,tpos})
              local target = nil
              for _,candidate in pairs(entities) do
                if candidate ~= entity_to_ignore then
                  if candidate.type == "transport-belt" or
                    candidate.type == "transport-belt-to-ground" or
                    candidate.type == "splitter" then
                    target = candidate
                    break
                  end
                end
              end
              if target then
                -- nothing accepts connections from the front
                if not (math.abs(target.direction-dir)==4) then
                  -- underground belt outputs don't accept connections from behind
                  if not (target.type=="transport-belt-to-ground" and target.belt_to_ground_type=="output" and target.direction==dir) then
                    -- splitters don't accept connections from the side
                    if not (target.type=="splitter" and target.direction~=dir) then
                      if target.type~="splitter" then
                        -- belts and underground belts behave similarly
                        if target.direction==dir then
                          queue[#queue+1] = {entity=target,lines=lines}
                        else
                          local turn = false
                          if target.type=='transport-belt' and entity.name~="fake-transport-belt" then
                            local belt_behind_target = false
                            -- find a belt-like entity behind the target or on the far side
                            local tpxd,tpyd=rotate_pos(0,1,target.direction)
                            local pxd, pyd =rotate_pos(0,-2,dir)
                            local bpd = {
                              {pos={target.position.x+tpxd,target.position.y+tpyd},dir=target.direction},
                              {pos={pos.x+pxd,pos.y+pyd},dir=(dir+4)%8}
                            }
                            for _,bpos in pairs(bpd) do
                              -- debug("checking for belt-behind at "..pos2s(bpos.pos).." dir="..bpos.dir)
                              local entities = game.get_surface(entity.surface.index).find_entities({bpos.pos,bpos.pos})
                              for _,candidate in pairs(entities) do
                                if candidate ~= entity_to_ignore then
                                  -- debug("candidate "..candidate.type.." ".."dir="..candidate.direction)
                                  if candidate.type == "transport-belt" or
                                    candidate.type == "transport-belt-to-ground" or
                                    candidate.type == "splitter" then
                                    if candidate.direction == bpos.dir then
                                      belt_behind_target = true
                                    end
                                    break
                                  end
                                end
                              end
                              if belt_behind_target then break end
                            end
                            if not belt_behind_target then
                              -- belt turn
                              queue[#queue+1] = {entity=target,lines=lines}
                              turn = true
                            end
                          end
                          if not turn then
                            if (target.direction-dir+8)%8==2 then
                              -- right sideload
                              if target.type=="transport-belt" or 
                                (target.belt_to_ground_type=="output" and lines[2]) or
                                (target.belt_to_ground_type=="input"  and lines[1]) then
                                queue[#queue+1] = {entity=target,lines={false,true}}
                              end
                            else
                              -- left sideload
                              if target.type=="transport-belt" or 
                                (target.belt_to_ground_type=="output" and lines[1]) or
                                (target.belt_to_ground_type=="input"  and lines[2]) then
                                queue[#queue+1] = {entity=target,lines={true,false}}
                              end
                            end
                          end
                        end
                      else
                        -- splitters are special
                        if dir==defines.direction.north and target.position.x>pos.x or
                           dir==defines.direction.south and target.position.x<pos.x or
                           dir==defines.direction.east  and target.position.y>pos.y or
                           dir==defines.direction.west  and target.position.y<pos.y then
                           -- connected to left side of splitter
                           queue[#queue+1] = {entity=target,lines={lines[1],lines[2]}}
                         else
                           -- connected to right side of splitter
                           queue[#queue+1] = {entity=target,lines={false,false,lines[1],lines[2]}}
                         end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  return result
end

local function onTick(event)
  -- TODO cache belt walking results
  -- TODO update periodically or on belt modification
  if event.tick%polling_cycles == 0 then
    local toRemove = {}
    for i,bc in pairs(bcombs) do
      if bc.comb.valid then
	  
	  
local params={enabled=true,parameters={
  {index=1,count=10,signal={name="signal-R",type="virtual"}}
}}

--bc.comb.parameters  
		  bc.comb.set_circuit_condition(condition,{parameters=params})
	  
--	    local net1 = bc.comb.get_circuit_network(defines.wire_type.red)
--		if net1 ~= nil then
--		  local params = net1.parameters
--		  local item_count = {}
--		  for _,tl in pairs(walk_belt_lines(bc.comb,{})) do
--		    for item,count in pairs(tl.get_contents()) do
--		  	item_count[item] = item_count[item] and item_count[item]+count or count
--		    end
--		  end
--		  for i=1,15 do
--		    if params[i].signal.name and params[i].signal.type=="item" then
--		  	local c = item_count[params[i].signal.name] or 0
--		  	params[i].count=c
--		    else
--		  	params[i].count=0
--		    end
--		  end
--		  local condition = defines.circuitconditionindex.constant_combinator
--		  bc.comb.set_circuit_condition(condition,{parameters=params})
--        else
--        	table.insert(toRemove, i)
--        end
      else
        table.insert(toRemove, i)
      end
    end
    for _, k in pairs(toRemove) do
      table.remove(bcombs, k)
    end
  end
end

local function onPlaceEntity(event)
  if event.created_entity.name=="belt-combinator" then
    table.insert(bcombs,{comb=event.created_entity})
  end
end

local function onRemoveEntity(event)
  if event.entity.name=="belt-combinator" then
    for k,v in pairs(bcombs) do
      if v.comb==event.entity then
        table.remove(bcombs, k)
        break
      end
    end
  end
end

script.on_init(onLoad)
script.on_configuration_changed(onLoad)
script.on_load(onLoad)

script.on_event(defines.events.on_built_entity, onPlaceEntity)
script.on_event(defines.events.on_robot_built_entity, onPlaceEntity)

script.on_event(defines.events.on_preplayer_mined_item, onRemoveEntity)
script.on_event(defines.events.on_robot_pre_mined, onRemoveEntity)
script.on_event(defines.events.on_entity_died, onRemoveEntity)

script.on_event(defines.events.on_tick, onTick)
