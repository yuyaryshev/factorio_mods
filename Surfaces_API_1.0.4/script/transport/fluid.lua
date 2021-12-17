local Assert = require('util.assert')

local FluidTransport = {}

function FluidTransport.update(portal)
    Assert.Portal(portal)

    local from_boxes = portal.from_entity.fluidbox
	local from_box = from_boxes[1]

	local to_boxes = portal.to_entity.fluidbox
	local to_box = to_boxes[1]

    local to_cap = to_boxes.get_capacity(1)

    if from_box ~= nil then
		if to_box == nil then
			if from_box.amount <= to_cap then
				from_boxes[1] = nil
				to_boxes[1] = from_box
			else
				from_box.amount = from_box.amount - to_cap
				from_boxes[1] = from_box
				from_box.amount = to_cap
				to_boxes[1] = from_box
			end
		elseif to_box.name == from_box.name then
			local total = from_box.amount + to_box.amount
			if total <= to_cap then
				from_boxes[1] = nil
				to_box.temperature = (from_box.amount*from_box.temperature + to_box.amount*to_box.temperature)/total
				to_box.amount = total
				to_boxes[1] = to_box
			else
				to_box.temperature = (to_box.amount*to_box.temperature + (to_cap-to_box.amount)*from_box.temperature)/to_cap
				to_box.amount = to_cap
				to_boxes[1] = to_box
				from_box.amount = total - to_cap
				from_boxes[1] = from_box
			end
		end
    end

    return portal.type_params.delay or 10
end

return FluidTransport
