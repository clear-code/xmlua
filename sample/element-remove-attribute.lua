#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root
  a1="v1"
  a2="v2"
  a3="v3"/>
]])
local root = document:root()

-- Removes an attribute by settings nil as attribute value
root.a1 = nil
print(root:to_xml())
-- <root a2="v2" a3="v3"/>

-- Removes an attribute by remove_attribute
root:remove_attribute("a2")
print(root:to_xml())
-- <root a3="v3"/>

-- Document with namespace
local document = xmlua.XML.parse([[
<root
  xmlns:example="http://example.com/"
  example:a="value"/>
]])
local root = document:root()

-- Removes namespace declaration. It unsets the namespace of
-- existing elements and attributes.
root:remove_attribute("xmlns:example")
print(root:to_xml())
-- <root a="value"/>
