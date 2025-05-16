--- Monitors Module
--- @module "monitors"
--- Handles monitor-related configuration before runtime apply.

local M = {}

-- Internal state
local _queue = {}
local _disabled = {}

--- Adds a monitor configuration to the apply queue.
--- @param name string: Monitor identifier (e.g. "desc:LG Electronics 0x1234")
--- @param resolution string: Monitor resolution and refresh (e.g. "1920x1080@60.00Hz")
--- @param position string: Screen position (e.g. "0x0")
--- @param scale string: Monitor scaling factor (e.g. "1.0")
--- @param workspaces table: Optional list of workspaces assigned to this monitor
function M.add(name, resolution, position, scale, workspaces)
	assert(type(name) == "string", "Monitor name must be a string")
	assert(type(resolution) == "string", "Resolution must be a string")
	assert(type(position) == "string", "Position must be a string")
	assert(type(scale) == "string", "Scale must be a string")
	assert(workspaces == nil or type(workspaces) == "table", "Workspaces must be a table or nil")

	table.insert(_queue, {
		name = name,
		resolution = resolution,
		position = position,
		scale = scale,
		workspaces = workspaces or {},
	})
end

--- Marks a monitor for disabling.
--- @param name string: The monitor name or description to disable
function M.disable(name)
	assert(type(name) == "string", "Monitor name must be a string")
	table.insert(_disabled, name)
end

--- Applies all configured monitors and disabled ones using C++ bridge.
function M.apply()
	for _, m in ipairs(_queue) do
		-- luacheck: push ignore 113
		if __hypr_add_monitor then
			__hypr_add_monitor(m.name, m.resolution, m.position, m.scale, m.workspaces)
		-- luacheck: pop
		else
			error("__hypr_add_monitor is not defined in Lua runtime")
		end
	end

	for _, name in ipairs(_disabled) do
		-- luacheck: push ignore 113
		if __hypr_disable_monitor then
			__hypr_disable_monitor(name)
		-- luacheck: pop
		else
			error("__hypr_disable_monitor is not defined in Lua runtime")
		end
	end
end

return M
