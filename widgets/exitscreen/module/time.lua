local wibox      = require("wibox")
local colors     = require('widgets.exitscreen.module.colors')
local gears      = require('gears')
local beautiful  = require('beautiful')
local dpi        = beautiful.xresources.apply_dpi
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/clock/'

return wibox.widget {
    {
        {
            {
                id = "image",
                image = gears.color.recolor_image(asset_path .. "default.svg", colors.blue),
                widget = wibox.widget.imagebox,
                resize = false
            },
            id = "icon_layout",
            widget = wibox.container.place
        },
        {
            font = beautiful.font_sans .. " 16",
            format = "%H:%M",
            align = "center",
            valign = "center",
            widget = wibox.widget.textclock
        },
        spacing = dpi(10),
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.place,
    valign = "center"
}
