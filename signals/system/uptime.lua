local awful = require("awful")
local gears = require('gears')


local function get_uptime()
    awful.spawn.easy_async_with_shell(
        "uptime -p", function(stdout)
            awesome.emit_signal('signal::uptime', stdout)
        end)
end

gears.timer {
    timeout   = 60,
    call_now  = true,
    autostart = true,
    callback  = get_uptime
}
