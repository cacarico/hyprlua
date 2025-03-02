--- Decoration Module
--- This module handles decorations and blur effects.
---
--- @module 'decoration'

local log = require("runtime.common.logs")
local utils = require("runtime.libs.utils")
local decoration = {}
local serialized_config

--- Default configuration options for the decoration module.
--- users can override these defaults by passing a table of options to `decoration.setup`.
---
--- @class defaults.decoration
--- @field active_opacity (number) Opacity when active. Range: `0.0` to `1.0`. Default is `1.0`.
--- @field dim_around (number) Dim amount around elements. Default is `0.4`.
--- @field dim_inactive (boolean) Enable or disable dimming for inactive elements. Default is `false`.
--- @field dim_special (number) Special dimming parameter. Default is `0.2`.
--- @field dim_strength (number) Strength of the dim effect. Default is `0.5`.
--- @field fullscreen_opacity (number) Opacity in fullscreen mode. Range: `0.0` to `1.0`. Default is `1.0`.
--- @field inactive_opacity (number) Opacity when inactive. Range: `0.0` to `1.0`. Default is `1.0`.
--- @field rounding (number) The corner rounding radius. Default is `0`.
--- @field screen_shader (string) Path or identifier for the screen shader. Default is `""`.
defaults.decoration = {
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
	user_options.decoration = opts or {}

	if merge_defaults == true then
		utils.merge_tables(user_options.decoration, user_options.decoration)
	end
	log.debug(serialized_config)
end

--- Default blur options for the decoration module.
--- users can override these defaults by passing a table of options to `decoration.setup`.
---
--- @class defaults.blur
--- @field brightness (number) Brightness level for blur. Default is `0.8172`.
--- @field contrast (number) Contrast level for blur. Default is `0.8916`.
--- @field enabled (boolean) Enable or disable blur effect. Default is `true`.
--- @field ignore_opacity (boolean) Whether to ignore opacity in blur. Default is `false`.
--- @field new_optimizations (boolean) Enable new optimizations for blur. Default is `true`.
--- @field noise (number) Noise level for blur. Default is `0.0117`.
--- @field passes (number) Number of blur passes. Default is `1`.
--- @field popups (boolean) Enable or disable blur for popups. Default is `false`.
--- @field popups_ignorealpha (number) Opacity to ignore for popups. Default is `0.3`.
--- @field size (number) Blur size. Default is `8`.
--- @field special (boolean) Special blur parameter. Default is `false`.
--- @field vibrancy (number) Vibrancy level for blur. Default is `0.1696`.
--- @field vibrancy_darkness (number) Vibrancy darkness level. Default is `0.0`.
--- @field xray (boolean) Enable xray effect in blur. Default is `false`.
defaults.blur = {
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
}

--- Sets the blur options
---
--- this function merges user-provided options with the default configuration.
---
--- @param opts (table) a table of options to apply. see `decoration.blur` for available options.
--- @param merge_defaults (boolean|nil) merge defaults table with user provided options
---
--- @usage
--- decoration.blur({
---     brightness = 0.9,
---     contrast = 0.9,
--- })
function decoration.blur(opts, merge_defaults)
	opts = opts or {}

	if merge_defaults and merge_defaults == true then
		utils.merge_tables(defaults.decoration, opts)
	end
end

--- Default shadow options for the decoration module.
--- users can override these defaults by passing a table of options to `decoration.setup`.
---
--- @class defaults.shadow
--- @field enabled (boolean) Enable drop shadows on windows
--- @field range (number) Shadow range (“size”) in layout px
--- @field render_power (number) In what power to render the falloff (more power, the faster the falloff) [1 - 4]
--- @field sharp (boolean) If enabled, will make the shadows sharp, akin to an infinite render power
--- @field ignore_window (boolean) If true, the shadow will not be rendered behind the window itself, only around it
--- @field color (string) Shadow’s color. Alpha dictates shadow’s opacity.
--- @field color_inactive (string) Inactive shadow color. (if not set, will fall back to color)
--- @field offset (string) Shadow’s rendering offset
--- @field scale (number) Shadow’s scale. [0.0 - 1.0]
defaults.shadow = {
	enabled = true,
	range = 4,
	render_power = 3,
	sharp = false,
	ignore_window = true,
	color = "0xee1a1a1a",
	color_inactive = "",
	offset = "0,0",
	scale = 1.0,
}

--- Sets options for shadows
---
--- this function merges user-provided options with the default configuration.
---
--- @param opts (table) a table of options to apply. see `decoration.shadow` for available options.
--- @param merge_defaults (boolean|nil) merge defaults table with user provided options
---
--- @usage
--- decoration.shadow({
---     enabled = true,
---     render_power = 1,
--- })
function decoration.shadow(opts, merge_defaults)
	if opts then
		utils.validate({
			enabled = { opts.enabled, "boolean", false },
			range = { opts.range, "number", false },
			render_power = { opts.render_power, "number", false },
			sharp = { opts.sharp, "boolean", false },
			ignore_window = { opts.ignore_window, "boolean", false },
			color = { opts.color, "string", false },
			color_inactive = { opts.color_inactive, "string", false },
			offset = { opts.offset, "string", false },
			scale = { opts.scale, "number", false },
		})
	else
		opts = {}
	end

	if merge_defaults and merge_defaults == true then
		utils.merge_tables(defaults.decoration, opts)
	end
end

return decoration
