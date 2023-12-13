local wibox      = require('wibox')
local awful      = require('awful')
local beautiful  = require('beautiful')
local dpi        = beautiful.xresources.apply_dpi
local apps       = require('config.apps')
local gears      = require("gears")
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/social/'
local colors     = require('widgets.quiklinks.module.colors')

local function create_button(icon, name, color)
    local widget = wibox.widget {
        {
            {
                {
                    id = "image",
                    image = gears.color.recolor_image(icon, color),
                    widget = wibox.widget.imagebox,
                    resize = false,
                },
                id = "icon_layout",
                widget = wibox.container.place
            },
            id     = "direction_layout",
            widget = wibox.container.rotate
        },
        bg            = colors.bg_light,
        shape         = function(c, w, h)
            gears.shape.rounded_rect(c, w, h, dpi(4))
        end,
        forced_height = dpi(90),
        forced_width  = dpi(100),
        widget        = wibox.container.background,
        buttons       = {
            awful.button({}, 1, function()
                awful.spawn.with_shell(apps.browser .. ' ' .. name)
            end)
        },
    }

    widget:connect_signal('mouse::enter', function()
        widget.bg = colors.mid_normal
    end)

    widget:connect_signal('mouse::leave', function()
        widget.bg = colors.bg_light
    end)

    return widget
end

return wibox.widget {
    {
        {
            {
                widget = wibox.widget.textbox,
                markup = "<span foreground='" .. colors.fg_normal .. "'>Quiklinks</span>",
                font   = beautiful.font_sans .. 'Bold' .. dpi(32),
                halign = 'left',
                id     = 'text_role'
            },
            {
                create_button(asset_path .. 'Whatsapp.svg', 'https://web.whatsapp.com/', colors.green),
                create_button(asset_path .. 'Google-Drive.svg', 'https://drive.google.com/drive/', colors.cyan),
                create_button(asset_path .. 'Reddit.svg', 'https://www.reddit.com/', colors.red),
                spacing = 10,
                layout = wibox.layout.fixed.horizontal
            },
            {
                create_button(asset_path .. 'Github.svg', 'https://github.com/osmarmora05', colors.fg_normal),
                create_button(asset_path .. 'Gmail.svg', 'https://mail.google.com/', colors.blue),
                create_button(asset_path .. 'Stackoverflow.svg', 'https://stackoverflow.com/', colors.yellow),
                spacing = 10,
                layout = wibox.layout.fixed.horizontal
            },
            spacing = 20,
            valign = 'center',
            halign = 'center',
            layout = wibox.layout.fixed.vertical
        },
        widget = wibox.container.margin,
        top = 10,
        bottom = 10,
        left = 8,
        right = 8
    },
    forced_width = 100,
    shape = function(c, w, h)
        gears.shape.rounded_rect(c, w, h, dpi(4))
    end,
    widget = wibox.container.background
}