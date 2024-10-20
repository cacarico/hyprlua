--- Handles keybindings and other utilities for keys
-- Allowed flags for keybindings.
-- Each flag modifies the behavior of the bind in a specific way.
--
-- `l`
-- `r`
-- `e`
-- `n`
-- `m`
-- `t`
-- `i`
-- `s`
-- `d`
-- `p`
--
-- **Note:** Multiple flags can be combined by concatenating their letters (e.g., `"lr"` for locked release).
-- @module binds
-- @field list table<string, any> Internal list to store all configured binds.
-- @field defaultKeys table<string> Default keys available for binding.
-- @field defaultOptions table<string, any> Default options for keybindings.
local binds = {}

local utils = require("src.libs.utils")

binds.list = {}

binds.defaultKeys = {
    "Return",
    "Backspace",
}

binds.defaultOptions = {
    flags = "", -- Flags for the bind (e.g., "MODIFIER")
    description = "", -- Description of the bind action
}


--- Adds a bind to the internal list.
--
-- This function validates the provided parameters and adds a new keybinding
-- to the internal list. It ensures that the required fields are of the correct
-- type and handles optional parameters gracefully.
--
-- @function binds.set
-- @param modifiers string Modifier keys (e.g., `"SUPER"`, `"CTRL+SHIFT"`)
-- @param key string The key to bind (e.g., `"Return"`, `"Backspace"`)
-- @param action string The action dispatcher (e.g., `"exec"`, `"toggle"`)
-- @param arguments string Arguments for the dispatcher (e.g., `"firefox"`, `"volume_up"`)
-- @param options table Additional options for the bind, with the following fields:
--   - **flags** (string, optional): Flags that modify the bind's behavior. Allowed flags:
--     - `l` : Locked
--     - `r` : Release
--     - `e` : Repeat
--     - `n` : Non-consuming
--     - `m` : Mouse
--     - `t` : Transparent
--     - `i` : Ignore Mods
--     - `s` : Separate
--     - `d` : Description
--     - `p` : Bypass Inhibit
--   - **description** (string, optional): A human-readable description of the bind's purpose.
--
-- @usage
-- binds.set("SUPER", "Return", "exec", "firefox", {
--     flags = "ld",
--     description = "Launch Firefox browser with lockscreen access",
-- })
function binds.set(modifiers, key, action, arguments, options)
    -- Ensure options is a table if provided, else use defaults
    options = options or binds.defaultOptions

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
            p = true
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
        flags = options.flags or binds.defaultOptions.flags,
        description = options.description or binds.defaultOptions.description,
    })
end

--- Writes all configured binds to a file.
--
-- This function serializes the internal binds list and writes it to the provided
-- file handle. Each bind is formatted appropriately, and descriptions are included
-- as comments for clarity.
--
-- @function binds.write
-- @param file file The file handle to write the binds to
--
-- @usage
-- local file = io.open("keybindings.lua", "w")
-- binds.write(file)
-- file:close()
function binds.write(file)
    if #binds.list > 0 then
        file:write("-- Keybindings Configuration\n")
        for _, bind in ipairs(binds.list) do
            local bind_line = string.format(
                'bind%s = { modifiers = "%s", key = "%s", action = "%s", arguments = "%s" }\n',
                bind.flags,
                bind.modifiers,
                bind.key,
                bind.action,
                bind.arguments
            )
            file:write(bind_line)
            if bind.description ~= "" then
                file:write("-- " .. bind.description .. "\n")
            end
        end
        file:write("\n")
    end
end

--- Resets the internal binds list.
--
-- This function clears all configured binds from the internal list. It is intended
-- to be used when reloading configurations dynamically (e.g., during autoreload).
--
-- @function binds.reset
--
-- @usage
-- binds.reset()
function binds.reset()
    binds.list = {}
end

return binds
