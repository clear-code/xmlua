#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  <sub1>sub1-1</sub1>
  <sub2>sub2-1</sub2>
  <sub1>sub1-2</sub1>
  <sub2>sub2-2</sub2>
  <sub3>sub3</sub3>
</root>
]])

local sub1s = document:css_select("sub1")
-- <sub1>sub1-1</sub1>
-- <sub1>sub1-2</sub1>

-- Unlink all sub1 elemetns from document
sub1s:unlink()
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   
--   <sub2>sub2-1</sub2>
--   
--   <sub2>sub2-2</sub2>
--   <sub3>sub3</sub3>
-- </root>

