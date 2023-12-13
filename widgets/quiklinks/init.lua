local beautiful = require('beautiful')
local wibox     = require('wibox')
local dpi       = beautiful.xresources.apply_dpi
local gears     = require('gears')
local module    = require(... .. '.module')

local panel     = wibox {
   ontop   = true,
   visible = false,
   width   = dpi(360),
   height  = dpi(300),
   y       = dpi(770),
   x       = dpi(782),
   bg      = module.colors.bg_normal,
   shape   = function(c, w, h)
      gears.shape.rounded_rect(c, w, h, dpi(15))
   end,
   widget  = {
      module.quiklinks,
      margins = dpi(12),
      widget = wibox.container.margin
   }
}

function panel:show()
   panel.visible = not panel.visible
end

return panel