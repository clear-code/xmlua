#!/usr/bin/env luajit

local xmlua = require("xmlua")

local xml = [[
<root>
  <child1/>
  <child2/>
  <child3/>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Find the <child2>
local child2s = document:css_select("child2")
local child2 = child2s[1]

-- Unlink <child2> from the document
child2:unlink()
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <child1/>
--   
--   <child3/>
-- </root>
