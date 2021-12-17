local Event = require('__stdlib__/stdlib/event/event')
local Globals = require('util.globals')
local Is = require('__stdlib__/stdlib/utils/is')

local Transport = {
    ["linked_belt"] = require('script.transport.linked_belt'),
    ["entity"] = require('script.transport.entity'),
    ["itemchest"] = require('script.transport.itemchest'),
    ["energy"] = require('script.transport.energy'),
    ["fluid"] = require('script.transport.fluid'),
}

local function load_globals()
    global.update_queue = global.update_queue or {}
    global.transport_init_queue = global.transport_init_queue or {}
    for i = 1, Globals.CYCLIC_BUFFER_SIZE do
		global.update_queue[i] = global.update_queue[i] or {}
    end
    global.recent_teleports = global.recent_teleports or {}
end

local function load_tables()
end

Event.on_init(function()
    load_globals()
    load_tables()
end).on_load(function()
    load_tables()
end).on_configuration_changed(function()
    load_globals()
    load_tables()
end).on_event(defines.events.on_player_changed_position, function(event)
    local player = game.players[event.player_index]

    if (not global.recent_teleports[player.name])
        or (global.recent_teleports[player.name] + 40 < game.tick) then
        for _, portal in pairs(global.pair_map) do
            -- Only relevant for portals on the same surface
            if portal.from_entity.surface == player.surface then
                if Is.Callable(Transport[portal.type].player_move) then
                    Transport[portal.type].player_move(portal, player)
                end
            end
        end
    end
end).on_event(defines.events.on_tick, function()
    -- Based on Factorissimo2 code
    local current_pos = game.tick % Globals.CYCLIC_BUFFER_SIZE + 1
    local current_slot = global.update_queue[current_pos] or {}

    global.update_queue[current_pos] = {}

    for _, portal in pairs(current_slot) do
        if not Transport[portal.type] then break end
        if not Is.Valid(portal.from_entity) or not Is.Valid(portal.to_entity) then break end

        local delay = nil

        if Is.Callable(Transport[portal.type].update) then
            delay = Transport[portal.type].update(portal)
        end

        -- If there is no delay, we won't call update again for this portal
        if delay then
            -- Reinsert connection after delay.
            -- Not checking for inappropriate delays, so keep your delays civil
            local queue_pos = (current_pos + delay - 1) % Globals.CYCLIC_BUFFER_SIZE + 1
            local new_slot = global.update_queue[queue_pos]
            new_slot[1 + #new_slot] = portal
        end
    end

    for _, portal in pairs(global.transport_init_queue) do
        if Is.Callable(Transport[portal.type].init) then
            Transport[portal.type].init(portal)
        end
    end

    global.transport_init_queue = {}
end)

return Transport
