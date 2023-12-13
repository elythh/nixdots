local gears      = require('gears')
local awful      = require('awful')
local wibox      = require('wibox')
local dpi        = require('beautiful').xresources.apply_dpi
local colors     = require('widgets.wibar.module.colors')
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/wifi/'


local icon_wifi_status = {
    wifi_on = gears.color.recolor_image(asset_path .. "on.svg", colors.fg_normal),
    wifi_off = gears.color.recolor_image(asset_path .. "off.svg", colors.fg_normal)
}

return function()
    local wifi = wibox.widget {
        {
            {
                id = "image",
                image = icon_wifi_status.wifi_on,
                widget = wibox.widget.imagebox,
                forced_height = dpi(20),
                forced_width = dpi(20)
            },
            id = "icon_layout",
            widget = wibox.container.place
        },
        bg            = colors.bg_normal,
        shape         = function(c, w, h)
            gears.shape.rounded_rect(c, w, h, dpi(4))
        end,
        forced_height = dpi(30),
        widget        = wibox.container.background
    }

    wifi:connect_signal('mouse::enter', function()
        wifi.bg = colors.mid_dark
    end)

    wifi:connect_signal('mouse::leave', function()
        wifi.bg = colors.bg_normal
    end)

    wifi.buttons = {
        awful.button({}, 1, function()
            awesome.emit_signal('network::toggle')
        end)
    }

    awesome.connect_signal('signal::network', function(is_enabled)
        if is_enabled then
            wifi:get_children_by_id('image')[1].image = icon_wifi_status.wifi_on
        else
            wifi:get_children_by_id('image')[1].image = icon_wifi_status.wifi_off
        end
    end)

    return wifi
end