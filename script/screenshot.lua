-- Screenshot script using maim and xclip. `awful.screenshot` has yet to be
-- reliable enough to be usable.

local awful     = require('awful')
local naughty   = require('naughty')
local beautiful = require('beautiful')
local gears     = require('gears')

local gfs       = gears.filesystem
local gc        = gears.color

local user      = require('config.user')

-- The directory where PERMANENT files would be stored.
local perm_dir     = user.screenshot_dir or os.getenv('HOME')
-- The icon shown for interactions or when the screenshot is cancelled.
local default_icon = gfs.get_configuration_dir() .. 'theme/assets/image.svg'

local function send_notif(path)
   local ok      = naughty.action { name = 'Ok' }
   local save    = naughty.action { name = 'Save' }
   local discard = naughty.action { name = 'Discard' }

   save:connect_signal('invoked', function()
      awful.spawn.easy_async_with_shell('cp ' .. path .. ' ' .. perm_dir, function()
         naughty.notification({
            icon    = gc.recolor_image(default_icon, beautiful.green),
            title   = 'Screenshot',
            text    = 'Saved to ' .. perm_dir,
            actions = { ok }
         })
      end)
   end)

   discard:connect_signal('invoked', function()
      awful.spawn.easy_async_with_shell('rm ' .. path, function()
         naughty.notification({
            icon    = gc.recolor_image(default_icon, beautiful.red),
            title   = 'Screenshot',
            text    = 'Temporary file removed!',
            actions = { ok }
         })
      end)
   end)

   -- Check whether the screenshot was taken or not.
   local file = io.open(path)
   if file ~= nil then
      -- If it exists:
      io.close(file)
      naughty.notification({
         icon    = path,
         title   = 'Screenshot',
         text    = 'Copied to clipboard!',
         actions = { save, discard }
      })
   else
      -- If it doesn't:
      naughty.notification({
         icon    = gc.recolor_image(default_icon, beautiful.red),
         title   = 'Screenshot',
         text    = 'Cancelled!',
         actions = { ok }
      })
   end
end

-- Takes a screenshot and puts it in `/tmp`, then copies it to system clipboard
-- and notifies about the result.
local function take_screenshot(cmd)
   local tmp = '/tmp/ss-' .. os.date('%Y%m%d-%H%M%S') .. '.png'
   awful.spawn.easy_async_with_shell(cmd .. ' ' .. tmp, function()
      awful.spawn.with_shell('xclip -selection clip -t image/png -i ' .. tmp)
      send_notif(tmp)                                  
   end)
end


return {
   screen    = function() take_screenshot('maim')    end,
   selection = function() take_screenshot('maim -s') end
}