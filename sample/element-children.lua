#!/usr/bin/env luajit

local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()

-- Gets all child elements of <root> (<sub1>, <sub2> and <sub3>)
local subs = root:children()

print(#subs)
-- 3
print(subs[1]:to_xml())
-- <sub1/>
print(subs[2]:to_xml())
-- <sub2/>
print(subs[3]:to_xml())
-- <sub3/>
