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
local sub2 = document:search("/root/sub2")[1]

-- Gets the previous sibling element of <sub2>
print(sub2:previous():to_xml())
-- <sub1/>

local sub1 = sub2:previous()

-- Gets the previous sibling element of <sub1>
print(sub1:previous())
-- nil


-- Gets the next sibling element of <sub2>
print(sub2:next():to_xml())
-- <sub3/>

local sub3 = sub2:next()

-- Gets the next sibling element of <sub3>
print(sub3:next())
-- nil


-- Gets the parent element of <sub2>
print(sub2:parent():to_xml())
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3/>
-- </root>

local root = sub2:parent()

-- Gets the parent of <root>: xmlua.Document
print(root:parent():to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3/>
-- </root>

local document = root:parent()

-- Gets the parent of document
print(document:parent())
-- nil
