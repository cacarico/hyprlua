--- Decoration Module
-- This module handles decorations and blur
-- @module decoration

local utils = require("src.libs.utils")
local decoration = {}
local serialized_config

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

--- Setup decoration configuration
--- @param opts (table) Table of options to apply
function decoration.setup(opts)
	opts = opts or {}

  utils.merge_tables(decoration.defaults, opts)
  serialized_config = utils.serialize_config(decoration.defaults, "decoration")
  print(serialized_config)
end

function decoration.write(file)
	if #serialized_config > 0 then
		file:write("# DECORATION\n")
		file:write(serialized_config)
		file:write("\n\n")
	end
end

return decoration
