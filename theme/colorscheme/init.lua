local user = require('config.user')

local colorscheme = require('theme.colorscheme.default')
if user.colorscheme ~= nil then
   colorscheme = require('theme.colorscheme.' .. user.colorscheme)
end

return colorscheme