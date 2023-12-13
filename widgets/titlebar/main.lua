local awful         = require('awful')
local wibox         = require('wibox')
local gears         = require('gears')
local beautiful     = require('beautiful')
local dpi           = beautiful.xresources.apply_dpi
local animation     = require("modules.animation")
local colors        = require('widgets.titlebar.colors')

local helpers       = require('helpers')

local width_buttons = 12


-- Circular buttons
-------------------
local mkbutton = function(width, color, onclick)
  return function(c)
    local button = wibox.widget {
      wibox.widget.textbox(),
      forced_width  = dpi(width),
      forced_height = dpi(12),
      bg            = color,
      shape         = function(c, w, h)
        gears.shape.rounded_rect(c, w, h, 10)
      end,
      widget        = wibox.container.background
    }

    local color_transition = helpers.apply_transition {
      element = button,
      prop    = 'bg',
      bg      = color,
      hbg     = colors.titlebar_fg_normal,
    }

    client.connect_signal('property::active', function()
      if c.active then
        color_transition.off()
      else
        color_transition.on()
      end
    end)

    button:add_button(awful.button({}, 1, function()
      if onclick then
        onclick(c)
      end
    end))

    -- Animation
    local anim = animation:new({
      duration = 0.12,
      easing = animation.easing.linear,
      update = function(_, pos)
        button.forced_width = pos
      end,
    })
    button:connect_signal('mouse::enter', function(_)
      anim:set(50)
    end)
    button:connect_signal('mouse::leave', function(_)
      anim:set(12)
    end)

    return button
  end
end

local close = mkbutton(width_buttons, colors.red, function(c)
  c:kill()
end)

local maximize = mkbutton(width_buttons, colors.blue, function(c)
  c.maximized = not c.maximized
end)

local minimize = mkbutton(width_buttons, colors.magenta, function(c)
  gears.timer.delayed_call(function()
    c.minimized = not c.minimized
  end)
end)

return function(c)
  local buttons = {
    awful.button({}, 1, function()
      c:activate { context = "titlebar", action = "mouse_move" }
    end),
    awful.button({}, 3, function()
      c:activate { context = "titlebar", action = "mouse_resize" }
    end),
  }

  local n_titlebar = awful.titlebar(c, {
    size     = dpi(30),
    position = 'top',
  })
  n_titlebar.widget = {
    {
      {
        {         -- Start
          close(c),
          maximize(c),
          minimize(c),
          spacing = dpi(8),
          layout  = wibox.layout.fixed.horizontal
        },
        {         -- Middle
          buttons = buttons,
          layout  = wibox.layout.fixed.horizontal
        },
        {         -- End
          --sticky(c),
          spacing = dpi(10),
          layout  = wibox.layout.fixed.horizontal
        },
        spacing = dpi(5),
        layout  = wibox.layout.align.horizontal
      },
      direction = 'north',
      widget    = wibox.container.rotate
    },
    margins = dpi(9),
    widget  = wibox.container.margin
  }

  return n_titlebar
end