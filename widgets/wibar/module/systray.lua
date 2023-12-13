local awful       = require('awful')
local wibox       = require('wibox')
local gears       = require('gears')
local dpi         = require('beautiful').xresources.apply_dpi
local colors      = require('widgets.wibar.module.colors')
local gfs         = gears.filesystem
local asset_path  = gfs.get_configuration_dir() .. 'theme/assets/arrow/'

local systray     = wibox.widget {
  {
    widget = wibox.widget.systray,
  },
  top = dpi(9),
  bottom = dpi(9),
  left = dpi(9),
  right = dpi(9),
  widget = wibox.container.margin
}

local systray_btn = wibox.widget {
  {
    {
      {
        id = "image",
        image = gears.color.recolor_image(asset_path .. "default.svg", colors.fg_normal),
        widget = wibox.widget.imagebox,
        forced_height = dpi(15),
        forced_width = dpi(15)
      },
      id = "icon_layout",
      widget = wibox.container.place
    },
    id        = "direction_layout",
    direction = 'west',
    widget    = wibox.container.rotate
  },
  bg            = colors.bg_normal,
  shape         = function(c, w, h)
    gears.shape.rounded_rect(c, w, h, dpi(4))
  end,
  forced_height = dpi(30),
  widget        = wibox.container.background
}

systray_btn:connect_signal('mouse::enter', function()
  systray_btn.bg = colors.bg_light
end)

systray_btn:connect_signal('mouse::leave', function()
  systray_btn.bg = colors.bg_normal
end)

systray_btn.buttons = {
  awful.button({}, 1, function()
    if systray.visible then
      systray_btn:get_children_by_id('direction_layout')[1].direction = 'east'
      systray.visible = false
    else
      systray.visible = true
      systray_btn:get_children_by_id('direction_layout')[1].direction = 'west'
    end
  end)
}

return function()
  return wibox.widget {
    {
      {
        systray,
        systray_btn,
        layout = wibox.layout.fixed.vertical
      },
      shape = function(c, w, h)
        gears.shape.rounded_rect(c, w, h, dpi(2))
      end,
      bg = colors.bg_normal,
      widget = wibox.container.background
    },
    widget = wibox.container.margin
  }
end