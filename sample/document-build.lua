#!/usr/bin/env luajit

local xmlua = require("xmlua")

-- Empty tree
local tree = {}
local document = xmlua.XML.build(tree)
print(document:to_xml())
