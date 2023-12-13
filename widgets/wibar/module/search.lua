local gears      = require('gears')
local wibox      = require('wibox')
local awful      = require('awful')
local menubar    = require('menubar')
local dpi        = require('beautiful').xresources.apply_dpi
local colors     = require('widgets.wibar.module.colors')
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/search/'

return function()
  local search = wibox.widget {
    {
      {
        id = "image",
        image = gears.color.recolor_image(asset_path .. "default.svg", colors.fg_normal),
        widget = wibox.widget.imagebox,
        forced_height = dpi(20),
        forced_width = dpi(20)
      },
      id = "icon_layout",
      widget = wibox.container.place
    },
    bg            = colors.bg_normal,
    shape         = function(c, w, h)
      gears.shape.rounded_rect(c, w, h, dpi(4))
    end,
    forced_height = dpi(30),
    widget        = wibox.container.background
  }

  search:connect_signal('mouse::enter', function()
    search.bg = colors.mid_dark
  end)

  search:connect_signal('mouse::leave', function()
    search.bg = colors.bg_normal
  end)

  search.buttons = {
    awful.button({}, 1, function()
      menubar.show()
    end)
  }

  return search
end