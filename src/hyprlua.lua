--- Hyprlua Library
-- This library handles everything
-- @module hyprlua

local binds = require("src.modules.binds")
local general = require("src.modules.general")
local monitors = require("src.modules.monitors")
local decoration = require("src.modules.decoration")
local logs = require("src.libs.logs")

local hyprlua = {
	decoration = decoration,
	general = general,
	monitors = monitors,
	binds = binds,
}

--- Writes all module configurations to a specified file.
-- This function serializes each module's configuration and writes them sequentially to the provided file.
--
-- @function hyprlua.write_to_file
-- @param file_path string The path to the file where configurations will be saved.
-- @return boolean `true` if the operation succeeds, otherwise `false` along with an error message.
--
-- @usage
-- local success, err = hyprlua.write_to_file("config.lua")
-- if not success then
--     print("Error writing configurations:", err)
-- end
function hyprlua.write_to_file(file_path)
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
