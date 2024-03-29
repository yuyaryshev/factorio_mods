
--Wagon Inventory detector (no loop, repeat, post)
if (condition.value) then output:clear() for _,entity in pairs(entities) do ; if entity.name == "cargo-wagon" then inv = entity.get_inventory(1); for name,count in pairs(inv.get_contents()) do output:set_count("item",name,count); end end end elseif (not condition.value) then output:clear() end

--locomotive-detector (no loop, repeat, post)
if (condition.value) then output:clear() for _,entity in pairs(entities) do if entity.name == "diesel-locomotive" then output:set_count("item","diesel-locomotive",1) end end else output:clear() end 

--locomotive pause(loop, repeat, post)
if entity.name == "diesel-locomotive" then entity.train.manual_mode = condition.value end

--rocket launch (loop, repeat)
if (entity.name == "rocket-silo") then player.print("lift off!"); entity.launch_rocket() end

--Power detector (no loop, repeat, post)
if (condition.value) then output:clear() for _,entity in pairs(entities) do if entity.type == "accumulator" then output:set_count("virtual","signal-E",math.floor(entity.energy/1000 + 0.5)) end end elseif not condition.value then output:clear() end

--lock the gate - signal (no loop, repeat, post)
output:clear(); for _,entity in pairs(entities) do if entity.name == "rail-signal"  and entity.signal_state == 1 then output:set_count("item","rail-signal",1) end end

-- lock the gate- gate (loop, repeat, post)
if entity.name == "gate" then entity.active = not condition.value end

-- floating text (no loop, repeat, post)
if condition.value then banner("Hello World", output.entity.position, {r=0,g=0,b=1},player) end
