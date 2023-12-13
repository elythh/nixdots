local awful      = require("awful")
local wibox      = require("wibox")
local gears      = require("gears")
local beautiful  = require("beautiful")
local colors     = require('widgets.control.module.colors')
local dpi        = beautiful.xresources.apply_dpi
local gfs        = gears.filesystem
local asset_path = gfs.get_configuration_dir() .. 'theme/assets/tools/'
local capturer   = require('widgets.capturer.init')

return function()
	local profile_image = wibox.widget {
		{
			image      = beautiful.avatar,
			clip_shape = gears.shape.circle,
			widget     = wibox.widget.imagebox
		},
		forced_width  = dpi(65),
		forced_height = dpi(65),
		widget        = wibox.container.background
	}

	local username = wibox.widget {
		markup = 'Welcome, <b>user!</b>',
		font   = beautiful.font_sans .. 'Bold ' .. dpi(12),
		align  = 'left',
		widget = wibox.widget.textbox
	}

	awful.spawn.easy_async_with_shell(
		'whoami', function(stdout)
			local name      = stdout:match('(%w+)')
			username.markup = "<span foreground='" .. colors.fg_normal .. "'>" .. name .. "</span>"
		end
	)

	local uptime = wibox.widget {
		markup = "<span foreground='" .. colors.fg_dark .. 'cc' .. "'>Uptime unknown...</span>",
		font   = beautiful.font_sans .. dpi(11),
		widget = wibox.widget.textbox
	}

	awesome.connect_signal('signal::uptime', function(stdout)
		uptime.markup = "<span foreground='" .. colors.fg_dark .. 'cc' .. "'>" .. stdout .. "</span>"
	end)

	local tools = wibox.widget {
		{
			{
				id = "image",
				image = gears.color.recolor_image(asset_path .. "squares.svg", colors.fg_light),
				widget = wibox.widget.imagebox,
				forced_height = dpi(20),
				forced_width = dpi(20)
			},
			id = "icon_layout",
			widget = wibox.container.place
		},
		bg            = colors.bg_light,
		shape         = function(c, w, h)
			gears.shape.rounded_rect(c, w, h, dpi(4))
		end,
		forced_height = dpi(30),
		forced_width  = dpi(30),
		widget        = wibox.container.background
	}

	tools:connect_signal('mouse::enter', function()
		tools.bg = colors.mid_normal
	end)

	tools:connect_signal('mouse::leave', function()
		tools.bg = colors.bg_light
	end)

	tools.buttons = {
		awful.button({}, 1, function()
			capturer:show()
		end)
	}

	return wibox.widget {
		{
			{
				{
					profile_image,

					{
						{

							{
								username,
								uptime,
								layout = wibox.layout.fixed.vertical
							},
							widget  = wibox.container.margin,
							margins = { top = dpi(10) }
						},
						valign = "center",
						widget = wibox.container.place
					},
					spacing = dpi(12),
					layout = wibox.layout.fixed.horizontal
				},
				nil,
				{
					tools,
					valign = "center",
					widget = wibox.container.place
				},

				layout = wibox.layout.align.horizontal
			},

			widget = wibox.container.margin
		},
		widget = wibox.container.background,
		forced_width = dpi(450)
	}
end
