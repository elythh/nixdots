local awful   = require('awful')
local wibox   = require('wibox')
local colors  = require('widgets.wibar.module.colors')
local dpi     = require('beautiful').xresources.apply_dpi
local buttons = require('bindings.widgets.layoutbox').buttons

return function()
   return wibox.widget {
      {
         widget  = wibox.container.margin,
         margins = { top = dpi(7), bottom = dpi(7), left = dpi(7), right = dpi(7) },
         {
            widget = awful.widget.layoutbox,
            screen = s
         },
         buttons = buttons
      },
      bg = colors.bg_light,
      widget = wibox.container.background
   }
end