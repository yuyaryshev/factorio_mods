local Event = require('__stdlib__/stdlib/event/event')
local Globals = require('util.globals')
local Is = require('__stdlib__/stdlib/utils/is')
local Portal = require('script.portal')

local Camera = {}

local function load_globals()
end

local function load_tables()
end

local function reset_gui(player)
    local camera_frame = player.gui.top["surfaces_camera_frame"]

    if camera_frame ~= nil then
        camera_frame.destroy()
    end
end

local function setup_gui(player_index)
    local root = game.get_player(player_index).gui.top

    if root["surfaces_camera_frame"] == nil then
        local frame = root.add{
            type = "frame",
            name = "surfaces_camera_frame"
        }
        local camera = frame.add{
            type = "camera",
            name = "surfaces_camera",
            position = game.get_player(player_index).position,
            surface_index = 1,
            zoom = 0.5
        }
        camera.style.minimal_width = 400
        camera.style.minimal_height = 400
    end
end

local function get_camera_frame(player_index)
    setup_gui(player_index)
    local player = game.get_player(player_index)
    local camera_frame = player.gui.top["surfaces_camera_frame"]

    if camera_frame == nil then
        return
    end

    return camera_frame
end

local function update_portal_camera(player_index)
    local camera_frame = get_camera_frame(player_index)

    if camera_frame == nil then
        return
    end

    local player = game.get_player(player_index)
    local portal = player.selected and Portal.map[player.selected.unit_number] or nil

    if portal == nil then
        camera_frame.visible = false
        return
    end

    camera_frame.visible = true

    local camera = camera_frame["surfaces_camera"]

    camera.position = portal.to_entity.position
    camera.surface_index = portal.to_entity.surface.index
end

Event.on_init(function()
    load_globals()
    load_tables()
end).on_load(function()
    load_tables()
end).on_configuration_changed(function()
    load_globals()
    load_tables()

    for _, player in pairs (game.connected_players) do
        reset_gui(player)
    end
end).on_event(defines.events.on_selected_entity_changed, function (event)
    update_portal_camera(event.player_index)
end)
