local awful      = require("awful")
local helpers    = require("helpers")
local wibox      = require("wibox")
local gears      = require("gears")
local beautiful  = require("beautiful")
local colors     = require('widgets.control.module.colors')
local dpi        = beautiful.xresources.apply_dpi
local scheme     = require('config.user').colorscheme
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/'

local themes     = {
  'everblush',
  'everforest',
  'tokyonight',
  'fullerene',
  'oxocarbon',
  'catppuccin',
  'dracula',
  'rose',
  'mar',
  'nord',
  'gruvbox_dark',
  'gruvbox_light',
  'solarized_dark',
  'solarized_light',
  'plata',
  'adwaita',
  'janleigh',
  'default',
  'wave',
  'ephemeral',
  'amarena',
  'skyfall',
  'biscuit'
}

local index      = helpers.indexOf(themes, scheme)

local M          = {
  current = scheme,
  colors = {
    red = colors.red,
    green = colors.green,
    yellow = colors.yellow,
    blue = colors.blue,
    magenta = colors.magenta,
    bg = colors.bg_light,
    fg = colors.fg_normal
  }
}

function M:previous()
  index = index - 1
  if index < 1 then
    index = #themes
  end
  M:getColors(themes[index])
  M:setColors()
end

function M:next()
  index = index + 1
  if index > #themes then
    index = 1
  end
  M:getColors(themes[index])
  M:setColors()
end

function M:getColors(scheme)
  scheme       = scheme or self.current
  local colors = require("theme.colorscheme." .. scheme)
  self.colors  = colors
  self.current = scheme
end

function M:setColors()
  self.widget:get_children_by_id("red")[1].bg = self.colors.red
  self.widget:get_children_by_id("blue")[1].bg = self.colors.blue
  self.widget:get_children_by_id("green")[1].bg = self.colors.green
  self.widget:get_children_by_id("yellow")[1].bg = self.colors.yellow
  self.widget:get_children_by_id("magenta")[1].bg = self.colors.magenta
  self.widget:get_children_by_id("bg")[1].bg = self.colors.bg_light
  self.widget:get_children_by_id("name")[1].markup = self.current:gsub("^%l", string.upper)
end

function M.createButton(icons_path, direction, action)
  local widget = wibox.widget {
    {
      {
        {
          id = "image",
          image = gears.color.recolor_image(icons_path, colors.fg_normal),
          widget = wibox.widget.imagebox,
          forced_height = dpi(20),
          forced_width = dpi(20)
        },
        id = "icon_layout",
        widget = wibox.container.place
      },
      id        = "direction_layout",
      direction = direction,
      widget    = wibox.container.rotate
    },
    bg            = colors.transparent,
    shape         = function(c, w, h)
      gears.shape.rounded_rect(c, w, h, dpi(4))
    end,
    forced_height = dpi(30),
    widget        = wibox.container.background
  }

  widget:connect_signal('mouse::enter', function()
    widget.bg = colors.mid_normal
  end)

  widget:connect_signal('mouse::leave', function()
    widget.bg = colors.transparent
  end)


  widget.buttons = {
    awful.button(nil, 1, action)
  }

  return widget
end

function M.open_file(text, line, path)
  local file = io.open(path, 'r')
  local fileContent = {}

  for line in file:lines() do
    table.insert(fileContent, line)
  end

  io.close(file)

  fileContent[line] = text

  file = io.open(path, 'w')
  for index, value in ipairs(fileContent) do
    file:write(value .. '\n')
  end
  io.close(file)
end

function M.set_theme(current)
  M.open_file('   colorscheme = "' .. current:gsub('"', '\\"') .. '",', 21, gfs.get_configuration_dir() .. "config/user.lua")--Change theme
  -- M.open_file("include " .. current .. ".ini", 3, os.getenv("HOME") .. "/.config/kitty/kitty.conf")                          --Change terminal color (kitty)
  -- M.open_file('@import "'..current:gsub('"', '\\"') .. '.rasi"',1,os.getenv("HOME") .. "/.config/rofi/appmnu.rasi") --Change rofi color
  awesome.restart()
end

M.widget = wibox.widget {
  {
    {
      {
        {
          {
            {
              id     = "name",
              markup = M.current,
              font   = beautiful.font_sans .. " 14",
              widget = wibox.widget.textbox
            },
            widget = wibox.container.margin,
            buttons = awful.button({}, 1, function()
              M:getColors(scheme)
              M:setColors()
            end),
          },
          id     = "bg_title",
          bg     = colors.transparent,
          shape  = function(c, w, h)
            gears.shape.rounded_rect(c, w, h, dpi(4))
          end,
          widget = wibox.container.background,
        },
        nil,
        {
          M.createButton(asset_path .. 'arrow/default.svg', 'north', function() M:previous() end),
          M.createButton(asset_path .. 'arrow/default.svg', 'south', function() M:next() end),
          M.createButton(asset_path .. 'check/default.svg', 'north', function() M.set_theme(M.current) end),
          spacing = dpi(2),
          layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
      },
      {
        {
          {
            id = "red",
            widget = wibox.container.background,
            forced_height = 60,
            forced_width = 60,
            bg = M.colors.red
          },
          {
            id = "green",
            widget = wibox.container.background,
            forced_height = 60,
            forced_width = 60,
            bg = M.colors.green
          },
          {
            id = "yellow",
            widget = wibox.container.background,
            forced_height = 60,
            forced_width = 60,
            bg = M.colors.yellow
          },
          {
            id = "blue",
            widget = wibox.container.background,
            forced_height = 60,
            forced_width = 60,
            bg = M.colors.blue
          },
          {
            id = "magenta",
            widget = wibox.container.background,
            forced_height = 60,
            forced_width = 60,
            bg = M.colors.magenta
          },
          spacing = 8,
          layout = wibox.layout.fixed.horizontal,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place,
      },
      nil,
      layout = wibox.layout.align.vertical,
    },
    widget = wibox.container.margin,
    margins = { top = dpi(20), bottom = dpi(20), left = dpi(30), right = dpi(28) }
  },
  id = "bg",
  forced_height = dpi(200),
  shape = function(c, w, h)
    gears.shape.rounded_rect(c, w, h, dpi(15))
  end,
  widget = wibox.container.background,
  bg = M.colors.bg
}

M:getColors(scheme)
M:setColors()


local bg_title = M.widget:get_children_by_id("bg_title")[1]

bg_title:connect_signal('mouse::enter', function()
  bg_title.bg = colors.mid_normal
end)

bg_title:connect_signal('mouse::leave', function()
  bg_title.bg = colors.transparent
end)

return M
