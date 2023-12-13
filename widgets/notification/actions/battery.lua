local gears          = require("gears")
local naughty        = require("naughty")
local gc             = gears.color
local colors         = require('widgets.notification.colors')
local gfs            = gears.filesystem
local asset_path     = gfs.get_configuration_dir() .. 'theme/assets/notification/'

local display_low    = true
local display_half   = true
local display_charge = true
local ok             = naughty.action { name = 'Ok' }

awesome.connect_signal('signal::battery', function(level, state, _, _, _)
    local value = level

    if value <= 20 and display_low then
        naughty.notification({
            icon    = gc.recolor_image(asset_path .. 'battery_low.svg', colors.red),
            title   = 'Uh, oh!',
            text    = 'Your battery is low. ' .. math.floor(value) .. "%",
            actions = { ok }
        })
        display_low = false
    end

    if value > 20 and value < 40 then
        display_low = true
    end

    if value >= 21 and value <= 40 and display_half then
        naughty.notification({
            icon    = gc.recolor_image(asset_path .. 'battery_half.svg', colors.yellow),
            title   = 'Halfway There!',
            text    = 'Your battery level is at ' .. math.floor(value) .. "%",
            actions = { ok }
        })
        display_half = false
    end

    if value > 40 then
        display_half = true
    end

    if display_charge and state == 1 then
        naughty.notification({
            icon    = gc.recolor_image(asset_path .. 'battery_chargin.svg', colors.cyan),
            title   = 'Recharging energy!',
            text    = 'Charging',
            actions = { ok }
        })
        display_charge = false
    end

    if state == 2 then
        display_charge = true
    end
end)
