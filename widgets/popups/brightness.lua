local gears      = require("gears")
local awful      = require("awful")
local wibox      = require("wibox")
local beautiful  = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi
local colors     = require('widgets.popups.colors')
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/brightness/default.svg'
local animation  = require('modules.animation')


local info = wibox.widget {
  widget = wibox.container.margin,
  margins = dpi(20),
  {
    layout = wibox.layout.fixed.horizontal,
    fill_space = true,
    spacing = dpi(8),
    {
      id = "image",
      image = gears.color.recolor_image(asset_path, colors.fg_normal),
      widget = wibox.widget.imagebox
    },
    id = "icon_layout",
    halign = 'center',
    valign = "center",
    widget = wibox.container.place,
    {
      widget = wibox.container.background,
      forced_width = dpi(36),
      {
        widget = wibox.widget.textbox,
        font = beautiful.font_sans .. dpi(12),
        id = "text",
        halign = "center"
      },
    },
    {
      widget = wibox.widget.progressbar,
      id = "progressbar",
      max_value = 100,
      forced_width = dpi(380),
      forced_height = dpi(10),
      background_color = colors.yellow .. '55',
      color = colors.yellow,
      shape = function(c, w, h)
        gears.shape.rounded_rect(c, w, h, dpi(15))
      end
    }
  }
}

return function(s)
  local osd = awful.popup {
    visible        = false,
    screen         = s,
    ontop          = true,
    border_color   = colors.bg_light,
    minimum_height = dpi(60),
    maximum_height = dpi(60),
    minimum_width  = dpi(290),
    maximum_width  = dpi(290),
    placement      = function(c)
      awful.placement.bottom(c, { margins = 10, honor_workarea = true, })
    end,
    widget         = info,
  }

  local anim = animation:new {
    duration = 0.3,
    easing = animation.easing.linear,
    update = function(self, pos)
      info:get_children_by_id("progressbar")[1].value = pos
    end,
  }

  local hide = gears.timer {
    timeout = 3,
    callback = function()
      osd.visible = false
    end
  }

  local show = false

  awesome.connect_signal('signal::brightness', function(brightness)
    anim:set(brightness)
    if show then
      info:get_children_by_id("text")[1].text = brightness
      if osd.visible then
        hide:again()
      else
        osd.visible = true
        hide:again()
      end
    else
      show = true
    end
  end)

  return osd
end