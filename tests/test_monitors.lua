local luaunit = require("luaunit")
local monitors = require("modules.monitors")

-- Reset function to clear monitors before each test
local function reset_monitors()
	monitors.list = {}
	monitors.disabled = {}
end

-- Test Suite for monitors module
local TestMonitors = {}

function TestMonitors.setUp()
	reset_monitors()
end

-- Test adding a monitor
function TestMonitors.test_add_monitor()
	monitors.add("Monitor1", "1920x1080@60Hz", "left", "1x1", { "Workspace1" })

	luaunit.assertEquals(#monitors.list, 1)
	local monitor = monitors.list[1]
	luaunit.assertEquals(monitor.name, "Monitor1")
	luaunit.assertEquals(monitor.resolution, "1920x1080@60Hz")
	luaunit.assertEquals(monitor.position, "left")
	luaunit.assertEquals(monitor.scale, "1x1")
	luaunit.assertEquals(monitor.workspaces, { "Workspace1" })
end

-- Create a LuaUnit instance and run the test suite
local runner = luaunit.LuaUnit.new()
os.exit(runner:runSuiteByInstances(TestMonitors))
