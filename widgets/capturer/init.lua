local awful      = require('awful')
local gears      = require('gears')
local wibox      = require('wibox')
local beautiful  = require('beautiful')
local dpi        = beautiful.xresources.apply_dpi
local colors     = require('widgets.capturer.colors')
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/capturer/'
local config_dir = gfs.get_configuration_dir()
local screenshot = require('script.screenshot')

local icon       = {
    screenshot_full = gears.color.recolor_image(asset_path .. "screenshot_full.svg", colors.fg_normal),
    screenshot_select = gears.color.recolor_image(asset_path .. "screenshot_select.svg", colors.fg_normal),
    color_picker = gears.color.recolor_image(asset_path .. "color_picker.svg", colors.fg_normal)
}

local function create_button(icon, action, panel)
    local widget = wibox.widget {
        {
            {
                {
                    id = "image",
                    image = icon,
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
                action()
                panel.visible = false
            end)
        }
    }

    widget:connect_signal('mouse::enter', function()
        widget.bg = colors.mid_normal
    end)

    widget:connect_signal('mouse::leave', function()
        widget.bg = colors.bg_light
    end)

    return widget
end

local panel = wibox {
    ontop     = true,
    visible   = false,
    width     = dpi(350),
    height    = dpi(150),
    bg        = beautiful.transparent,
    shape     = function(c, w, h)
        gears.shape.rounded_rect(c, w, h, dpi(6))
    end,
    placement = awful.placement.centered
}

panel:setup {

    {
        {
            {
                {
                    widget = wibox.widget.textbox,
                    markup = "<span foreground='" .. colors.fg_normal .. "'>Tools</span>",
                    font   = beautiful.font_sans .. 'Bold' .. dpi(32),
                    halign = 'left',
                    id     = 'text_role'
                },

                {
                    create_button(icon.screenshot_full, screenshot.screen, panel),
                    create_button(icon.screenshot_select, screenshot.selection, panel),
                    create_button(icon.color_picker, function() awful.spawn(config_dir .. 'script/xcolor-pick') end, panel),
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.horizontal
                },

                spacing = dpi(20),
                layout = wibox.layout.fixed.vertical
            },
            spacing = dpi(28),
            layout = wibox.layout.fixed.horizontal
        },
        margins = dpi(20),
        widget = wibox.container.margin
    },

    bg            = colors.bg_normal,
    shape         = function(c, w, h)
        gears.shape.rounded_rect(c, w, h, dpi(4))
    end,
    forced_height = dpi(30),
    forced_width  = dpi(30),
    widget        = wibox.container.background
}

function panel:show()
    self.visible = not self.visible
    awful.placement.centered(panel)
end

return panel