--- Monitors Module
--- This module handles monitor-related functionalities.
---
--- @module "monitors"

local monitors = {}

monitors.list = {}
monitors.disabled = {}

--- Adds a monitor and optionally associates workspaces to it
--- @param name (string) The name of the monitor, can also be the description (eg. desc:Chimei Innolux Corporation 0x150C)
--- @param resolution (string) The resolution for the given monitor 1920x1080@60.01Hz
--- @param position (string) The position where the monitor will be displayed (eg. 0x0)
--- @param scale (string) The scale for the monitor (eg. 1)
--- @param workspaces (table) A list of workspaces that should be attached to this monitor
function monitors.add(name, resolution, position, scale, workspaces)
	table.insert(monitors.list, {
		name = name,
		resolution = resolution,
		position = position,
		scale = scale,
		workspaces = workspaces,
	})
end

--- Disable a monitor
--- @param name (table) A list of monitors to disable
function monitors.disable(name)
	table.insert(monitors.disabled, name)
end

return monitors
