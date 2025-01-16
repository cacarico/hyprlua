--- Decoration Module
--- This module handles decorations and blur effects.
--
--- @module decoration

local utils = require("runtime.libs.utils")
local decoration = {}
local serialized_config

--- Default configuration options for the Decoration Module.
--- Users can override these defaults by passing a table of options to `decoration.setup`.
--
--- @table decoration.defaults
--- @field rounding number The corner rounding radius. Default is `0`.
--- @field active_opacity number Opacity when active. Range: `0.0` to `1.0`. Default is `1.0`.
--- @field inactive_opacity number Opacity when inactive. Range: `0.0` to `1.0`. Default is `1.0`.
--- @field fullscreen_opacity number Opacity in fullscreen mode. Range: `0.0` to `1.0`. Default is `1.0`.
--- @field drop_shadow boolean Enable or disable drop shadows. Default is `true`.
--- @field shadow_range number The range of the shadow effect. Default is `4`.
--- @field shadow_render_power number The power level of shadow rendering. Default is `3`.
--- @field shadow_ignore_window boolean Whether shadows should ignore window decorations. Default is `true`.
--- @field shadow_offset boolean Enable or disable shadow offsets. Default is `true`.
--- @field shadow_scale string  Scaling factors for shadows. Default is `"0x0"`.
--- @field col table Color settings for shadows.
--- @field col.shadow string Hex color code for active shadows. Example: `"0xee1a1a1a"`.
--- @field col.shadow_inactive string Hex color code for inactive shadows. Default is `"nil"`.
--- @field blur table Blur settings.
--- @field blur.brightness number Brightness level for blur. Default is `0.8172`.
--- @field blur.contrast number Contrast level for blur. Default is `0.8916`.
--- @field blur.enabled boolean Enable or disable blur effect. Default is `true`.
--- @field blur.ignore_opacity boolean Whether to ignore opacity in blur. Default is `false`.
--- @field blur.new_optimizations boolean Enable new optimizations for blur. Default is `true`.
--- @field blur.noise number Noise level for blur. Default is `0.0117`.
--- @field blur.passes number Number of blur passes. Default is `1`.
--- @field blur.popups boolean Enable or disable blur for popups. Default is `false`.
--- @field blur.popups_ignorealpha number Opacity to ignore for popups. Default is `0.3`.
--- @field blur.size number Blur size. Default is `8`.
--- @field blur.special boolean Special blur parameter. Default is `false`.
--- @field blur.vibrancy number Vibrancy level for blur. Default is `0.1696`.
--- @field blur.vibrancy_darkness number Vibrancy darkness level. Default is `0.0`.
--- @field blur.xray boolean Enable xray effect in blur. Default is `false`.
--- @field dim_inactive boolean Enable or disable dimming for inactive elements. Default is `false`.
--- @field dim_strength number Strength of the dim effect. Default is `0.5`.
--- @field dim_special number Special dimming parameter. Default is `0.2`.
--- @field dim_around number Dim amount around elements. Default is `0.4`.
--- @field screen_shader string Path or identifier for the screen shader. Default is `""`.

decoration.defaults = {
	active_opacity = 1.0,
	blur = {
		brightness = 0.8172,
		contrast = 0.8916,
		enabled = true,
		ignore_opacity = false,
		new_optimizations = true,
		noise = 0.0117,
		passes = 1,
		popups = false,
		popups_ignorealpha = 0.3,
		size = 8,
		special = false,
		vibrancy = 0.1696,
		vibrancy_darkness = 0.0,
		xray = false,
	},
	col = {
		shadow = "0xee1a1a1a",
		shadow_inactive = "nil",
	},
	dim_around = 0.4,
	dim_inactive = false,
	dim_special = 0.2,
	dim_strength = 0.5,
	drop_shadow = true,
	fullscreen_opacity = 1.0,
	inactive_opacity = 1.0,
	rounding = 0,
	screen_shader = "",
	shadow_ignore_window = true,
	shadow_offset = true,
	shadow_range = 4,
	shadow_render_power = 3,
	shadow_scale = "0x0",
}

--- Sets up the Decoration Module with user-provided options.
--
--- This function merges user-provided options with the default configuration.
--
--- @param opts (table) A table of options to apply. See `decoration.defaults` for available options.
--
--- @usage
--- decoration.setup({
---     rounding = 10,
---     active_opacity = 0.9,
---     col = {
---         shadow = "0xee000000",
---     },
--- })
function decoration.setup(opts, merge_defaults)
	opts = opts or {}

	if merge_defaults and merge_defaults == true then
		utils.merge_tables(decoration.defaults, opts)
		serialized_config = utils.serialize_config(decoration.defaults, "decoration")
	else
		serialized_config = utils.serialize_config(opts, "decoration")
	end
	-- print(serialized_config)
end

--- Writes the serialized configuration to a file.
--
--- @param file (file) The file object to write the configuration to.
--
--- @usage
--- local file = io.open("config.lua", "w")
--- decoration.write(file)
--- file:close()
function decoration.write(file)
	if #serialized_config > 0 then
		file:write("# DECORATION CONFIGURATION\n")
		file:write(serialized_config)
		file:write("\n\n")
	end
end

return decoration
