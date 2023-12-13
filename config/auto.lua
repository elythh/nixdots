-- Programs to be executed on startup

local awful     = require('awful')
-- Spawns a program ONCE, when the X session is started.
local on_start  = awful.spawn.once
-- Spawns a program every time Awesome is loaded, so once
-- on startup and on every reload.
local on_reload = awful.spawn
-- Like `on_reload`, but takes commands with shell operators
-- such as `echo 'biggus' > dickus`.
local shell     = awful.spawn.with_shell
