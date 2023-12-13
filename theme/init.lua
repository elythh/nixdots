local gears  = require('gears')

local dpi    = require('beautiful').xresources.apply_dpi
local gc     = gears.color
local gfs    = gears.filesystem

local color  = require('theme.colorscheme')
local user   = require('config.user')
local helper = require('helpers')

local asset_path = gfs.get_configuration_dir() .. 'theme/assets/'

local _T = {}

-- Custom Variables
_T.font_sans = 'IBM Plex Sans '
_T.font_mono = 'IBM Plex Mono '

-- Custom Colors
_T.bg_light     = color.bg_light
_T.mid_dark     = color.mid_dark
_T.bg_normal    = color.bg_normal
_T.fg_normal    = color.fg_normal
_T.red          = color.red
_T.red_dark     = color.red_dark
_T.blue         = color.blue
_T.transparent  = '#00000000'

-- Basic AWM variables
_T.useless_gap         = dpi(user.gaps)
_T.master_width_factor = 0.56
_T.font                = _T.font_sans .. dpi(10)
_T.icon_theme          = 'ePapirus'
-- Hacky, bad, need to improve this. But doing it this way allows me to send the
-- colors table to other programs.
_T.wallpaper           =  user.wallpaper or gfs.get_configuration_dir() .. 'theme/colorscheme/' .. user.colorscheme .. '/wallpaper.png'

local def_icon = asset_path .. 'awesome.svg'
if user.avatar ~= nil then
   -- Cropping the image means that the user can use images of arbitrary
   -- aspect ratio, which is very commonly the case.
   local surf = gears.surface.load_uncached(user.avatar)
   _T.awesome_icon = helper.crop_surface(1, surf)
else
   -- Since we know the default logo IS square, there's no need for cropping.
   _T.awesome_icon = gc.recolor_image(def_icon, _T.fg_normal)
end


-- Logos/icons/avatar
_T.distro_logo = gc.recolor_image(asset_path .. '/distro/flowers.png', _T.blue)
_T.shutdown_icon = gc.recolor_image(asset_path .. '/power/shutdown.svg',_T.red)
_T.avatar = user.avatar ~= nil and user.avatar
or asset_path .. "user.png"


-- Systray
_T.bg_systray           = _T.mid_dark
_T.systray_icon_spacing = dpi(4)
-- Layout icons
local icons_path     = asset_path .. 'layout/'
_T.layout_tile       = gc.recolor_image(icons_path .. 'tile_right.svg',  _T.fg_normal)
_T.layout_tileleft   = gc.recolor_image(icons_path .. 'tile_left.svg',   _T.fg_normal)
_T.layout_tilebottom = gc.recolor_image(icons_path .. 'tile_bottom.svg', _T.fg_normal)
_T.layout_floating   = gc.recolor_image(icons_path .. 'float.svg',       _T.fg_normal)

-- Snapping
_T.snap_border_width = dpi(3)
_T.snap_bg           = _T.border_color_marked
_T.snap_shape        = gears.shape.rectangle

-- Notification
_T.notification_spacing = dpi(16)

-- Titlebar
_T.titlebar_font           = _T.font_sans .. "Bold "
_T.titlebar_bg_focus       = _T.bg_light
_T.titlebar_fg_focus       = _T.red
_T.titlebar_bg_normal      = _T.bg_normal
_T.titlebar_fg_normal      = _T.bg_light
_T.titlebar_bg_urgent      = _T.red_dark
_T.titlebar_fg_urgent      = _T.mid_normal

return _T