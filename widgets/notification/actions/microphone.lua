local gears      = require("gears")
local naughty    = require("naughty")
local gc         = gears.color
local colors     = require('widgets.notification.colors')
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/notification/'


local first = true
local ok    = naughty.action { name = 'Ok' }

awesome.connect_signal('signal::microphone', function(mic_level, mic_muted)
    if first then
        first = false
    else
        if not mic_muted then
            naughty.notification({
                icon    = gc.recolor_image(asset_path .. 'microphone_on.svg', colors.green),
                title   = 'Microphone',
                message = 'Microphone on',
                actions = { ok }
            })
        else
            naughty.notification({
                icon    = gc.recolor_image(asset_path .. 'microphone_off.svg', colors.red),
                title   = 'Microphone',
                message = 'Microphone off',
                actions = { ok }
            })
        end
    end
end)