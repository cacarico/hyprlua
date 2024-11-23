--- Logs module
--- This module handles logs and colors
---
--- @module logs

local logs = {}
local log_level = "debug"

-- ANSI color codes for enhanced terminal output
local colors = {
	reset = "\27[0m",
	red = "\27[31m",
	green = "\27[32m",
	yellow = "\27[33m",
	blue = "\27[34m",
	magenta = "\27[35m",
	cyan = "\27[36m",
	white = "\27[37m",
}

--- Prints colored message
local function print_colored(color, message)
	print(color .. message .. colors.reset)
end

--- Logs an error message on terminal
--- @param message (string) A message to be printed as error
--- @param err (string|nil) The error message
---
--- @usage
--- logs.error("This is an error")
function logs.error(message, err)
	if err then
		print_colored(colors.red, message .. err)
	else
		print_colored(colors.red, message)
	end
end

--- Logs an warning message on terminal
--- @param message (string) A message to be printed as error
--- @param warning (string|nil) The warning message
---
--- @usage
--- logs.warning("This is an error")
function logs.warning(message, warning)
	if warning then
		print_colored(colors.yellow, message .. warning)
	else
		print_colored(colors.yellow, message)
	end
end

--- Logs a message on terminal
--- @param message (string) A message to be printed as error
---
--- @usage
--- logs.print("Logs a message on terminal")
function logs.print(message)
	print_colored(colors.white, message)
end

--- Logs a verbose message on terminal
--- @param message (string) A message to be printed as error
---
--- @usage
--- logs.debug("Logs debug error")
function logs.debug(message)
	if log_level == "debug" then
		logs.print_colored(logs.colors.cyan, "[Debug]: " .. message)
	end
end

return logs
