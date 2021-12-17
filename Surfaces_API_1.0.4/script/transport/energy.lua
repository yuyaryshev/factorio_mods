local Assert = require('util.assert')

local EnergyTransport = {}

function EnergyTransport.update(portal)
    Assert.Portal(portal)

    local from = portal.from_entity
    local to = portal.to_entity

    local energy = from.energy + to.energy
	local ebs = to.electric_buffer_size

	if energy > ebs then
		to.energy = ebs
		from.energy = energy - ebs
	else
		to.energy = energy
		from.energy = 0
    end

    return portal.type_params.delay or 10
end

return EnergyTransport
