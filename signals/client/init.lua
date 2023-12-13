require('awful.autofocus')

-- Focus client on hover.
client.connect_signal('mouse::enter', function(c)
   c:activate { context = 'mouse_enter', raise = false }
end)

client.connect_signal('request::titlebars', function(c)
   -- Don't show titlebars on clients that explictly request not to
   -- have them, like the Steam client or many fullscreen apps, for
   -- example.
   if c.requests_no_titlebar then return end
   
   require('widgets.titlebar').main(c)
end)

-- Floating windows always on top.
client.connect_signal('property::floating', function(c) c.ontop = c.floating end)

-- Send fullscreen windows to the top.
client.connect_signal('property::fullscreen', function(c) c:raise() end)