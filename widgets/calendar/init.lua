local beautiful = require('beautiful')
local wibox     = require('wibox')
local dpi       = beautiful.xresources.apply_dpi
local gears     = require('gears')
local module    = require(... .. '.module')

local panel     = wibox {
   ontop   = true,
   visible = false,
   width   = dpi(400),
   height  = dpi(520),
   y       = dpi(550),
   x       = dpi(1510),
   bg      = module.colors.bg_normal,
   shape   = function(c, w, h)
      gears.shape.rounded_rect(c, w, h, dpi(15))
   end,
   widget  = {
      layout = wibox.layout.fixed.vertical,
      {
         widget  = wibox.container.margin,
         margins = {
            top = dpi(5), left = dpi(24),
            bottom = dpi(16)
         },
      },
      {
         widget  = wibox.container.margin,
         margins = dpi(32),
         {
            layout  = wibox.layout.fixed.vertical,
            spacing = dpi(20),
            {
               layout = wibox.layout.fixed.vertical,
               spacing = dpi(35),
               module.clock(),
               module.calendar
            },
         }
      }
   }
}

function panel:show()
   panel.visible = not panel.visible
end

return panel