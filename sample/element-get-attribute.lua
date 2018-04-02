#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root class='A'/>")
local root = document:root()

-- Uses dot syntax to get attribute value
print(root.class)
-- -> A

-- Uses [] syntax to get attribute value
print(root["class"])
-- -> A

-- Uses get_attribute method to get attribute value
print(root:get_attribute("class"))
-- -> A

local xml = [[
<root xmlns:example="http://example.com/"
      example:attribute="value-example"
      attribute="value"
      nonexistent-namespace:attribute="value-nonexistent-namespace"/>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()

-- With namespace prefix
print(root["example:attribute"])
-- -> value-example

-- Without namespace prefix
print(root["attribute"])
-- -> value

-- With nonexistent namespace prefix
print(root["nonexistent-namespace:attribute"])
-- -> value-nonexistent-namespace
