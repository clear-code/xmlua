#!/usr/bin/env luajit

require("test.test-libxml2")
require("test.test-html")

luaunit = require("luaunit")
os.exit(luaunit.LuaUnit.run())
