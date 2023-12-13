local awful      = require("awful")
local wibox      = require("wibox")
local beautiful  = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi
local colors     = require('widgets.control.module.colors')
local gears      = require('gears')
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/'

local function recolorImage(image, color)
    return gears.color.recolor_image(image, color)
end

local function colorize_text(fg, txt)
    return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

local icon_status = {
    wifi_on = recolorImage(asset_path .. 'wifi/on.svg', colors.fg_normal),
    wifi_off = recolorImage(asset_path .. 'wifi/off.svg', colors.fg_normal),
    bluetooth_on = recolorImage(asset_path .. 'bluetooth/on.svg', colors.fg_normal),
    bluetooth_off = recolorImage(asset_path .. 'bluetooth/off.svg', colors.fg_normal),
    microphone_on = recolorImage(asset_path .. 'microphone/on.svg', colors.fg_normal),
    microphone_off = recolorImage(asset_path .. 'microphone/off.svg', colors.fg_normal),
    volume_on = recolorImage(asset_path .. 'volume/on.svg', colors.fg_normal),
    volume_off = recolorImage(asset_path .. 'volume/off.svg', colors.fg_normal)
}

local createButton = function(icon, name, labelConnected, action)
    local widget = wibox.widget {
        {
            {
                {

                    {
                        margins = { top = dpi(5), bottom = dpi(5) },
                        widget  = wibox.container.margin,
                        {
                            image  = icon,
                            id     = "icon",
                            widget = wibox.widget.imagebox
                        },
                    },
                    {
                        {
                            markup = colorize_text(colors.bg_normal, name),
                            id     = "name",
                            font   = beautiful.font .. "Extra Bold",
                            widget = wibox.widget.textbox,
                        },
                        {
                            markup = labelConnected,
                            id     = "label",
                            font   = beautiful.font,
                            widget = wibox.widget.textbox,
                        },
                        layout = wibox.layout.fixed.vertical,
                        spacing = dpi(0)
                    },
                    layout = wibox.layout.fixed.horizontal,
                    spacing = dpi(10),
                },
                layout = wibox.layout.align.horizontal,
            },
            widget  = wibox.container.margin,
            margins = { top = dpi(15), bottom = dpi(15), left = dpi(20), right = dpi(20) }
        },
        id            = "back",
        bg            = colors.bg_light,
        forced_width  = dpi(200),
        forced_height = dpi(70),
        shape         = function(c, w, h)
            gears.shape.rounded_rect(c, w, h, dpi(15))
        end,
        widget        = wibox.container.background,
        buttons       = {
            awful.button({}, 1, action)
        }
    }

    return widget
end

local wifi = createButton(icon_status.wifi_on, 'Wi-fi', 'On', function() awesome.emit_signal('network::toggle') end)
local bluetooth = createButton(icon_status.bluetooth_on, 'Bluetooth', 'On',
    function() awesome.emit_signal('bluetooth::toggle') end)
local microphone = createButton(icon_status.microphone_on, 'Microphone', 'On',
    function() awesome.emit_signal('microphone::mute') end)
local volume = createButton(icon_status.volume_on, 'Volume', 'On', function() awesome.emit_signal('volume::mute') end)

local function updateStatusWidget(widget, is_enabled, icon_on, labelConnected, icon_off, labelDisconnected, name)
    if is_enabled then
        widget:get_children_by_id("icon")[1].image   = recolorImage(icon_on, colors.bg_normal)
        widget:get_children_by_id("name")[1].markup  = colorize_text(colors.bg_normal, name)
        widget:get_children_by_id("label")[1].markup = colorize_text(colors.bg_normal, labelConnected)
        widget:get_children_by_id("back")[1].bg      = colors.blue
    else
        widget:get_children_by_id("icon")[1].image   = recolorImage(icon_off, colors.fg_normal)
        widget:get_children_by_id("name")[1].markup  = colorize_text(colors.fg_normal, name)
        widget:get_children_by_id("label")[1].markup = colorize_text(colors.fg_normal, labelDisconnected)
        widget:get_children_by_id("back")[1].bg      = colors.bg_light
    end
end

awesome.connect_signal('signal::network', function(is_enabled)
    updateStatusWidget(wifi, is_enabled, icon_status.wifi_on, 'On', icon_status.wifi_off, 'Off', 'Wi-fi')
end)

awesome.connect_signal('signal::bluetooth', function(is_enabled)
    updateStatusWidget(bluetooth, is_enabled, icon_status.bluetooth_on, 'On', icon_status.bluetooth_off, 'Off',
        'Bluetooth')
end)

awesome.connect_signal('signal::microphone', function(mic_level, mic_muted)
    updateStatusWidget(microphone, not mic_muted, icon_status.microphone_on, 'On', icon_status.microphone_off, 'Off',
        'Microphone')
end)

awesome.connect_signal('signal::volume', function(volume_int, muted)
    updateStatusWidget(volume, not muted, icon_status.volume_on, 'On', icon_status.volume_off, 'Off', 'Volume')
end)

return function()
    return wibox.widget {
        {
            wifi,
            bluetooth,
            spacing = dpi(20),
            layout = wibox.layout.flex.horizontal
        },
        {
            microphone,
            volume,
            spacing = dpi(20),
            layout = wibox.layout.flex.horizontal
        },
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(10)
    }
end
