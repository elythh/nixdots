local naughty = require('naughty')

naughty.connect_signal("request::icon",function (n, context, hints)
    if context ~= "app_icon" then
        return
    end
    
    local path = require('menubar').utils.lookup_icon(hints.app_icon) or
    require('menubar').utils.lookup_icon(hints.app_icon:lower())
    
    if path then
        n.icon = path
    end
end)

naughty.connect_signal("request::action_icon", function(a, context, hints)
    a.icon = require('menubar').utils.lookup_icon(hints.id)
end)