--- Decoration Module
-- This module handles decorations and blur effects.
--
-- @module decoration

local utils = require("src.libs.utils")
local decoration = {}
local serialized_config

--- Default configuration options for the Decoration Module.
-- Users can override these defaults by passing a table of options to `decoration.setup`.
--
-- @table decoration.defaults
-- @field rounding number The corner rounding radius. Default is `0`.
-- @field active_opacity number Opacity when active. Range: `0.0` to `1.0`. Default is `1.0`.
-- @field inactive_opacity number Opacity when inactive. Range: `0.0` to `1.0`. Default is `1.0`.
-- @field fullscreen_opacity number Opacity in fullscreen mode. Range: `0.0` to `1.0`. Default is `1.0`.
-- @field drop_shadow boolean Enable or disable drop shadows. Default is `true`.
-- @field shadow_range number The range of the shadow effect. Default is `4`.
-- @field shadow_render_power number The power level of shadow rendering. Default is `3`.
-- @field shadow_ignore_window boolean Whether shadows should ignore window decorations. Default is `true`.
-- @field col table Color settings for shadows.
-- @field col.shadow string Hex color code for active shadows. Example: `"0xee1a1a1a"`.
-- @field col.shadow_inactive string Hex color code for inactive shadows. Default is `"nil"`.
-- @field shadow_offset boolean Enable or disable shadow offsets. Default is `true`.
-- @field shadow_scale table Scaling factors for shadows. Default is `{ 0, 0 }`.
-- @field dim_inactive boolean Enable or disable dimming for inactive elements. Default is `false`.
-- @field dim_strength number Strength of the dim effect. Default is `0.5`.
-- @field dim_special number Special dimming parameter. Default is `0.2`.
-- @field dim_around number Dim amount around elements. Default is `0.4`.
-- @field screen_shader string Path or identifier for the screen shader. Default is `""`.

decoration.defaults = {
	rounding = 0,
	active_opacity = 1.0,
	inactive_opacity = 1.0,
	fullscreen_opacity = 1.0,
	drop_shadow = true,
	shadow_range = 4,
	shadow_render_power = 3,
	shadow_ignore_window = true,
	col = {
		shadow = "0xee1a1a1a",
		shadow_inactive = "nil",
	},
	shadow_offset = true,
	shadow_scale = { 0, 0 },
	dim_inactive = false,
	dim_strength = 0.5,
	dim_special = 0.2,
	dim_around = 0.4,
	screen_shader = "",
}

--- Sets up the Decoration Module with user-provided options.
--
-- This function merges user-provided options with the default configuration.
--
-- @param opts (table) A table of options to apply. See `decoration.defaults` for available options.
--
-- @usage
-- decoration.setup({
--     rounding = 10,
--     active_opacity = 0.9,
--     col = {
--         shadow = "0xee000000",
--     },
-- })
function decoration.setup(opts)
	opts = opts or {}
	utils.merge_tables(decoration.defaults, opts)
	serialized_config = utils.serialize_config(decoration.defaults, "decoration")
	print(serialized_config)
end

--- Writes the serialized configuration to a file.
--
-- @param file (file) The file object to write the configuration to.
--
-- @usage
-- local file = io.open("config.lua", "w")
-- decoration.write(file)
-- file:close()
function decoration.write(file)
	if #serialized_config > 0 then
		file:write("-- DECORATION CONFIGURATION\n")
		file:write(serialized_config)
		file:write("\n\n")
	end
end

return decoration
