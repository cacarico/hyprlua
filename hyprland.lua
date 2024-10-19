hyprlua.binds.set("SUPER SHIFT", "h", "resizeactive", "-50 0", { flags = "e" })
hyprlua.binds.set("SUPER SHIFT", "j", "resizeactive", "0 50", { flags = "e" })
hyprlua.binds.set("SUPER SHIFT", "k", "resizeactive", "0 -50", { flags = "e" })
hyprlua.binds.set("SUPER SHIFT", "l", "resizeactive", "50 0", { flags = "e" })

hyprlua.general.setup({
	gaps_in = 30,
	gaps_out = 20,
	border_size = 10,
	col = {
		active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg",
		inactive_border = "rgba(595959aa)",
	},
	resize_on_border = false,
	allow_tearing = false,
})
