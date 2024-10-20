--- Hyprlua Library
-- This library handles everything
-- @module hyprlua

local binds = require("src.modules.binds")
local general = require("src.modules.general")
local monitors = require("src.modules.monitors")
local decoration = require("src.modules.decoration")

local hyprlua = {}

-- IMP: I think might be better to expose the module tables
-- Right now each time a function is called it resets their tables.
-- It's currently not a problem but maybe

-- Expose binds module
hyprlua.binds = binds
hyprlua.general = general
hyprlua.monitors = monitors
hyprlua.decoration = decoration

-- Function to write all configurations to the file
-- @param file_path (file*) A file to be saved
function hyprlua.write_to_file(file_path)
	local file, err = io.open(file_path, "w")
	if not file then
		return false, "Could not open file: " .. err
	end

	general.write(file)
	decoration.write(file)
	binds.write(file)
	monitors.write(file)

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
