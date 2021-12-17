local Assert = require('util.assert')

local ItemChestTransport = {}

function ItemChestTransport.update(portal)
    Assert.Portal(portal)

    local source_inv = portal.from_entity.get_inventory(portal.type_params.source_inventory_type or defines.inventory.chest)
	local target_inv = portal.to_entity.get_inventory(portal.type_params.target_inventory_type or defines.inventory.chest)
    local source_contents = source_inv.get_contents()

    local start_rate = portal.type_params.rate
    local rate = start_rate

    for item, count in pairs(source_contents) do
        local new_count = count

        if start_rate then
            if rate > 0 then
                count = math.min(rate, count)
                rate = rate - new_count
            else
                break
            end
        end

        if count > 0 then
            local target_count = target_inv.insert{name = item, count = count}
            if target_count > 0 then
                source_inv.remove{name = item, count = target_count}
            end
        end
    end

    return portal.type_params.delay or 60
end

return ItemChestTransport
