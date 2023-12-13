local awful = require('awful')
local ruled = require('ruled')

ruled.client.connect_signal('request::rules', function()
   -- All clients will match this rule.
   ruled.client.append_rule {
      id         = 'global',
      rule       = {},
      properties = {
         focus     = awful.client.focus.filter,
         raise     = true,
         screen    = awful.screen.preferred,
         placement = awful.placement.no_overlap+awful.placement.no_offscreen
            +awful.placement.centered,
         size_hints_honor = false,
         callback         = awful.client.setslave
      }
   }

   -- Floating clients.
   ruled.client.append_rule {
      id = 'floating',
      rule_any = {
         instance = {'copyq', 'pinentry'},
         class = {
            'Arandr',
            'Blueman-manager',
            'Gpick',
            -- Media programs.
            'Sxiv',
            'Viewnior',
            'mpv',
            -- Tor randomizes its size and position as a floating window to avoid resolution fingerprinting.
            'Tor Browser'
         },
         -- Note that the name property shown in xprop might be set slightly after creation of the client
         -- and the name shown there might not match defined rules here.
         name = {
            'Event Tester',  -- xev.
         },
         role = {
            'AlarmWindow',    -- Thunderbird's calendar.
            'ConfigManager',  -- Thunderbird's about:config.
            'pop-up',         -- e.g. Google Chrome's (detached) Developer Tools.
         }
      },
      properties = { floating = true }
   }

   -- Add titlebars to normal clients and dialogs
   ruled.client.append_rule {
      id         = 'titlebars',
      rule_any   = { type = { 'normal', 'dialog' } },
      except_any = { class = { 'feh', 'Viewnior', 'Sxiv', 'mpv' } },
      properties = { titlebars_enabled = true }
   }

   -- Map 'Discord' to open in Tag '6', 'Steam' and 'Heroic' in '7'.
   -- ruled.client.append_rule {
   --    rule_any   = {
   --       class = { 'steam', 'heroic' }
   --    },
   --    properties = { tag   = '7' }
   -- }
   -- ruled.client.append_rule {
   --    rule       = { class = 'discord' },
   --    properties = { tag   = '6' }
   -- }
end)