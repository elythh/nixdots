local gears      = require("gears")
local naughty    = require("naughty")
local gc         = gears.color
local colors     = require('widgets.notification.colors')
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/notification/'

local first      = true
local ok         = naughty.action { name = 'Ok' }

awesome.connect_signal('signal::bluetooth', function(is_enabled)
    if first then
        first = false
    else
        if is_enabled then
            naughty.notification({
                icon    = gc.recolor_image(asset_path .. 'bluetooth_on.svg', colors.green),
                title   = 'Bluetooth',
                message = 'bluetooth on',
                actions = { ok }
            })
        else
            naughty.notification({
                icon    = gc.recolor_image(asset_path .. 'bluetooth_off.svg', colors.red),
                title   = 'Bluetooth',
                text    = 'bluetooth off',
                actions = { ok }
            })
        end
    end
end)