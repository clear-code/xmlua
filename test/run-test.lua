#!/usr/bin/env luajit

require("test.test-libxml2")
require("test.test-xml")
require("test.test-html")
require("test.test-search")

luaunit = require("luaunit")
os.exit(luaunit.LuaUnit.run())
