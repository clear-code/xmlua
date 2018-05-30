#!/usr/bin/env luajit

package.path = "../luacs/?.lua;" .. package.path

require("test.test-libxml2")
require("test.test-xml")
require("test.test-html")
require("test.test-html-sax-parser")
require("test.test-xml-sax-parser")
require("test.test-xml-stream-sax-parser")
require("test.test-serialize")
require("test.test-search")
require("test.test-css-select")
require("test.test-xml-build")
require("test.test-html-build")
require("test.test-document")
require("test.test-element")
require("test.test-node-set")
require("test.test-text")
require("test.test-comment")
require("test.test-processing-instruction")

luaunit = require("luaunit")
os.exit(luaunit.LuaUnit.run())
