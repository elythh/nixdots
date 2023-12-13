local gears   = require("gears")
local naughty = require("naughty")
local gc      = gears.color
local gfs     = gears.filesystem
local colors  = require('widgets.notification.colors')

local first = true
local ok    = naughty.action { name = 'Ok' }

awesome.connect_signal('signal::network', function(is_enabled)
    if first then
        first = false
    else
        if is_enabled then
            naughty.notification({
                icon    = gc.recolor_image(gfs.get_configuration_dir() .. 'theme/assets/notification/wifi_on.svg',
                    colors.green),
                title   = 'Wifi',
                message = 'Wifi on',
                actions = { ok }
            })
        else
            naughty.notification({
                icon    = gc.recolor_image(gfs.get_configuration_dir() .. 'theme/assets/notification/wifi_off.svg',
                    colors.red),
                title   = 'Wifi',
                text    = 'Wifi off',
                actions = { ok }
            })
        end
    end
end)
