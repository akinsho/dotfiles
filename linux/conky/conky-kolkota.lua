conky.config = {
	alignment = 'top_left',
	background = true,
	color2 = '#fafafa',
	cpu_avg_samples = 2,
	default_color = 'pink',
	draw_shades = false,
	default_shade_color = '#2d2d2d',
	double_buffer = true,
	font = 'Monospace:size=12',
	gap_x = 10,
	gap_y = 45,
	minimum_width = 200,
	no_buffers = true,
	own_window = true,
	own_window_class = 'Conky',
	own_window_type = 'desktop',
	own_window_argb_visual = true,
	own_window_transparent = true,
    own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
	update_interval = 2.0,
	use_xft = true,
}
conky.text = [[
${voffset 10}${goto 5}${font Dungeon:size=12}${time %a}$font${voffset -20}$alignr${color #e97451}${font Dungeon:size=45}${time %e}$font${color}
${voffset -20}${goto 5}${font Dungeon:size=12}${time %b}$font ${voffset 2}${font Dungeon:size=20}${time %Y}$font
#
${voffset 10}Manjaro Linux ${execi 86400 awk -F'=' '/DISTRIB_RELEASE=/ {printf $2" "}' /etc/lsb-release}
${kernel}-${machine}
#
${voffset 10}CPU$alignr$color2$cpu%$color
${cpubar 3,200}
$color2${top name 1}$alignr${top cpu 1}%$color
$color2${top name 2}$alignr${top cpu 2}%$color
$color2${top name 3}$alignr${top cpu 3}%$color
$color2${top name 4}$alignr${top cpu 4}%$color
$color2${top name 5}$alignr${top cpu 5}%$color
#
${voffset 10}RAM$alignr$color2$mem/$memmax$color
${membar 3,200}
$color2${top_mem name 1}$alignr${top_mem mem_res 1}$color
$color2${top_mem name 2}$alignr${top_mem mem_res 2}$color
$color2${top_mem name 3}$alignr${top_mem mem_res 3}$color
$color2${top_mem name 4}$alignr${top_mem mem_res 4}$color
$color2${top_mem name 5}$alignr${top_mem mem_res 5}$color
#
${voffset 10}SWAP$alignr$color2$swap/$swapmax$color
${swapbar 3,200}
#
${voffset 10}Root$alignr$color2${fs_used /}/${fs_size /}$color
${fs_bar 3,200 /}
Home$alignr$color2${fs_used /home}/${fs_size /home}$color
${fs_bar 3,200 /home}
#
R/W: $color2${diskio_read}${goto 110}/${alignr}${diskio_write}$color
#
${voffset 10}E: Down $color2${downspeedf enp7s0}KiB${alignr}${upspeedf enp7s0}KiB$color Up
W: Down $color2${downspeedf wlp4s0}KiB${alignr}${upspeedf wlp4s0}KiB$color Up
#${wireless_link_bar 5,200 wlp4s0}
#
${voffset 10}#$alignc${execi 86400 whoami}@${nodename}
uptime ${uptime_short}
]]