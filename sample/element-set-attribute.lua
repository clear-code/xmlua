#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root/>")
local root = document:root()

-- Uses dot syntax to set attribute value
root.class = "A"
print(root.class)
-- -> A

-- Uses [] syntax to set attribute value
root["class"] = "B"
print(root["class"])
-- -> B

-- Uses set_attribute method to set attribute value
root:set_attribute("class", "C")
print(root:get_attribute("class"))
-- -> C

-- Removes an attribute by setting nil
root.class = nil
print(root:to_xml())
-- <root/>

-- Adds a namespace declaration
root["xmlns:example"] = "http://example.com/"
print(root:to_xml())
-- <root xmlns:example="http://example.com/"/>

-- Adds a new attribute with namespace
root["example:attribute"] = "with namespace"
print(root:to_xml())
-- <root xmlns:example="http://example.com/" example:attribute="with namespace"/>

-- Removes namespace declaration. It unsets the namespace of
-- existing elements and attributes.
root["xmlns:example"] = nil
print(root:to_xml())
-- <root attribute="with namespace"/>
