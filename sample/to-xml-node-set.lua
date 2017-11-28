#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]])

-- All elements under <root> (<sub1>, <sub2> and <sub3>)
local node_set = document:search("/root/*")

-- Serializes all elements as XML and concatenates serialized XML
print(node_set:to_xml())
-- <sub1>text1</sub1><sub2>text2</sub2><sub3>text3</sub3>

-- FYI: <sub1> serialization
print(node_set[1]:to_xml())
-- <sub1>text1</sub1>

-- FYI: <sub2> serialization
print(node_set[2]:to_xml())
-- <sub2>text2</sub2>

-- FYI: <sub3> serialization
print(node_set[3]:to_xml())
-- <sub3>text3</sub3>
