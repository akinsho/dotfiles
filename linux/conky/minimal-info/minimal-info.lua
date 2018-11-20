conky.config = {
	alignment = 'top_left',
	maximum_width = 390,
	minimum_width = 390,
	gap_x = 20,
	gap_y = 60,
	border_inner_margin = 0,
	border_outer_margin = 0,

	own_window = true,
	own_window_transparent = false,
	own_window_argb_visual = true,
	own_window_argb_value = 0,
	own_window_type = 'desktop',
	own_window_class = 'Conky',
	own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
	double_buffer = true,

	short_units = true,
	format_human_readable = false,
	times_in_seconds = false,
	update_interval = 1,
	use_spacer = 'none',
	net_avg_samples = 1,
	cpu_avg_samples = 1,
	top_cpu_separate = false,

	use_xft = true,
	override_utf8_locale = true,

	draw_shades = false,
	draw_borders = false,
	draw_graph_borders = true,

	default_bar_width = 50,
	default_bar_height = 6,
	default_graph_width = 60,
	default_graph_height = 35,

	own_window_colour = '000000',
	default_color = 'ffffff',
	default_shade_color = '111111',
	color1 = '666666',
	color2 = '1793d0',

	lua_load = 'utils.lua',

	font = 'Source Sans Pro:pixelsize=34:weight=normal',
};

conky.config.lua_startup_hook = "init " .. (
    conky.config.font:gsub(" ", "\1"):gsub("size=([0-9]+)", function(n)
        return ("size=%.0f"):format(tonumber(n) * 1.5)
    end))

conky.text = [[
${uptime_short}
${voffset 10}
${color 222222}${cpubar cpu1 40, 300}${color}${alignr 95}${voffset -3} 1${voffset 8}
${color 222222}${cpubar cpu2 40, 300}${color}${alignr 95}${voffset -3} 2${voffset 8}
${color 222222}${cpubar cpu3 40, 300}${color}${alignr 95}${voffset -3} 3${voffset 8}
${color 222222}${cpubar cpu4 40, 300}${color}${alignr 95}${voffset -3} 4${voffset 8}
${color 222222}${membar 40, 300}${color}${alignr 95}${voffset -3} M${voffset 8}
${color 222222}${swapbar 40, 300}${color}${alignr 95}${voffset -3} S${voffset 0}
${voffset 10}
${lua_parse fs_free /} /
${lua_parse fs_free /home} /home
${voffset 20}
${lua_parse upspeedf enp0s25} ↑
${lua_parse downspeedf enp0s25} ↓
${voffset 20}
${time %a, %b %-d}${voffset -15}
${font Source Sans Pro:weight=0:pixelsize=180}${time %-H:%M}${font}${time %S}
${voffset -52}
]];
