local utils = require("src.libs.utils")
local general = {}
local serialized_config = {}

general.defaults = {

	border_size = 1,
	no_border_on_floating = false,
	gaps_in = 5,
	gaps_out = 20,
	gaps_workspaces = 0,
	col = {
		active_border = "0xffffffff",
		inactive_border = "0xff444444",
		nogroup_border = "0xffffaaff",
		nogroup_border_active = "0xffff00ff",
	},
	layout = "dwindle",
	no_focus_fallback = false,
	resize_on_border = false,
	extend_border_grab_area = 15,
	hover_icon_on_border = true,
	allow_tearing = false,
	resize_corner = 0,
}

--- Creates the general configuration
---
function general.setup(opts)
	opts = opts or {}

  -- NOTE: Adds validation
  --
	-- utils.validate({
	-- 	border_size = { opts.border_size, "number" },
	-- 	no_border_on_floating = { opts.no_border_on_floating, "boolean" },
	-- 	gaps_in = { opts.gaps_in, "number" },
	-- 	gaps_out = { opts.gaps_out, "number" },
	-- 	gaps_workspaces = { opts.gaps_workspaces, "number" },
	-- 	col = { opts.col, "table" },
	-- 	layout = { opts.layout, "string" },
	-- 	-- no_focus_fallback = { opts.no_focus_fallback, "boolean" },
	-- 	resize_on_border = { opts.resize_on_border, "boolean" },
	-- 	extend_border_grab_area = { opts.extend_border_grab_area, "number" },
	-- 	-- hover_icon_on_border = { opts.hover_icon_on_border, "boolean" },
	-- 	allow_tearing = { opts.allow_tearing, "boolean" },
	-- 	resize_corner = { opts.resize_corner, "number" },
	-- })

	-- -- Validate nested 'col' table if provided
	-- if opts.col then
	-- 	utils.validate({
	-- 		col_active_border = { opts.col.active_border, "string" },
	-- 		col_inactive_border = { opts.col.inactive_border, "string" },
	-- 		col_nogroup_border = { opts.col.nogroup_border, "string" },
	-- 		col_nogroup_border_active = { opts.col.nogroup_border_active, "string" },
	-- 	})
	-- end

	utils.merge_tables(general.defaults, opts)
  serialized_config = utils.serialize_config(general.defaults, "config")
  print(serialized_config)

end

function general.write(file)
  if #serialized_config > 0 then
    file:write("# GENERAL\n")
    file:write(serialized_config)
		file:write("\n\n")
  end
end

return general
