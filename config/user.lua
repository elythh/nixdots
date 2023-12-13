local home = os.getenv('HOME') .. '/'

return {
   -- Variables
   gaps    = 2,
   
   -- Colorscheme, supports:
   ---  dark:
   ---    'everblush', 'everforest', 'tokyonight', 'fullerene', 'oxocarbon' ,'catppuccin','mar','nord','gruvbox_dark','dracula', 'rose','solarized_dark','ephemeral','skyfall','wave','amarena'
   --      'default', 'gruvbox_dark', 'adwaita', 'janleigh'
   ---  light:
   ---    'gruvbox_light', 'solarized_light','plata'

   -- IMPORTAN
   -- IT IS NOT RECOMMENDED TO MOVE THE VARIABLE 'colorscheme' FROM THE CURRENT LINE (21),
   -- BECAUSE IT IS LINKED TO 'themer' widgets, SINCE IT HAS THE FUNCTION OF EDIT THIS LINE DEPENDING ON THE ESTABLISHED THEME. 
   -- IF YOU MOVE IT FROM THE CURRENT LINE, YOU MUST MODIFY THE SECOND ARGUMENT OF THE 'setTheme' FUNCTION CALL IN THE
   -- FILE 'awesome/widgets/control_center/module/themer.lua',
   -- set_theme(' colourscheme = "' .. currTheme:gsub('"', '\\"') .. '",',line number,gfs.get_configuration_dir() ..
   -- "config/username.lua")
   colorscheme = "amarena",
   
   -- Files
   -- You can comment the variable 'avatar' 'wallpaper', 
   -- so that by default it selects the images in theme/palettes/pallete_name/wallpaper.png
   -- and the avatar in theme/assets/user.png

   --avatar         = home .. 'Pictures/avatars/leinu-transformed.png',
   --wallpaper      = home .. 'Pictures/walls/landscape/AustralianPowerlines.jpg',
   screenshot_dir = home .. 'Imágenes/Screenshots',
}
