local awful     = require('awful')
local gears     = require('gears')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local colors    = require('widgets.wibar.module.colors')
local dpi       = beautiful.xresources.apply_dpi
local panel     = require('widgets.calendar')

return function()
   local clock = wibox.widget {
      {
         {
            {
               format = '<b>%H</b>',
               font   = beautiful.font_mono .. 'Bold ' .. dpi(11),
               halign = "center",
               widget = wibox.widget.textclock
            },
            {
               {
                  format = '<b>%M</b>',
                  font   = beautiful.font_mono .. dpi(11),
                  halign = "center",
                  widget = wibox.widget.textclock
               },
               fg     = colors.fg_normal .. '90',
               widget = wibox.container.background
            },
            layout = wibox.layout.fixed.vertical
         },
         margins = dpi(10),
         widget  = wibox.container.margin
      },
      bg     = colors.bg_light,
      shape  = function(c, w, h)
         gears.shape.rounded_rect(c, w, h, dpi(4))
      end,
      widget = wibox.container.background
   }

   clock:connect_signal('mouse::enter', function()
      clock.bg = colors.mid_dark
   end)
   clock:connect_signal('mouse::leave', function()
      clock.bg = colors.bg_light
   end)

   clock.buttons = {
      awful.button({}, 1, function()
         panel:show()
      end)
   }

   return clock
end