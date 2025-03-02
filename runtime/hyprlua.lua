--- Hyprlua Library
--- This library handles everything
--- @module "hyprlua"

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
return hyprlua
