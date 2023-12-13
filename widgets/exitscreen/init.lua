local awful      = require('awful')
local wibox      = require('wibox')
local beautiful  = require('beautiful')
local dpi        = beautiful.xresources.apply_dpi
local colors     = require('widgets.exitscreen.module.colors')
local modules    = require('widgets.exitscreen.module')
local gears      = require('gears')
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/exitscreen/'

local function recolorImage(image, color)
  return gears.color.recolor_image(image, color)
end

local icon = {
  powerofficon = recolorImage(asset_path .. "poweroff.svg", colors.red),
  rebooticon = recolorImage(asset_path .. "reboot.svg", colors.blue),
  exiticon = recolorImage(asset_path .. "exit.svg", colors.yellow),
  suspendicon = recolorImage(asset_path .. "suspend.svg", colors.cyan)
}

local poweroffcommand = function()
  awful.spawn.with_shell('systemctl poweroff')
  awesome.emit_signal('hide::exit')
end

local rebootcommand = function()
  awful.spawn.with_shell('systemctl reboot')
  awesome.emit_signal('hide::exit')
end

local suspendcommnad = function()
  awesome.emit_signal('hide::exit')
  awful.spawn.with_shell("systemctl suspend")
end

local exitcommand = function()
  awesome.quit()
end

local createButton = function(icon, cmd, color)
  local button = wibox.widget {
    {

      {
        {
          id = "image",
          image = recolorImage(icon, color),
          widget = wibox.widget.imagebox,
          resize = false
        },
        id = "icon_layout",
        halign = 'center',
        valign = "center",
        widget = wibox.container.place
      },
      margins = {
        left = dpi(80), right = dpi(80),
        top = dpi(70), bottom = dpi(70)
      },
      widget = wibox.container.margin
    },
    border_color = color,
    border_width = dpi(5),
    bg = colors.bg_normal,
    buttons = {
      awful.button({}, 1, function()
        cmd()
      end)
    },
    widget = wibox.container.background
  }
  button:connect_signal('mouse::enter', function(self)
    self.bg = color
    self:get_children_by_id('image')[1].image = recolorImage(icon, colors.bg_normal)
  end)
  button:connect_signal('mouse::leave', function(self)
    self.bg = colors.bg_normal
    self:get_children_by_id('image')[1].image = recolorImage(icon, color)
  end)
  return button
end

local poweroffbutton = createButton(icon.powerofficon, poweroffcommand, colors.red)
local rebootbutton = createButton(icon.rebooticon, rebootcommand, colors.blue)
local exitbutton = createButton(icon.exiticon, exitcommand, colors.yellow)
local suspendbutton = createButton(icon.suspendicon, suspendcommnad, colors.cyan)

local box = wibox.widget {
  {
    {
      poweroffbutton,
      rebootbutton,
      exitbutton,
      suspendbutton,
      layout = wibox.layout.fixed.horizontal,
      spacing = 40,
    },
    spacing = 20,
    layout = wibox.layout.fixed.vertical
  },
  widget = wibox.container.place,
  halign = 'center',
}
local exit_screen_grabber = awful.keygrabber({
  auto_start = true,
  stop_event = 'release',
  keypressed_callback = function(self, mod, key, command)
    if key == 'e' then
      exitcommand()
    elseif key == 'p' then
      poweroffcommand()
    elseif key == 's' then
      suspendcommnad()
    elseif key == 'r' then
      rebootcommand()
    elseif key == 'Escape' or key == 'q' or key == 'x' then
      awesome.emit_signal('hide::exit')
    end
  end,
})

local footer = wibox.widget {
  {
    modules.battery,
    modules.time,
    spacing = 10,
    layout = wibox.layout.fixed.horizontal
  },
  widget = wibox.container.place,
  halign = 'center'
}

return function(s)
  local exit = wibox({
    type = 'dock',
    screen = s,
    height = s.geometry.height,
    width = s.geometry.width,
    bg = colors.bg_normal .. '44',
    ontop = true,
    visible = false,
  })

  exit:setup {
    {
      modules.topbar,
      box,
      footer,
      nil,
      expand = 'none',
      layout = wibox.layout.align.vertical,
    },
    margins = dpi(15),
    widget = wibox.container.margin,
  }

  awesome.connect_signal('toggle::exit', function()
    if exit.visible then
      exit_screen_grabber:stop()
      exit.visible = false
    else
      exit.visible = true
      exit_screen_grabber:start()
    end
  end)

  awesome.connect_signal('show::exit', function()
    exit_screen_grabber:start()
    exit.visible = true
  end)

  awesome.connect_signal('hide::exit', function()
    exit_screen_grabber:stop()
    exit.visible = false
  end)

  return exit
end
