local binds = require("src.modules.binds")
local general = require("src.modules.general")
-- local binds = require("hyprlua.modules.binds")

local hyprlua = {}

-- Expose binds module
hyprlua.binds = binds
hyprlua.general = general

-- Function to write all configurations to the file
function hyprlua.writeToFile(file_path)
	local file, err = io.open(file_path, "w")
	if not file then
		return false, "Could not open file: " .. err
	end

	general.write(file)
	binds.write(file)

	file:close()
	return true
end

-- Function to reset all configurations
function hyprlua.resetConfig()
	-- Reset binds
	binds.reset()
	-- Reset other configurations if necessary
end

return hyprlua
