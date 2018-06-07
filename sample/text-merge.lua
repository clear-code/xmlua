#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  Text:
  <child>This is child</child>
</root>
]])
local text1 = document:search("/root/text()")
local text2 = document:search("/root/child/text()")

text1[1]:merge(text2[1])
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  Text:
--  This is child<child/>
--</root>
