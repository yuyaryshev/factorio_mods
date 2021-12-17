local Surfaces = require('script.surfaces')
require('script.transport')
require('script.camera')
local EntityTransport = require('script.transport.entity')

require('script.interface')()

-- Testing stuff
commands.add_command("surface_down", "", function(t)
    local player = game.players[t.player_index]
    local position = player.position
    local layer = Surfaces.get_index(player.surface)
    local surface = Surfaces.request_surface("nauvis", layer - 1, position);
    if surface then
        print("Surface ready: "..layer)
        local result = EntityTransport.teleport(player, surface, position)
        if result then
            print("yay")
        else
            print("nay")
        end
    end
end)

commands.add_command("surface_up", "", function(t)
    local player = game.players[t.player_index]
    local position = player.position
    local layer = Surfaces.get_index(player.surface)
    local surface = Surfaces.request_surface("nauvis", layer + 1, position);
    if surface then
        print("Surface ready: "..layer)
        local result = EntityTransport.teleport(player, surface, position)
        if result then
            print("yay")
        else
            print("nay")
        end
    end
end)

