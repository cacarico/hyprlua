local hyprlua = require("src/hyprlua")
local flags = hyprlua.binds.flags

hyprlua.binds.set("SUPER SHIFT", "h", "resizeactive", "-50 0", { flags = flags.e })
hyprlua.binds.set("SUPER SHIFT", "j", "resizeactive", "0 50", { flags = flags.e })
hyprlua.binds.set("SUPER SHIFT", "k", "resizeactive", "0 -50", { flags = flags.e })
hyprlua.binds.set("SUPER SHIFT", "l", "resizeactive", "50 0", { flags = flags.e })


-- Write to configuration file
local success, err = hyprlua.writeToFile("hyprland.conf")
if not success then
	print("Error writing configuration:", err)
end
