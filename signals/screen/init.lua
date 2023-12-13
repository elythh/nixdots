local awful     = require('awful')
local beautiful = require('beautiful')
local wibox     = require('wibox')
local gears     = require('gears')

local vars      = require('config.vars')
local widgets   = require('widgets')

local wall      = require('config.user').wallpaper or beautiful.wallpaper

screen.connect_signal('request::wallpaper', function(s)
   -- awful.wallpaper kinda sucks.
   -- awful.wallpaper {
   --    screen = s,
   --    widget = {
   --       -- {
   --       --    image     = beautiful.wallpaper,
   --       --    upscale   = true,
   --       --    downscale = true,
   --       --    widget    = wibox.widget.imagebox,
   --       -- },
   --       -- valign = 'center',
   --       -- halign = 'center',
   --       -- tiled  = false,
   --       -- widget = wibox.container.tile,
   --       widget = wibox.container.background,
   --       bg     = beautiful.mid_normal
   --    }
   -- }

   -- Let's use the older methods instead.
   gears.wallpaper.maximized(wall, s, false, nil)
end)

screen.connect_signal('request::desktop_decoration', function(s)
   -- Tag configuration. Creates #vars.tags tags respecting `config.vars` settings,
   -- then a single floating tag at the end of the list.
   awful.tag(vars.tags, s, awful.layout.layouts[1])
   awful.tag.add(#vars.tags + 1, { screen = s, layout = awful.layout.suit.floating })

   -- Show the wibar in the main screen.
   widgets.wibar(s)
   -- Show the exit screen in the main screen when shutdown is pressed
   widgets.exitscreen(s)

   -- TODO
   -- You don't need to call these widgets here because you don't 
   -- need to pass the screen object to them as an argument.
   -- brightness indicator
   widgets.popups.brightness_popups(s)
   -- volume indicator 
   widgets.popups.volume_popus(s)
end)

awful.screen.connect_for_each_screen(function(s)
      -- Sets a tag padding using the already dpi calculated `beautiful.useless_gap`.
      s.padding = {
         bottom = beautiful.useless_gap,
         top    = beautiful.useless_gap,
         left   = beautiful.useless_gap,
         right  = beautiful.useless_gap
      }
end)