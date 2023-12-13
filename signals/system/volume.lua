local awful      = require('awful')
local gears      = require('gears')

-- Volume Fetching and Signal Emitting
--------------------------------------
-- Emit a volume level signal
local volume_old = -1
local muted_old  = -1
local function volume_emit()
  awful.spawn.easy_async_with_shell(
    "bash -c 'wpctl get-volume @DEFAULT_AUDIO_SINK@'", function(stdout)
      local volume     = string.match(stdout:match('(%d%.%d+)'), '(%d+)')
      local muted      = stdout:match('MUTED')
      local muted_int  = muted and 1 or 0
      local volume_int = tonumber(volume) * 100                  -- integer
      if volume_int ~= volume_old or muted_int ~= muted_old then
        awesome.emit_signal('signal::volume', volume_int, muted) -- integer
        volume_old = volume_int
        muted_old  = muted_int
      end
    end)
end
-- Connect to set volume to a specific amount.
awesome.connect_signal('volume::set', function(amount)
  awful.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. amount .. "% --limit 1")
end)
-- Connect to add a specific amount to volume.
awesome.connect_signal('volume::change', function(amount)
  awful.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. volume_old + amount .. "% --limit 1")
end)
-- Toggle audio.
awesome.connect_signal('volume::mute', function()
  awful.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
end)

-- Refreshing
-------------
gears.timer {
  timeout   = 1,
  call_now  = true,
  autostart = true,
  callback  = function()
    volume_emit()
  end
}
