--- Hyprlua Library
--- This library handles everything
--- @module hyprlua

local binds = require("runtime.modules.binds")
local general = require("runtime.modules.general")
local monitors = require("runtime.modules.monitors")
local decoration = require("runtime.modules.decoration")
local logs = require("runtime.libs.logs")

local hyprlua = {
	decoration = decoration,
	general = general,
	monitors = monitors,
	binds = binds,
}

--- Writes all module configurations to a specified file.
-- This function serializes each module's configuration and writes them sequentially to the provided file.
--
-- @function hyprlua.write_hyprland_configuration
-- @param file_path string The path to the file where configurations will be saved.
-- @return boolean `true` if the operation succeeds, otherwise `false` along with an error message.
--
-- @usage
-- local success, err = hyprlua.write_hyprland_configuration("config.lua")
-- if not success then
--     print("Error writing configurations:", err)
-- end
function hyprlua.write_hyprland_configuration(file_path)
	-- Attempt to open the file in write mode
	local file, err = io.open(file_path, "w")
	if not file then
		return false, "Could not open file: " .. err
	end
	general.write(file)
	decoration.write(file)
	binds.write(file)
	monitors.write(file)

	-- Close the file handle
	file:close()
	return true
end

-- Function to reset all configurations
function hyprlua.reset_config()
	-- Reset binds
	binds.reset()
	-- Reset other configurations if necessary
end

return hyprlua
