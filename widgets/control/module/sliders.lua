local wibox      = require('wibox')
local beautiful  = require('beautiful')
local dpi        = beautiful.xresources.apply_dpi
local colors     = require('widgets.control.module.colors')
local gears      = require('gears')
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/'


local icon_status = {
  brightness = gears.color.recolor_image(asset_path .. "brightness/default.svg", colors.bg_normal),
  volume_on = gears.color.recolor_image(asset_path .. "volume/on.svg", colors.bg_normal),
  volume_off = gears.color.recolor_image(asset_path .. "volume/off.svg", colors.bg_normal)
}

local function mkslider(icon)
  return wibox.widget {
    {
      {
        id = 'slider_role',
        value = 100,
        handle_color = colors.blue,
        handle_width = dpi(44),
        bar_border_width = 0,
        bar_active_color = colors.blue,
        bar_color = colors.blue .. '4D',  -- 30% of transparency
        bar_shape = function(c, w, h)
          gears.shape.rounded_rect(c, w, h, dpi(15))
        end,
        widget = wibox.widget.slider,
        bar_height = dpi(44),
        forced_height = dpi(44),
        forced_width = dpi(400),
        handle_shape = function(c, w, h)
          gears.shape.rounded_rect(c, w, h, dpi(15))
        end,
      },
      {
        {

          {
            {
              id            = "icon_role",
              image         = icon,
              widget        = wibox.widget.imagebox,
              forced_height = dpi(5),
              forced_width  = dpi(5)
            },
            direction = 'north',
            widget = wibox.container.rotate,
          },
          widget  = wibox.container.margin,
          margins = { top = dpi(8), bottom = dpi(8), left = dpi(20) }
        },
        fg = colors.bg_normal,
        widget = wibox.container.background,
      },
      layout = wibox.layout.stack,
    },
    direction = 'north',
    widget = wibox.container.rotate,
    get_slider = function(self)
      return self:get_children_by_id('slider_role')[1]
    end,
    set_value = function(self, val)
      self.slider.value = val
    end,
    set_icon = function(self, new_icon)
      self:get_children_by_id('icon_role')[1].markup = new_icon
    end
  }
end


-- Volume
---------
local volumeSlider = mkslider(icon_status.volume_on)

awesome.connect_signal('signal::volume', function(volume, muted)
  volumeSlider.value = volume

  if not muted then
    volumeSlider:get_children_by_id('icon_role')[1].image = icon_status.volume_on
    -- volumeSlider.icon =
  else
    volumeSlider:get_children_by_id('icon_role')[1].image = icon_status.volume_off
  end
end)

volumeSlider.slider:connect_signal('property::value', function(_, value)
  awesome.emit_signal('volume::set', tonumber(value))
end)


-- Brightness
-------------
local brightnessSlider = mkslider(icon_status.brightness)

awesome.connect_signal('signal::brightness', function(brightness)
  brightnessSlider.value = brightness
end)

brightnessSlider.slider:connect_signal('property::value', function(_, value)
  awesome.emit_signal('brightness::set', value)
end)


local container = wibox.widget {
  {
    volumeSlider,
    brightnessSlider,
    spacing = dpi(12),
    layout = wibox.layout.fixed.vertical,
  },
  halign = 'center',
  valign = 'bottom',
  layout = wibox.container.place,
}

return container
