local wibox      = require("wibox")
local awful      = require("awful")
local colors     = require('widgets.exitscreen.module.colors')
local gears      = require('gears')
local beautiful  = require('beautiful')
local dpi        = beautiful.xresources.apply_dpi
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/close/'

return wibox.widget {
  {
    {
      {
        widget = wibox.widget.imagebox,
        image = beautiful.avatar,
        forced_height = dpi(50),
        forced_width = dpi(50),
        align = "center",
        valign = "center",
        clip_shape = function(c, w, h)
          gears.shape.rounded_rect(c, w, h, dpi(40))
        end,
        resize = true,
      },
      nil,
      {
        {
          {
            {
              font = beautiful.font_sans .. " 14",
              format = "%a, %d %B",
              align = "center",
              valign = "center",
              widget = wibox.widget.textclock
            },
            widget = wibox.container.margin,
            left = dpi(25),
            right = dpi(25),
          },
          shape = function(c, w, h)
            gears.shape.rounded_rect(c, w, h, dpi(50))
          end,
          bg = colors.bg_normal,
          widget = wibox.container.background,
        },
        {
          {
            {
              id = "image",
              image = gears.color.recolor_image(asset_path .. "default.svg", colors.red),
              widget = wibox.widget.imagebox,
              forced_height = dpi(20),
              forced_width = dpi(20)
            },
            widget = wibox.container.margin,
            margins = dpi(20),
          },
          buttons = {
            awful.button({}, 1, function()
              awesome.emit_signal("toggle::exit")
            end)
          },
          shape = function(c, w, h)
            gears.shape.rounded_rect(c, w, h, dpi(50))
          end,
          bg = beautiful.bg_normal,
          widget = wibox.container.background,
        },
        spacing = dpi(20),
        layout = wibox.layout.fixed.horizontal,
      },
      layout = wibox.layout.align.horizontal,
    },
    widget = wibox.container.place,
    content_fill_horizontal = true,
    halign = "center",
    valign = "top",
  },
  widget = wibox.container.margin,
  top = dpi(40),
  left = dpi(40),
  right = dpi(40),
}
