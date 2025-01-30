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

--- Saves monitors to file
--- @param file (file*) A path to the configuration file to save
function monitors.write(file)
	if #monitors.list > 0 then
		file:write("# MONITORS\n")
		for _, monitor in pairs(monitors.list) do
			local monitor_line = string.format(
				"monitor = %s, %s, %s, %s\n",
				monitor.name,
				monitor.resolution,
				monitor.position,
				monitor.scale
			)
			file:write(monitor_line)

			if #monitor.workspaces > 0 then
				for _, workspace_name in pairs(monitor.workspaces) do
					-- TODO: Being a default workspace is hardcoded now, make it so people can chose
					local workspace_line =
						string.format("workspace = name:%s, monitor:%s, default:true\n", workspace_name, monitor.name)
					file:write(workspace_line)
				end
				file:write("\n")
			end
		end
	end

	if #monitors.disabled > 0 then
		for disabled_monitor in monitors.disabled do
			local disabled_monitor_line = string.format("monitor = %s, disabled\n", disabled_monitor.name)
			file:write(disabled_monitor_line)
		end
	end
end

return monitors
