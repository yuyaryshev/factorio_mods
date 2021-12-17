--[[
	Stop stealing, stealing is bad!
	No seriously, feel free to look at this,
	if you are interested in making your own mods, you can take code from here if you wish.
	If you are going to just copy and paste code, please give credit in the forum or a readme file.
	Just add a "Code proudly stolen from AyrA" or something similar.
]]--

-- NOTE: Disabled for 0.13 as it is no longer needed.
-- We use some of these constants for the inventory and the event hookup
-- require "defines"

-- Configure stuff below

-- Add 4 iron ores so you can craft a pickaxe.
-- Mining iron ore is a PAIN without a pickaxe
local ADD_ORE=false

-- Add an iron pickaxe
local ADD_AXE=true

-- Give you back the furnace and burner drill to start with
local ADD_BASICS=false

-- Give steam engine instead of solar panel
local USE_STEAM=false

-- Gives the player a basic accumulator. This is used to bridge
-- the night and to allow faster crafting.
local ADD_ACCU=false

--add values as you need them.
local kit={
	{name="assembling-machine-3",count=1}
}

-- no more changes by you below (unless you know, what you do)

	table.insert(kit,{name="offshore-pump",count=1})
	table.insert(kit,{name="boiler",count=1})
	table.insert(kit,{name="steam-engine",count=1})
	table.insert(kit,{name="solar-panel",count=1})
	table.insert(kit,{name="big-electric-pole",count=1})
	table.insert(kit,{name="small-electric-pole",count=1})
	table.insert(kit,{name="burner-mining-drill",count=1})
	table.insert(kit,{name="stone-furnace",count=1})
	table.insert(kit,{name="small-factory",count=10})

--[[
>>>AAAMAA8AAAADAwYAAAAEAAAAY29hbAMDAgoAAABjb3BwZXItb3Jl
AwMCCQAAAGNydWRlLW9pbAMDAgoAAABlbmVteS1iYXNlAQAACAAAAGl
yb24tb3JlAwMCBQAAAHN0b25lAwMCq4L0sHYyAAD4aQAAAAAAAAAAAA
AFAEAlDj4=<<<
]]--

script.on_event(defines.events.on_player_created,function(param)
	--get the joined player. This makes the code, that follows shorter
	local p=game.players[param.player_index]
	
	if p.admin then
--		return
	end

	--clear all inventories automatically
	for i,v in pairs(defines.inventory) do
		--[[
			pcall prevents lua from crashing.
			If you are familiar with other languages,
			pcall is essentially this:

			try
			{
				your_function();
				return true;
			}
			catch
			{
				return false;
			}

			In other words, it returns false, if the call crashed.
			I use it, because there is no way of checking,
			if a player has a certain inventory.
			For example the trash slots are only available,
			if they have been researched.
			If a player joins before this research,
			which is true for the first player at least,
			then get_inventory(...) will crash instead of returning nil.

			Reference: http://www.lua.org/manual/5.1/manual.html#pdf-pcall
		]]--
		pcall(function()
			p.get_inventory(v).clear()
		end)
	end
	-- We add our items into the quickbar.
	local inv=p.get_inventory(defines.inventory.player_quickbar)
	-- Danymically add items from the 'kit' table
	for i,v in pairs(kit) do
		inv.insert(v)
	end
	-- If we give the player a pickaxe, we add it into the correct slot.
		p.get_inventory(defines.inventory.player_tools).insert({name="steel-axe",count=10})
end)

--[[

These functions were used for debugging only,
but are still here if you need to debug.
They are taken from http://lua-users.org/wiki/TableUtils

function table.val_to_str(v)
	if "string"==type(v) then
		v=string.gsub(v,"\n","\\n")
		if string.match(string.gsub(v,"[^'\"]",""),'^"+$') then
			return "'" .. v .. "'"
		end
		return '"' .. string.gsub(v,'"','\\"') .. '"'
	else
		return "table"==type(v) and table.tostring(v) or tostring(v)
	end
end

function table.key_to_str(k)
	if "string"==type(k) and string.match(k,"^[_%a][_%a%d]*$") then
		return k
	else
		return "[" .. table.val_to_str(k) .. "]"
	end
end

function table.tostring(tbl)
	local result,done={},{}
	for k,v in ipairs(tbl) do
		table.insert(result,table.val_to_str(v))
		done[k]=true
	end
	for k,v in pairs(tbl) do
		if not done[k] then
			table.insert(result,table.key_to_str(k) .. "=" .. table.val_to_str(v))
		end
	end
	return "{" .. table.concat(result,",") .. "}"
end
]]--
