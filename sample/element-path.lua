#!/usr/bin/env luajit

local xmlua = require("xmlua")

local xml = [[
<root>
  <child1>child1 text</child1>
  <child2>child2 text</child2>
</root>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()
-- Gets all child elements of <root> (<child1> and <child2>)
local children = root:children()

-- Returns XPath of <root>'s all child elements.
for _, child in ipairs(children) do
  print(child:path())
  --/root/child1
  --/root/child2
end

