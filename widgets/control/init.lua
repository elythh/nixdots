local beautiful = require('beautiful')
local wibox     = require('wibox')
local gears     = require('gears')
local dpi       = beautiful.xresources.apply_dpi
local widgets   = require(... .. '.module')

local panel     = wibox {
    ontop   = true,
    visible = false,
    width   = dpi(450),
    height  = dpi(650),
    y       = dpi(422),
    x       = dpi(60),
    bg      = widgets.colors.bg_normal,
    shape   = function(c, w, h)
        gears.shape.rounded_rect(c, w, h, dpi(15))
    end,
    widget  = {
        {
            {

                { -- Top
                    widgets.profile(),
                    layout = wibox.layout.fixed.horizontal
                },

                {
                    -- Middle
                    widgets.setting(),
                    layout = wibox.layout.fixed.horizontal
                },

                { -- Middle
                    widgets.sliders,
                    spacing = dpi(28),
                    layout = wibox.layout.fixed.horizontal
                },                 -- Bottom
                widgets.themer,
                spacing = dpi(20), --15
                layout = wibox.layout.fixed.vertical
            },
            spacing = dpi(28),
            layout = wibox.layout.fixed.horizontal
        },
        margins = dpi(28),
        widget = wibox.container.margin

    }

}

function panel:show()
    panel.visible = not panel.visible
end

return panel
