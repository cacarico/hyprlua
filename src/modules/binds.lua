local utils = require("src.libs.utils")
-- local utils = require("hyprlua.libs.utils")

local binds = {}

-- Internal binds list
binds.list = {}

-- NOTE: Maybe remove this and use string instead

-- Flag definitions with dual access
binds.flags = {
	-- Descriptive names
	LOCKED = "l",
	RELEASE = "r",
	REPEAT = "e",
	NON_CONSUMING = "n",
	MOUSE = "m",
	TRANSPARENT = "t",
	IGNORE_MODS = "i",
	SEPARATE = "s",
	DESCRIPTION = "d",
	BYPASS_INHIBIT = "p",

	-- Single-character keys
	l = "l",
	r = "r",
	e = "e",
	n = "n",
	m = "m",
	t = "t",
	i = "i",
	s = "s",
	d = "d",
	p = "p",
}

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
			local flagString = binding.flags ~= "" and binding.flags or ""

			local bindLine = string.format(
				"bind%s = %s, %s, %s, %s\n",
				flagString,
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
