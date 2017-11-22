#!/usr/bin/env luajit

require("test.test-libxml2")

luaunit = require("luaunit")
os.exit(luaunit.LuaUnit.run())
