#!/usr/bin/env luajit

local xmlua = require("xmlua")

local xml = [[
<root>
  text1
  <child1>child1 text</child1>
  text2
  <child2>child2 text</child2>
  text3
</root>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()

-- The <root>'s content. Spaces are also the <root>'s content.
print(root:content())
--
--  text1
--  child1 text
--  text2
--  child2 text
--  text3
--
