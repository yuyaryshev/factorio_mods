local function round(x, n)
	n = math.pow(10, n or 0)
	x = x * n
	if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
	return x / n
end
		
local function isLuaList(arg)
    if type(arg) == "table" then
        for i,_ in pairs(arg) do
            return type(i) == "number"
        end
    end
    return false
end

local function inserterSimplePutBack(stack, entity)
	if stack.valid then
		if entity.type == "container" or entity.type == "logistic-container" then
			stack.count = stack.count - entity.insert(stack)
--			if new_stack_count then
--				stack.count = new_stack_count			
--				local entityInv = entity.get_inventory(1)
--				local entityInvBar = entityInv.getbar()
--				entityInv.setbar()
--				stack.count = stack.count - entity.insert(stack)
--				entityInv.setbar(entityInvBar)
--			end
		elseif entity.type == "assembling-machine" or entity.type == "furnace" then
			stack.count = stack.count - entity.get_inventory(3).insert(stack)
		elseif entity.type == "mining-drill" or entity.type == "cargo-wagon" then
			stack.count = stack.count - entity.get_inventory(1).insert(stack)
		elseif entity.type == "car" or entity.type == "lab" then
			stack.count = stack.count - entity.get_inventory(2).insert(stack)
		end
    end
end

local function inserterPutBack(inserter, item)
    if isLuaList(inserter) then
        for _, entity in ipairs(inserter) do
            inserterPutBack(entity, item)
        end
    end
    local oldSrc = inserter.pickup_target
    if oldSrc == nil then return end
    if inserter.held_stack.valid_for_read then
        if oldSrc.to_be_deconstructed(inserter.force) and inserter.to_be_deconstructed(inserter.force) then return end
        inserterSimplePutBack(inserter.held_stack, oldSrc)
    end
    if item then
        if inserter.drop_target ~= nil then return end
        local px = inserter.drop_position.x
        local py = inserter.drop_position.y
        local items = inserter.surface.find_entities_filtered{area = {{px - 0.1, py - 0.1},{px + 0.1,py + 0.1}}}
        for _,pick in pairs(items) do
            if pick.type ~= "item-entity" then
                return
            end
        end
        for _,pick in pairs(items) do
            inserterSimplePutBack(pick.stack, oldSrc)
        end
    end
end

--return list of inserters around wagon
local function getInsertersAroundWagon(wagon)
    local inDirection = round(wagon.orientation, 3) % 0.5
    local wagonArea = {}
    local px = round(wagon.position.x, 2)
    local py = round(wagon.position.y, 2)
    if inDirection == 0.25 then
        wagonArea = {
            {
                px - 3 - 4,
                py - 1 - 3
            },
            {
                px + 3 + 4,
                py + 1 + 3
            }
        }
		return wagon.surface.find_entities_filtered{area=wagonArea, type = "inserter"}
    elseif inDirection == 0 then
        wagonArea = {
            {
                px - 1 - 3,
                py - 3 + 4
            },
            {
                px + 1 + 3,
                py + 3 + 4
            }
        }
		return wagon.surface.find_entities_filtered{area=wagonArea, type = "inserter"}
    end
	return {}
end

function trainInsertersPutBack(train)
    for _, wagon in pairs(train.cargo_wagons) do
        inserterPutBack(getInsertersAroundWagon(wagon))
    end
end

