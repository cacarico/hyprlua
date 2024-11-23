local luaunit = require("luaunit")
local monitors = require("runtime.modules.monitors")

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
	monitors.add("Monitor1", "1920x1080@60Hz", "0x0", "1x1", { "Workspace1" })
	monitors.add("Monitor1", "1920x1080@60Hz", "1920x0", "1x1", { "Workspace1" })

	luaunit.assertEquals(#monitors.list, 2)
	local first_monitor = monitors.list[1]
	luaunit.assertEquals(first_monitor.name, "Monitor1")
	luaunit.assertEquals(first_monitor.resolution, "1920x1080@60Hz")
	luaunit.assertEquals(first_monitor.position, "0x0")
	luaunit.assertEquals(first_monitor.scale, "1x1")
	luaunit.assertEquals(first_monitor.workspaces, { "Workspace1" })
end

-- Create a LuaUnit instance and run the test suite
local runner = luaunit.LuaUnit.new()
os.exit(runner:runSuiteByInstances(TestMonitors))
