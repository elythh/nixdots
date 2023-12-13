local awful             = require('awful')
local gears             = require('gears')

-- Brightness Fetching and Signal Emitting
------------------------------------------
-- Brightness info script
local brightness_script =
"bash -c 'echo $(($(cat /sys/class/backlight/*/brightness) * 100 / $(cat /sys/class/backlight/*/max_brightness)))'"

-- Emit a brightness level signal
local level_old         = -1
local function emit_brightness()
    awful.spawn.easy_async_with_shell(
        brightness_script, function(stdout)
            local level_cur = tonumber(stdout)
            if level_cur ~= level_old then
                awesome.emit_signal('signal::brightness', level_cur)
                level_old = level_cur
            end
        end)
end
-- Connect to set brightness to a specific amount.
awesome.connect_signal('brightness::set', function(amount)
    awful.spawn("brightnessctl s " .. amount .. "%")
end)
-- Connect to add a specific amount to brightness.
awesome.connect_signal('brightness::change', function(amount)
    awful.spawn("brightnessctl s " .. level_old + amount .. "%")
end)

-- Refreshing
-------------
gears.timer {
    timeout   = 1,
    call_now  = true,
    autostart = true,
    callback  = function()
        emit_brightness()
    end
}