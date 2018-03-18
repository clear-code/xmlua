#!/usr/bin/env luajit

package.path = "../luacs/?.lua;" .. package.path

require("test.test-libxml2")
require("test.test-xml")
require("test.test-html")
require("test.test-html-sax-parser")
require("test.test-xml-sax-parser")
require("test.test-serialize")
require("test.test-search")
require("test.test-css-select")
require("test.test-element")
require("test.test-node-set")
require("test.test-text")

luaunit = require("luaunit")
os.exit(luaunit.LuaUnit.run())
