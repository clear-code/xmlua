#!/usr/bin/env luajit

local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Searches the <root> element
local root_node_set = document:search("/root")

-- You can use "#" for getting the number of matched nodes
print(#root_node_set) -- -> 1

-- You can access the N-th node by "[]".
-- It's 1-origin like normal table.
local root = root_node_set[1] -- xmlua.Element
print(root:to_xml())
-- <root>
--   <sub1>text1</sub1>
--   <sub2>text2</sub2>
--   <sub3>text3</sub3>
-- </root>

-- Searches all sub elements under the <root> element
local all_subs = root:search("*")

-- You can use "#" for getting the number of matched nodes
print(#all_subs) -- -> 3

-- You can access the N-th node by "[]".
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
