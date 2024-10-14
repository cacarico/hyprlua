local utils = require("src.libs.utils")
-- local utils = require("hyprlua.libs.utils")

local binds = {}

-- Internal binds list
binds.list = {}

-- NOTE: Maybe remove this and use string instead

binds.defaultKeys = {
	"Return",
	"Backspace",
}

--- Adds a bind to the internal list.
-- @param modifiers (string) Modifier keys (e.g., "SUPER")
-- @param key (string) The key to bind (e.g., "Return")
-- @param action (string) The action dispatcher (e.g., "exec")
-- @param arguments (string) Arguments for the dispatcher (e.g., "firefox")
-- @param options (table, optional) Additional options such as flags and description
function binds.set(modifiers, key, action, arguments, options)
	options = options or {}
	utils.validate({
		modifiers = { modifiers, "string" },
		key = { key, "string" },
		action = { action, "string" },
		arguments = { arguments, "string", true },
		options = { options, "table", true },
	})

	table.insert(binds.list, {
		modifiers = modifiers,
		key = key,
		action = action,
		arguments = arguments or "",
		flags = options and options.flags or "",
		description = options and options.description or "",
	})
end

--- Writes all binds to file.
-- @param file (file) The file handle to write to
function binds.write(file)
	if #binds.list > 0 then
		file:write("# Keybindings\n")
		for _, binding in ipairs(binds.list) do
			local bindLine = string.format(
				"bind%s = %s, %s, %s, %s\n",
				binding.flags,
				binding.modifiers,
				binding.key,
				binding.action,
				binding.arguments
			)
			file:write(bindLine)
			if binding.description ~= "" then
				file:write("# " .. binding.description .. "\n")
			end
		end
		file:write("\n")
	end
end

-- NOTE: This will be used to reset the binds when using autoreload (not implemented yet)
--- Resets the binds list.
function binds.reset()
	binds.list = {}
end

return binds
