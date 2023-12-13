local naughty   = require('naughty')
local beautiful = require('beautiful')
local gears     = require('gears')
local awful     = require('awful')
local wibox     = require('wibox')

local dpi       = beautiful.xresources.apply_dpi

local helpers   = require('helpers')
local rubato    = require('modules.rubato')

local colors = require('widgets.notification.colors')

local def_icon =
   gears.color.recolor_image(gears.filesystem.get_configuration_dir() .. 'theme/assets/awesome.svg', beautiful.fg_normal)

local _W = {}

function _W.init_actions()
   require('widgets.notification.actions.battery')
   require('widgets.notification.actions.wifi')
   require('widgets.notification.actions.bluetooth')
   require('widgets.notification.actions.microphone')
end

function _W.title(n)
   return wibox.widget {
      widget = wibox.container.scroll.horizontal,
      speed  = 66,
      rate   = 60,
      step_function = wibox.container.scroll.step_functions.nonlinear_back_and_forth,
      {
         widget = wibox.widget.textbox,
         markup = n.title ~= nil and '<b>' .. n.title .. '</b>'
            or '<b>Notification</b>',
         font   = beautiful.font_sans .. dpi(9),
         halign = 'center',
         valign = 'center'
      }
   }
end

function _W.body(n)
   return wibox.widget {
      widget = wibox.container.scroll.vertical,
      speed  = 66,
      rate   = 60,
      step_function = wibox.container.scroll.step_functions.nonlinear_back_and_forth,
      {
         widget = wibox.widget.textbox,
         markup = gears.string.xml_unescape(n.message),
         font   = beautiful.font_sans .. dpi(9),
         halign = 'center',
         valign = 'center'
      }
   }
end

function _W.image(n)
   return wibox.widget {
      widget = wibox.widget.imagebox,
      image  = n.icon and helpers.crop_surface(1, gears.surface.load_uncached(n.icon))
         or def_icon,
      resize = true,
      halign = 'center',
      valign = 'center',
      clip_shape = function(c, w, h)
         gears.shape.rounded_rect(c, w, h, dpi(8))
      end,
      forced_height = dpi(40),
      forced_width = dpi(40)
   }
end

function _W.timeout()
   return wibox.widget {
      widget           = wibox.widget.progressbar,
      min_value        = 0,
      max_value        = 100,
      value            = 0,
      background_color = colors.bg_light,
      shape            = function(c, w, h)
         gears.shape.rounded_rect(c, w, h, dpi(6))
      end,
      bar_shape        = function(c, w, h)
         gears.shape.rounded_rect(c, w, h, dpi(4))
      end,
      color            = {
         type  = 'linear',
         from  = { 0, 0   },
         to    = { 0, 100 },
         stops = { { 0, colors.green }, { 1, colors.green .. '8c' } }
      },
      forced_height    = dpi(6)
   }
end

function _W.actions(n)
   if #n.actions == 0 then return nil end
   return wibox.widget {
      widget  = wibox.container.margin,
      margins = { top = dpi(2) },
      {
         widget       = naughty.list.actions,
         notification = n,
         base_layout  = wibox.widget {
            spacing = dpi(4),
            layout  = wibox.layout.flex.horizontal
         },
         style = {
            underline_normal   = false,
            underline_selected = false,
            bg_normal          = colors.mid_dark,
            shape_normal       = function(c, w, h)
               gears.shape.rounded_rect(c, w, h, dpi(6))
            end,
            border_width       = 0
         },
         widget_template = {
            widget = wibox.container.background,
            bg     = colors.mid_dark,
            id     = 'background_role',
            {
               widget  = wibox.container.margin,
               margins = dpi(4),
               {
                  widget = wibox.widget.textbox,
                  id     = 'text_role',
                  font   = beautiful.font_sans .. dpi(7)
               }
            }
         }
      }
   }
end

function _W.close(n)
   local widget = wibox.widget {
      widget  = wibox.container.margin,
      margins = dpi(9),
      {
         widget = wibox.container.background,
         shape  = gears.shape.circle,
         bg     = colors.red .. '80',
         id     = 'bg_role',
         forced_width = dpi(13)
      },
      buttons = { awful.button({}, 1, function() n:destroy() end) },
      set_bg = function(self, bg)
         self:get_children_by_id('bg_role')[1].bg = bg
      end
   }
   widget:connect_signal('mouse::enter', function()
      widget.bg = colors.red
   end)
   widget:connect_signal('mouse::leave', function()
      widget.bg = colors.red .. '80'
   end)

   return widget
end

-- Default layout
function _W.layout(n)
   -- Store the original timeout, and change it to a big, unreachable, number.
   local timeout = n.timeout
   n.timeout = 999999

   local timeout_bar = _W.timeout()

   local widget = naughty.layout.box {
      notification = n,
      cursor       = 'hand2',
      border_width = 0,
      bg           = colors.transparent,
      shape        = function(c, w, h)
         gears.shape.rounded_rect(c, w, h, dpi(6))
      end,
      widget_template = {
         widget   = wibox.container.constraint,
         strategy = 'max',
         height   = dpi(256),
         {
            widget   = wibox.container.constraint,
            strategy = 'exact',
            width    = dpi(256),
            {
               widget = wibox.container.background,
               bg     = colors.bg_normal,
               shape  = function(c, w, h)
                  gears.shape.rounded_rect(c, w, h, dpi(8))
               end,
               {
                  layout = wibox.layout.align.vertical,
                  {
                     widget   = wibox.container.constraint,
                     strategy = 'exact',
                     height   = dpi(30),
                     {
                        widget = wibox.container.background,
                        bg     = colors.bg_normal,
                        {
                           widget = wibox.container.margin,
                           margins = { left = dpi(12) },
                           {
                              layout = wibox.layout.align.horizontal,
                              expand = 'none',
                              {
                                 widget = wibox.container.constraint,
                                 strategy = 'max',
                                 width = dpi(206),
                                 _W.title(n)
                              },
                              nil,
                              _W.close(n)
                           }
                        }
                     }
                  },
                  {
                     widget = wibox.container.background,
                     bg     = {
                        type = 'linear',
                        from = { 0, 0 },
                        to   = { 0, 85 },
                        stops = { { 0, colors.bg_light .. '8c' }, { 1, colors.bg_normal } }
                     },
                     {
                        layout = wibox.layout.align.vertical,
                        expand = 'none',
                        {
                           widget = wibox.container.margin,
                           margins = {
                              left = dpi(9), right = dpi(9),
                              top = dpi(9), bottom = dpi(9)
                           },
                           {
                              layout = wibox.layout.fixed.horizontal,
                              spacing = dpi(10),
                              {
                                 layout = wibox.layout.align.vertical,
                                 _W.image(n),
                                 nil, nil
                              },
                              {
                                 widget = wibox.container.constraint,
                                 strategy = 'max',
                                 height = dpi(202),
                                 {
                                    layout = wibox.layout.fixed.vertical,
                                    spacing = dpi(4),
                                    _W.body(n),
                                    _W.actions(n)
                                 }
                              }
                           }
                        },
                        nil,
                        timeout_bar
                     }
                  }
               }
            }
         }
      }
   }

   -- Set an animation for the timeout.
   local anim = rubato.timed {
      intro      = 0,
      duration   = timeout,
      subscribed = function(pos, time)
         timeout_bar.value = pos
         if time == timeout then n:destroy() end
      end
   }
   -- Whenever the notification is hovered, the animation (and timeout) are paused.
   widget:connect_signal('mouse::enter', function()
      anim.pause = true
   end)
   widget:connect_signal('mouse::leave', function()
      anim.pause = false
   end)
   anim.target = 100

   widget.buttons = {}
   return widget
end

return _W