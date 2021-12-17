local Assert = require('util.assert')

local LinkedBeltTransport = {}

function LinkedBeltTransport.init(portal)
    Assert.Portal(portal)
    portal.from_entity.linked_belt_type = "input"
    portal.to_entity.linked_belt_type = "output"
    portal.to_entity.rotate() -- Rotate the other entity 180 degrees, as it makes more sense
    portal.to_entity.rotate()
    portal.from_entity.connect_linked_belts(portal.to_entity)
end

return LinkedBeltTransport
