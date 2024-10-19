# Hyprlua

Hyprlua aims to end my frustration with configuring Hyprland using its configuration file.

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
hyprlua.general.setup()

hyprlua.binds.set("SUPER SHIFT", "h", "resizeactive", "-50 0", { flags = "e" })
hyprlua.binds.set("SUPER SHIFT", "j", "resizeactive", "0 50", { flags = "e" })
hyprlua.binds.set("SUPER SHIFT", "k", "resizeactive", "0 -50", { flags = "e" })
hyprlua.binds.set("SUPER SHIFT", "l", "resizeactive", "50 0", { flags = "e" })
```

It will generate a hyprland.conf

```
# GENERAL
config {
    allow_tearing = false
    border_size = 1
    col.active_border = 0xffffffff
    col.inactive_border = 0xff444444
    col.nogroup_border = 0xffffaaff
    col.nogroup_border_active = 0xffff00ff
    extend_border_grab_area = 15
    gaps_in = 5
    gaps_out = 20
    gaps_workspaces = 0
    hover_icon_on_border = true
    layout = dwindle
    no_border_on_floating = false
    no_focus_fallback = false
    resize_corner = 0
    resize_on_border = false
}

# Keybindings
binde = SUPER SHIFT, h, resizeactive, -50 0
binde = SUPER SHIFT, j, resizeactive, 0 50
binde = SUPER SHIFT, k, resizeactive, 0 -50
binde = SUPER SHIFT, l, resizeactive, 50 0

```
