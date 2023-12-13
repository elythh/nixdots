local awful         = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')
local beautiful     = require('beautiful')
local wibox         = require('wibox')
local colors        = require(... .. '.colors')
local dpi           = beautiful.xresources.apply_dpi
local apps          = require('config.apps')
local dot           = require('gears.filesystem').get_configuration_dir() .. 'theme/assets/arrow/menu.svg'


-- 'Sections'.
local _S = {}

_S.awesome = {
   { 'Keybinds'    , function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { 'Manpage'     , apps.manual_cmd },
   { 'Reload'      , awesome.restart }
}

_S.power = {
   { 'Log off', function() awesome.quit() end },
   { 'Suspend', function() os.execute('suspend') end },
   { 'Reboot', function() os.execute('reboot') end },
   { 'Shutdown', function() os.execute('poweroff') end }
}

-- The widgets to return.
local _M = {}

_M.mainmenu = awful.menu {
   items = {
      { 'Terminal' , apps.terminal},
      { 'Browser'  , apps.browser},
      { 'Awesome'  , _S.awesome},
      { 'Power'    , _S.power}
   },
   theme = {
      -- Dimensions (per cell).
      width  = dpi(160),
      height = dpi(32),
      -- Colors.
      bg_normal = colors.bg_normal,
      bg_focus  = colors.bg_light,
      -- Image.
      submenu_icon = dot
   }
}

_M.mainmenu.wibox:set_widget(wibox.widget {
   widget = wibox.container.background,
   bg     = colors.bg_normal,
   {
      widget  = wibox.container.margin,
      --margins = dpi(16),
      _M.mainmenu.wibox.widget
   }                            
})

awful.menu.original_new = awful.menu.new
function awful.menu.new(...)
   local sub    = awful.menu.original_new(...)
   sub.wibox:set_widget(wibox.widget {
      widget = wibox.container.background,
      bg     = colors.bg_normal,
      {
         widget  = wibox.container.margin,
         sub.wibox.widget
      }   
   })
   return sub
end

return _M
