local gobject      = require("gears.object")
local gtable       = require("gears.table")
local gshape       = require("gears.shape")
local wibox        = require("wibox")
local gears        = require('gears')
local beautiful    = require('beautiful')
local dpi          = beautiful.xresources.apply_dpi
local setmetatable = setmetatable
local colors       = require('widgets.calendar.module.colors')
local gfs          = gears.filesystem
local asset_path   = gfs.get_configuration_dir() .. 'theme/assets/arrow/'
local awful        = require('awful')
local os           = os

--- Calendar Widget
--- ~~~~~~~~~~~~~~~

local function title(action)
  local widget = wibox.widget {
    widget        = wibox.container.background,
    bg            = colors.transparent,
    forced_height = dpi(30),
    fg            = colors.fg_normal,
    shape         = function(c, w, h)
      gears.shape.rounded_rect(c, w, h, dpi(4))
    end,
    {
      widget = wibox.container.margin,
      {
        widget = wibox.widget.textbox,
        markup = os.date('%B %Y'),
        font   = beautiful.font_sans .. dpi(12),
        halign = 'center',
        id     = 'text_role'
      }
    },
    buttons = {
      awful.button(nil, 1, action)
    },
    set_text = function(self, text)
      local capitalized_text = text:sub(1, 1):upper() .. text:sub(2)
      self:get_children_by_id('text_role')[1].text = capitalized_text
    end
  }

  widget:connect_signal('mouse::enter', function()
    widget.bg = colors.mid_normal
  end)
  widget:connect_signal('mouse::leave', function()
    widget.bg = colors.transparent
  end)

  return widget
end

local function button(assets, action)
  local widget = wibox.widget {
    widget = wibox.container.background,
    bg     = colors.transparent,
    shape  = function(c, w, h)
      gears.shape.rounded_rect(c, w, h, dpi(4))
    end,
    {
      id = "icon_layout",
      widget = wibox.container.place,
      {
        id = "image",
        halign = 'center',
        image = assets,
        widget = wibox.widget.imagebox,
        forced_height = dpi(20),
        forced_width = dpi(50)
      }
    },
    buttons = {
      awful.button(nil, 1, action)
    }
  }
  widget:connect_signal('mouse::enter', function()
    widget.bg = colors.mid_normal
  end)
  widget:connect_signal('mouse::leave', function()
    widget.bg = colors.transparent
  end)

  return widget
end

local calendar = { mt = {} }

local function day_name_widget(name)
  return wibox.widget {
    widget = wibox.container.background,
    fg     = colors.fg_normal,
    {
      widget  = wibox.container.margin,
      margins = { left = dpi(8) },
      {
        widget = wibox.widget.textbox,
        markup = name
      }
    }
  }
end

local function date_widget(date, is_current, is_another_month)
  local color = colors.fg_normal
  if is_current then
    color = colors.bg_normal
  elseif is_another_month then
    color = colors.mid_light
  end

  return wibox.widget {
    widget = wibox.container.background,
    bg     = is_current and colors.blue or colors.transparent,
    fg     = color,
    shape  = gshape.circle,
    {
      widget  = wibox.container.margin,
      margins = {
        left = dpi(8), right = dpi(8),
        top = dpi(4), bottom = dpi(4)
      },
      {
        widget = wibox.widget.textbox,
        halign = 'center',
        text   = date
      }
    }
  }
end

function calendar:set_date(date)
  self.date = date
  self.days:reset()

  local current_date = os.date("*t")
  self.days:add(day_name_widget("<span foreground='" .. colors.blue .. "'>Su</span>"))
  self.days:add(day_name_widget("Mo"))
  self.days:add(day_name_widget("Tu"))
  self.days:add(day_name_widget("We"))
  self.days:add(day_name_widget("Th"))
  self.days:add(day_name_widget("Fr"))
  self.days:add(day_name_widget("<span foreground='" .. colors.blue .. "'>Sa</span>"))


  local first_day = os.date("*t", os.time({ year = date.year, month = date.month, day = 1 }))
  local last_day = os.date("*t", os.time({ year = date.year, month = date.month + 1, day = 0 }))
  local month_days = last_day.day

  local time = os.time({ year = date.year, month = date.month, day = 1 })
  self.month:set_text(os.date("%B %Y", time))

  local days_to_add_at_month_start = first_day.wday - 1
  local days_to_add_at_month_end = 42 - last_day.day - days_to_add_at_month_start

  local previous_month_last_day = os.date("*t", os.time({ year = date.year, month = date.month, day = 0 })).day
  for day = previous_month_last_day - days_to_add_at_month_start, previous_month_last_day - 1, 1 do
    self.days:add(date_widget(day, false, true))
  end

  for day = 1, month_days do
    local is_current = day == current_date.day and date.month == current_date.month
    self.days:add(date_widget(day, is_current, false))
  end

  for day = 1, days_to_add_at_month_end do
    self.days:add(date_widget(day, false, true))
  end
end

function calendar:set_date_current()
  self:set_date(os.date("*t"))
end

function calendar:increase_date()
  local new_calendar_month = self.date.month + 1
  self:set_date({ year = self.date.year, month = new_calendar_month, day = self.date.day })
end

function calendar:decrease_date()
  local new_calendar_month = self.date.month - 1
  self:set_date({ year = self.date.year, month = new_calendar_month, day = self.date.day })
end

local function new()
  local ret = gobject({})
  gtable.crush(ret, calendar, true)

  ret.month = title(function() ret:set_date_current() end)

  local month = wibox.widget({
    layout = wibox.layout.align.horizontal,
    button(gears.color.recolor_image(asset_path .. "left.svg", colors.fg_normal), function() ret:decrease_date() end),
    ret.month,
    button(gears.color.recolor_image(asset_path .. "right.svg", colors.fg_normal), function() ret:increase_date() end)
  })

  ret.days = wibox.widget({
    layout = wibox.layout.grid,
    forced_num_rows = 6,
    forced_num_cols = 7,
    spacing = dpi(5),
    expand = true,
  })

  local widget = wibox.widget({
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(15),
    month,
    ret.days,
  })

  ret:set_date(os.date("*t"))

  gtable.crush(widget, calendar, true)
  return widget
end

function calendar.mt:__call(...)
  return new(...)
end

return wibox.widget {
  {
    setmetatable(calendar, calendar.mt),
    margins = { right = dpi(32), left = dpi(32), top = dpi(18), bottom = dpi(18) },
    widget = wibox.container.margin,
  },
  bg = colors.bg_light,
  widget = wibox.container.background
}