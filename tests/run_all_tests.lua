-- tests/run_all_tests.lua
local luaunit = require("luaunit")

-- Require all individual test modules
require("test_monitors")
-- require('test_another')  -- Add more tests as needed

-- Execute all tests
os.exit(luaunit.LuaUnit.run())
