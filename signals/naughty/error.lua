local naughty   = require('naughty')

-- Errors
naughty.connect_signal('request::display_error', function(message, startup)
   naughty.notification {
      urgency = 'critical',
      title   = 'Oops, and error happened' .. (startup and ' during startup!' or '!'),
      message = message
   }
end)