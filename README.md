# Hyprlua

Hyprlua aims to end my frustration with configuring Hyprland using its configuration file.
@vaxerski already said on [ISSUE-6168](https://github.com/hyprwm/Hyprland/issues/6186) there's 0 reason to have it on Hyprland core so here we go...


## Features

This project currently supports only the features I use from Hyprland, suggestions and contributions are highly enouraged.
Right now is needed to run hyprlua binary every time you change the config file.
For the future it will be loaded as a plugin, I'm still preparing my mind to go back to cpp...

### Currently Supported Features
- [x] Binds
- [x] General config
- [x] Monitors
- [x] Workspaces (supported currently by monitors)
- [x] Decoration
- [x] Blur

### Soon to be supported
- [ ] Workspaces (full support)
- [ ] Submaps in binds
- [ ] Startup scripts
- [ ] Exec-once
- [ ] Inputs
- [ ] Touchpad
- [ ] Touchdevice
- [ ] Tablet
- [ ] Gestures
- [ ] Group
- [ ] Groupbar
- [ ] Misc
- [ ] Cursor

## Using

Install hyprlua via luarocks

```bash
luarocks install hyprlua
```

Create a hyprland.lua file on Hyprland directory (usually `~/.config/hypr`)

```lua
hyprlua.general.setup()

hyprlua.binds.set("SUPER SHIFT", "h", "resizeactive", "-50 0", { flags = "e" })
hyprlua.binds.set("SUPER SHIFT", "j", "resizeactive", "0 50", { flags = "e" })
hyprlua.binds.set("SUPER SHIFT", "k", "resizeactive", "0 -50", { flags = "e" })
hyprlua.binds.set("SUPER SHIFT", "l", "resizeactive", "50 0", { flags = "e" })
```

It will generate a hyprland.conf

```txt
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

Run hyprlua in the config dir

```bash
hyprlua
```

You can also chose a file and an output dir

```bash
hyprlua -c ~/.config/hypr/hyprland.lua -o ~/.config/hypr/hyprland.conf
```
