local awful         = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')
require('awful.hotkeys_popup.keys')
local menubar          = require('menubar')

local apps             = require('config.apps')
local mod              = require('bindings.mod')
local widgets          = require('widgets')
local screenshot       = require('script.screenshot')
local calendar         = require('widgets.calendar')
local control          = require('widgets.control')
local quiklinks        = require('widgets.quiklinks')
local capturer         = require('widgets.capturer.init')
local gears            = require('gears')
local gfs              = gears.filesystem
local config_dir       = gfs.get_configuration_dir()

menubar.utils.terminal = apps.terminal

-- general awesome keys
awful.keyboard.append_global_keybindings {
  awful.key {
    modifiers   = { mod.super },
    key         = 's',
    description = 'show help',
    group       = 'awesome',
    on_press    = hotkeys_popup.show_help
  },
  awful.key {
    modifiers   = { mod.super },
    key         = 'w',
    description = 'show main menu',
    group       = 'awesome',
    on_press    = function() widgets.menu.mainmenu:show() end
  },
  awful.key {
    modifiers   = { mod.super, mod.ctrl },
    key         = 'r',
    description = 'reload awesome',
    group       = 'awesome',
    on_press    = awesome.restart
  },
  -- awful.key {
  --    modifiers   = { mod.super, mod.shift },
  --    key         = 'q',
  --    description = 'quit awesome',
  --    group       = 'awesome',
  --    on_press    = awesome.quit
  -- },
  awful.key {
    modifiers   = { mod.super },
    key         = 'Return',
    description = 'open a terminal',
    group       = 'launcher',
    on_press    = function() awful.spawn(apps.terminal) end
  },
  awful.key {
    modifiers   = { mod.super, mod.ctrl },
    key         = 'Return',
    description = 'open a terminal(floating)',
    group       = 'launcher',
    on_press    = function() awful.spawn(apps.terminal, { floating = true }) end
  },
  awful.key {
    modifiers   = { mod.super, mod.shift },
    key         = 'd',
    description = 'open passord manager on rofi',
    group       = 'launcher',
    on_press    = function() awful.spawn("rofi-rbw --no-help") end
  },
  awful.key {
    modifiers   = { mod.super },
    key         = 'p',
    description = 'show the menubar',
    group       = 'launcher',
    on_press    = function() menubar.show() end
  },

  -- Widgets
  awful.key {
    modifiers   = { mod.super, mod.shift },
    key         = 'c',
    description = 'Calendar',
    group       = 'launcher',
    on_press    = function() calendar:show() end
  },

  awful.key {
    modifiers   = { mod.super },
    key         = 'c',
    description = 'Show controlCenter',
    group       = 'launcher',
    on_press    = function() control:show() end
  },

  awful.key {
    modifiers   = { mod.super },
    key         = 'l',
    description = 'Show Quiklinks',
    group       = 'launcher',
    on_press    = function() quiklinks:show() end
  },

  awful.key {
    modifiers   = { mod.super },
    key         = 't',
    description = 'Show Tools',
    group       = 'launcher',
    on_press    = function() capturer:show() end
  }
}

-- tags related keybindings
awful.keyboard.append_global_keybindings {
  awful.key {
    modifiers   = { mod.super },
    key         = 'Left',
    description = 'view preivous',
    group       = 'tag',
    on_press    = awful.tag.viewprev
  },
  awful.key {
    modifiers   = { mod.super },
    key         = 'Right',
    description = 'view next',
    group       = 'tag',
    on_press    = awful.tag.viewnext
  },
  awful.key {
    modifiers   = { mod.super },
    key         = 'Escape',
    description = 'go back',
    group       = 'tag',
    on_press    = awful.tag.history.restore
  }
}

-- focus related keybindings
awful.keyboard.append_global_keybindings {
  awful.key {
    modifiers   = { mod.super },
    key         = 'j',
    description = 'focus next by index',
    group       = 'client',
    on_press    = function() awful.client.focus.byidx(1) end
  },
  awful.key {
    modifiers   = { mod.super },
    key         = 'k',
    description = 'focus previous by index',
    group       = 'client',
    on_press    = function() awful.client.focus.byidx(-1) end
  },
  awful.key {
    modifiers   = { mod.super },
    key         = 'Tab',
    description = 'go back',
    group       = 'client',
    on_press    = function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end
  },
  awful.key {
    modifiers   = { mod.super, mod.ctrl },
    key         = 'j',
    description = 'focus the next screen',
    group       = 'screen',
    on_press    = function() awful.screen.focus_relative(1) end
  },
  awful.key {
    modifiers   = { mod.super, mod.ctrl },
    key         = 'n',
    description = 'restore minimized',
    group       = 'client',
    on_press    = function()
      local c = awful.client.restore()
      if c then
        c:active { raise = true, context = 'key.unminimize' }
      end
    end
  }
}

-- layout related keybindings
awful.keyboard.append_global_keybindings {
  awful.key {
    modifiers   = { mod.super, mod.shift },
    key         = 'j',
    description = 'swap with next client by index',
    group       = 'client',
    on_press    = function() awful.client.swap.byidx(1) end
  },
  awful.key {
    modifiers   = { mod.super, mod.shift },
    key         = 'k',
    description = 'swap with previous client by index',
    group       = 'client',
    on_press    = function() awful.client.swap.byidx(-1) end
  },
  awful.key {
    modifiers   = { mod.super },
    key         = 'u',
    description = 'jump to urgent client',
    group       = 'client',
    on_press    = awful.client.urgent.jumpto
  },
  awful.key {
    modifiers   = { mod.super },
    key         = 'l',
    description = 'increase master width factor',
    group       = 'layout',
    on_press    = function() awful.tag.incmwfact(0.05) end
  },
  awful.key {
    modifiers   = { mod.super },
    key         = 'h',
    description = 'decrease master width factor',
    group       = 'layout',
    on_press    = function() awful.tag.incmwfact(-0.05) end
  },
  awful.key {
    modifiers   = { mod.super, mod.shift },
    key         = 'h',
    description = 'increase the number of master clients',
    group       = 'layout',
    on_press    = function() awful.tag.incnmaster(1, nil, true) end
  },
  awful.key {
    modifiers   = { mod.super, mod.shift },
    key         = 'l',
    description = 'decrease the number of master clients',
    group       = 'layout',
    on_press    = function() awful.tag.incnmaster(-1, nil, true) end
  },
  awful.key {
    modifiers   = { mod.super, mod.alt },
    key         = 'k',
    description = 'increase client width factor',
    group       = 'layout',
    on_press    = function() awful.client.incwfact(0.05) end
  },
  awful.key {
    modifiers   = { mod.super, mod.alt },
    key         = 'j',
    description = 'decrease client width factor',
    group       = 'layout',
    on_press    = function() awful.client.incwfact(-0.05) end
  },
  awful.key {
    modifiers   = { mod.super, mod.ctrl },
    key         = 'h',
    description = 'increase the number of columns',
    group       = 'layout',
    on_press    = function() awful.tag.incnmaster(1, nil, true) end
  },
  awful.key {
    modifiers   = { mod.super, mod.ctrl },
    key         = 'l',
    description = 'decrease the number of columns',
    group       = 'layout',
    on_press    = function() awful.tag.incnmaster(-1, nil, true) end
  },
  awful.key {
    modifiers   = { mod.super },
    key         = 'space',
    description = 'select next',
    group       = 'layout',
    on_press    = function() awful.layout.inc(1) end
  },
  awful.key {
    modifiers   = { mod.super, mod.shift },
    key         = 'space',
    description = 'select previous',
    group       = 'layout',
    on_press    = function() awful.layout.inc(-1) end
  }
}

awful.keyboard.append_global_keybindings {
  awful.key {
    modifiers   = { mod.super },
    keygroup    = 'numrow',
    description = 'only view tag',
    group       = 'tag',
    on_press    = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only(tag)
      end
    end
  },
  awful.key {
    modifiers   = { mod.super, mod.ctrl },
    keygroup    = 'numrow',
    description = 'toggle tag',
    group       = 'tag',
    on_press    = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end
  },
  awful.key {
    modifiers   = { mod.super, mod.shift },
    keygroup    = 'numrow',
    description = 'move focused client to tag',
    group       = 'tag',
    on_press    = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end
  },
  awful.key {
    modifiers   = { mod.super, mod.ctrl, mod.shift },
    keygroup    = 'numrow',
    description = 'toggle focused client on tag',
    group       = 'tag',
    on_press    = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end
  },
  awful.key {
    modifiers   = { mod.super },
    keygroup    = 'numpad',
    description = 'select layout directrly',
    group       = 'layout',
    on_press    = function(index)
      local tag = awful.screen.focused().selected_tag
      if tag then
        tag.layout = tag.layouts[index] or tag.layout
      end
    end
  },

  -- screenshot
  awful.key {
    modifiers   = { mod.super },
    key         = 'Print',
    description = 'takes a screenshot',
    group       = 'miscelaneous',
    on_press    = screenshot.screen
  },
  awful.key {
    modifiers   = {},
    key         = 'Print',
    description = 'takes a selection screenshot',
    group       = 'miscelaneous',
    on_press    = screenshot.selection
  },

  --color picker
  awful.key {
    modifiers   = { mod.super },
    key         = 'o',
    description = 'takes color picker',
    group       = 'miscelaneous',
    on_press    = function() awful.spawn(config_dir .. 'script/xcolor-pick') end
  },

  -- Volume
  awful.key {
    modifiers = {},
    key = 'XF86AudioRaiseVolume',
    description = 'Increase system audio volume',
    group = 'Media',
    on_press = function() awesome.emit_signal("volume::change", 5) end
  },

  awful.key {
    modifiers = {},
    key = 'XF86AudioLowerVolume',
    description = 'Decrease system audio volume',
    group = 'Media',
    on_press = function() awesome.emit_signal("volume::change", -5) end
  },

  -- brightness
  awful.key {
    modifiers = {},
    key = 'XF86MonBrightnessUp',
    description = 'Increase screen brightness',
    group = 'Media',
    on_press = function() awesome.emit_signal("brightness::change", 5) end
  },

  awful.key {
    modifiers = {},
    key = 'XF86MonBrightnessDown',
    description = 'Decrease screen brightness',
    group = 'Media',
    on_press = function() awesome.emit_signal("brightness::change", -5) end
  }
}
