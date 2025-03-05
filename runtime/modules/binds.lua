--- Keybindings Module
--- This module provides functionality to define, manage, and persist keybindings.
--- Users can set keybindings with specific modifiers, keys, actions, and options.
---
--- @module "binds"

local binds = {}

local utils = require("runtime.libs.utils")

--- List of all defined keybindings.
---Each keybinding is a table containing modifiers, key, action, arguments, flags, and description.
---
---@table binds.list
binds.list = {}

--- Default keys used in the keybinding system.
---
---@table binds.default_keys
binds.default_keys = {
	"Return",
	"Backspace",
}

--- Default options for keybindings.
---These defaults are used when specific options are not provided during keybinding setup.
---
---@class binds.default_options
---@field flags string Flags for the bind (e.g., "MODIFIER"). Default is `""`.
---@field description string Description of the bind action. Default is `""`.
binds.default_options = {
	flags = "", -- Flags for the bind (e.g., "MODIFIER")
	description = "", -- Description of the bind action
}

--- Sets a new keybinding.
---Validates input parameters and inserts the new bind into the internal list.
---
---@function binds.set
---@param modifiers string The modifier keys (e.g., "Ctrl", "Alt").
---@param key string The key to bind (e.g., "Return", "Backspace").
---@param action string The action to perform when the keybinding is triggered.
---@param arguments string|nil Optional arguments for the action. Default is `""`.
---@param options table|nil Optional table containing `flags` and `description`.
---@raise error If any input parameter is invalid or contains invalid flags.
---
---@usage
---binds.set("Ctrl", "C", "copy", nil, { flags = "c", description = "Copy selected text" })
function binds.set(modifiers, key, action, arguments, options)
	-- Ensure options is a table if provided, else use defaults
	options = options or binds.default_options

	-- Validate the input parameters
	utils.validate({
		modifiers = { modifiers, "string" },
		key = { key, "string" },
		action = { action, "string" },
		arguments = { arguments, "string", true }, -- 'arguments' is optional
		options = { options, "table", true }, -- 'options' is optional
	})

	-- Validate flags
	if options.flags then
		local allowed_flags = {
			l = true,
			r = true,
			e = true,
			n = true,
			m = true,
			t = true,
			i = true,
			s = true,
			d = true,
			p = true,
		}
		for char in options.flags:gmatch(".") do
			if not allowed_flags[char] then
				error(string.format("Invalid flag '%s' in options.flags", char))
			end
		end
	end

	-- Insert the new bind into the internal list
	table.insert(binds.list, {
		modifiers = modifiers,
		key = key,
		action = action,
		arguments = arguments or "",
		flags = options.flags or binds.default_options.flags,
		description = options.description or binds.default_options.description,
	})
end

return binds
