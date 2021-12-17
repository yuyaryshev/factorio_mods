local Is = require('__stdlib__/stdlib/utils/is')
local Assert = require('util.assert')
local Position = require('__stdlib__/stdlib/area/position')

local EntityTransport = {}

function EntityTransport.teleport(player, surface, position)
    Assert.Surface(surface)
    position = Position.load(position)
    Is.Assert.Position(position)

    surface = type(surface) == "string" and game.surfaces[surface] or surface
    local new_position = surface.find_non_colliding_position(player.character.prototype.name, position, 100, 1)

    if new_position then
        player.teleport(new_position, surface)
        return true
    end
    return false
end

function EntityTransport.player_move(portal, player)
    Assert.Portal(portal)
    Is.Assert(portal.type == "entity")

    local entity = portal.from_entity
    local portal_pos = Position.load(entity.position)
    local player_pos = Position.load(player.position)

    if Position.distance(portal_pos, player_pos) <= 1 then
        global.recent_teleports[player.name] = game.tick -- Only reset the recent_teleports counter when we teleport the player
        EntityTransport.teleport(player, portal.to_entity.surface, portal.to_entity.position)
    end

end

return EntityTransport
