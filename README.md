# Hyprland Lua Config

Hyprland Lua Config aims to end my frustration with configuring Hyprland using its configuration file.

## Features
This project currently supports only the features I use from Hyprland, suggestions and contributions are highly enouraged.

### Currently Supported

- [x] Support for binds
- [ ] Support for submaps in binds
- [x] Support for general config
- [ ] Monitor configuration
- [ ] Setup startup executions
- [ ] Exec-once
- [ ] Inputs
- [ ] Monitors

## Using

Create a hyprland.lua file


```lua
local hyprlua = require("main")
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
```

It will generate a hyprland.conf

```
# Keybindings
binde = SUPER SHIFT, h, resizeactive, -50 0
binde = SUPER SHIFT, j, resizeactive, 0 50
binde = SUPER SHIFT, k, resizeactive, 0 -50
binde = SUPER SHIFT, l, resizeactive, 50 0
```
