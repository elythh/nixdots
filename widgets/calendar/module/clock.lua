local beautiful = require('beautiful')
local wibox     = require('wibox')
local colors    = require('widgets.calendar.module.colors')

local dpi       = beautiful.xresources.apply_dpi

return function()
   return wibox.widget {
      layout = wibox.layout.fixed.vertical,
      {
         widget = wibox.container.place,
         halign = 'center',
         {
            layout  = wibox.layout.fixed.horizontal,
            -- Hour
            spacing = dpi(8),
            {
               widget = wibox.widget.textclock,
               format = '%H',
               font   = beautiful.font_mono .. dpi(48)
            },
            -- The color bar
            {
               widget = wibox.container.place,
               valign = 'center',
               {
                  layout = wibox.layout.fixed.vertical,
                  {
                     widget = wibox.container.background,
                     bg     = colors.red_dark,
                     forced_height = dpi(16),
                     forced_width  = dpi(3)
                  },
                  {
                     widget = wibox.container.background,
                     bg     = colors.yellow_dark,
                     forced_height = dpi(16),
                     forced_width = dpi(3)
                  },
                  {
                     widget = wibox.container.background,
                     bg     = colors.green_dark,
                     forced_height = dpi(16),
                     forced_width = dpi(3)
                  }
               }
            },
            -- Minute
            {
               widget = wibox.widget.textclock,
               format = '%M',
               font   = beautiful.font_mono .. dpi(48)
            }
         }
      },
      {
         widget = wibox.container.background,
         fg     = colors.fg_dark,
         {
            widget = wibox.widget.textclock,
            format = '%A %e of %B, %Y',
            halign = 'center'
         }
      }
   }
end
