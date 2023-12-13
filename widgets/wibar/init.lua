local awful     = require('awful')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local dpi       = beautiful.xresources.apply_dpi

local modules   = require(... .. '.module')

return function(s)
   return awful.wibar {
      screen = s,
      position = 'left',
      width = dpi(50),
      widget = {
         widget = wibox.container.background,
         bg = modules.colors.bg_normal,
         {
            widget = wibox.container.margin,
            margins = {
               left = dpi(5),
               right = dpi(5),
               top = dpi(10),
               bottom = dpi(10)
            },
            {
               layout = wibox.layout.align.vertical,
               {
                  layout = wibox.layout.fixed.vertical,
                  spacing = dpi(10),
                  modules.distro_icon(),
                  modules.taglist(s),
               },
               {
                  widget = wibox.container.margin,
                  margins = {
                     top = dpi(5)
                  },
                  modules.tasklist(s),
               },
               {
                  layout = wibox.layout.fixed.vertical,
                  spacing = dpi(10),
                  modules.systray(),
                  modules.search(),
                  modules.battery,
                  modules.wifi(),
                  modules.clock(),
                  modules.layoutbox(),
                  modules.shutdown_icon()
               }
            }
         }
      }
   }
end
