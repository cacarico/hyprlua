-- A simple configuration for hyprland using binds and monitors
hyprlua.general.setup({
	gaps_in = 30,
	gaps_out = 20,
	border_size = 10,
	col = {
		active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg",
		inactive_border = "rgba(595959aa)",
	},
})

hyprlua.decoration.setup({
	shadow_offset = false,
	shadow_ignore_window = false,
	drop_shadow = false,
})

hyprlua.binds.set("SUPER SHIFT", "h", "resizeactive", "-50 0", { flags = "e" })
hyprlua.binds.set("SUPER SHIFT", "j", "resizeactive", "0 50", { flags = "e" })
hyprlua.binds.set("SUPER SHIFT", "k", "resizeactive", "0 -50", { flags = "e" })
hyprlua.binds.set("SUPER SHIFT", "l", "resizeactive", "50 0", { flags = "e" })

hyprlua.monitors.add("DP-2", "1920x1200", "0x0", 1, { 1, 2 })
hyprlua.monitors.add("HDMI-A-1", "preferred", "1920x0", 1, { 3, 4, 5 })
hyprlua.monitors.add("eDP-1", "preferred", "auto", 1, { 6, 7 })
