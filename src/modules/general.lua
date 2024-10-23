--- General Module
-- This module handles general configurations for the application.
-- Users can override these defaults by passing a table of options to `general.setup`.
--
-- @module general

local utils = require("src.libs.utils")
local general = {}
local serialized_config

--- Default configuration options for the General Module.
-- Users can override these defaults by passing a table of options to `general.setup`.
--
-- @table general.defaults
-- @field border_size number Size of the window borders. Default is `1`.
-- @field no_border_on_floating boolean Disable borders on floating windows. Default is `false`.
-- @field gaps_in number Inner gaps between windows. Default is `5`.
-- @field gaps_out number Outer gaps between windows and the screen edges. Default is `20`.
-- @field gaps_workspaces number Gaps specific to workspaces. Default is `0`.
-- @field col table Color settings.
-- @field col.active_border string Hex color code for active window borders. Example: `"0xffffffff"`.
-- @field col.inactive_border string Hex color code for inactive window borders. Default is `"0xff444444"`.
-- @field col.nogroup_border string Hex color code for borders when no group is present. Default is `"0xffffaaff"`.
-- @field col.nogroup_border_active string Hex color code for active borders when no group is present. Default is `"0xffff00ff"`.
-- @field layout string Layout algorithm for window tiling. Default is `"dwindle"`.
-- @field no_focus_fallback boolean Disable fallback focus behavior. Default is `false`.
-- @field resize_on_border boolean Enable resizing windows by dragging borders. Default is `false`.
-- @field extend_border_grab_area number Extends the area for grabbing window borders. Default is `15`.
-- @field hover_icon_on_border boolean Show icons when hovering over borders. Default is `true`.
-- @field allow_tearing boolean Allow screen tearing. Default is `false`.
-- @field resize_corner number Size of the resize corner area. Default is `0`.
-- @field enabled boolean Enable snapping for floating window.
-- @field window_gap number Minimum gap in pixels between windows before snapping
-- @field monitor_gap number Minimum gap in pixels between window and monitor edges before snapping.

general.defaults = {
	allow_tearing = false,
	border_size = 1,
	col = {
		active_border = "0xffffffff",
		inactive_border = "0xff444444",
		nogroup_border = "0xffffaaff",
		nogroup_border_active = "0xffff00ff",
	},
	extend_border_grab_area = 15,
	gaps_in = 5,
	gaps_out = 20,
	gaps_workspaces = 0,
	hover_icon_on_border = true,
	layout = "dwindle",
	no_border_on_floating = false,
	no_focus_fallback = false,
	resize_corner = 0,
	resize_on_border = false,
	snap = {
		enabled = false,
		window_gap = 10,
		monitor_gap = 10,
	},
}

--- Sets up the general configuration.
-- Merges user-provided options with the default settings and serializes the configuration.
--
-- @function general.setup
-- @param opts table|nil A table containing configuration options to override defaults. Default is `nil`.
--
-- @usage
-- general.setup({
--     border_size = 2,
--     gaps_out = 25,
--     col = {
--         active_border = "0xff00ff00",
--     },
-- })
function general.setup(opts, merge_defaults)
	opts = opts or {}

	if merge_defaults and merge_defaults == true then
		-- Merge user options into the defaults
		utils.merge_tables(general.defaults, opts)
		-- Serialize the merged configuration with the module name "general"
		serialized_config = utils.serialize_config(general.defaults, "general")
	else
		-- Serialize only the user-provided options with the module name "general"
		serialized_config = utils.serialize_config(opts, "general")
	end
end

--- Saves the general configuration to a file.
-- Writes the serialized configuration to the provided file handle.
--
-- @function general.write
-- @param file userdata The file handle to write the configuration to. Typically obtained via `io.open`.
--
-- @usage
-- local file = io.open("config.lua", "w")
-- general.write(file)
-- file:close()
function general.write(file)
	if serialized_config and #serialized_config > 0 then
		file:write("# GENERAL\n")
		file:write(serialized_config)
		file:write("\n\n")
	end
end

return general
