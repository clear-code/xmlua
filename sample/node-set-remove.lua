#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<xml>
  <header>
    <title>This is test</title>
  </header>
  <contents>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </contents>
</xml>
]])

--Remove node
local node_set = document:search("//xml/contents/*")
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>
local removed_node = node_set:remove(node_set[1])
-- "<sub1>sub1</sub1>" is removed
print(removed_node:to_xml())
-- <sub1>sub1</sub1>
print(node_set:to_xml())
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>

-- Remove node with position
local node_set = document:search("//xml/contents/*")
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>
local removed_node = node_set:remove(2)
-- "<sub2>sub2</sub2>" is removed
print(removed_node:to_xml())
-- <sub2>sub2</sub2>
print(node_set:to_xml())
-- <sub1>sub1</sub1>
-- <sub3>sub3</sub3>
