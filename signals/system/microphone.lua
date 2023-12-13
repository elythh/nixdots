local awful = require('awful')
local gears = require('gears')


-- Microphone Fetching and Signal Emitting
------------------------------------------
-- Emit a microphone level signal
local mic_old       = -1
local mic_muted_old = -1
local function microphone_emit()
  awful.spawn.easy_async_with_shell(
    "bash -c 'wpctl get-volume @DEFAULT_AUDIO_SOURCE@'", function(stdout)
      local mic           = string.match(stdout:match('(%d%.%d+)'), '(%d+)')
      local mic_int       = tonumber(mic) * 100 -- integer
      local mic_muted     = stdout:match('MUTED')
      local mic_muted_int = mic_muted and 1 or 0
      if mic_int ~= mic_old or mic_muted_int ~= mic_muted_old then
        awesome.emit_signal('signal::microphone', mic_int, mic_muted) -- integer
        mic_old       = mic_int
        mic_muted_old = mic_muted_int
      end
    end)
end

-- Toggle microphone.
awesome.connect_signal('microphone::mute', function()
  awful.spawn("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
end)
-- Refreshing
-------------
gears.timer {
  timeout   = 1,
  call_now  = true,
  autostart = true,
  callback  = function()
    microphone_emit()
  end
}
