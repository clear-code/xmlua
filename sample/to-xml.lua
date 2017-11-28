#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]])

-- Serializes as XML
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub1>text1</sub1>
--   <sub2>text2</sub2>
--   <sub3>text3</sub3>
-- </root>

-- Serializes as EUC-JP encoded XML
print(document:to_xml({encoding = "EUC-JP"}))
-- <?xml version="1.0" encoding="EUC-JP"?>
-- <root>
--   <sub1>text1</sub1>
--   <sub2>text2</sub2>
--   <sub3>text3</sub3>
-- </root>

-- Serializes <body> element as XML
print(document:search("/root/sub1")[1]:to_xml())
-- <sub1>text1</sub1>

-- Serializes elements under <root> (<sub1>, <sub2> and <sub3>) as XML
print(document:search("/root/*"):to_xml())
-- <sub1>text1</sub1><sub2>text2</sub2><sub3>text3</sub3>
