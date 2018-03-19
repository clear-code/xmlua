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

-- Searches the 2nd sub element under the <root> element
local second_subs = document:css_select("root :nth-child(2)")

-- You can use "#" for getting the number of matched nodes
print(#second_subs) -- -> 1

-- You can access the N-th node by "[]".
print(second_subs[1]:to_xml()) -- -> <sub2>text2</sub2x>
