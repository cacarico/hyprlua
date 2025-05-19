# Hyprlua

Hyprlua aims to end my frustration with configuring Hyprland using its configuration file.
It create a Lua Runtime that reads the config file and issue commands to Hyprland.


## Using

Create a hyprland.lua file on Hyprland directory (usually `~/.config/hypr`)

```lua

-- Create binds
hyprlua.binds.set("SUPER SHIFT", "h", "resizeactive", "-50 0")
hyprlua.binds.set("SUPER SHIFT", "j", "resizeactive", "0 50")
hyprlua.binds.set("SUPER SHIFT", "k", "resizeactive", "0 -50")
hyprlua.binds.set("SUPER SHIFT", "l", "resizeactive", "50 0")

hyprlua.monitors.add("DP-2", "1920x1200", "0x0", 1, { 1, 2 })
hyprlua.monitors.add("HDMI-A-1", "preferred", "1920x0", 1, { 3, 4, 5 })
hyprlua.monitors.add("eDP-1", "preferred", "auto", 1, { 6, 7 })
```
