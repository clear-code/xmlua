#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local processing_instruction =
  document:create_processing_instruction("xml-stylesheet",
                                         "href=\"www.test.com/test-style.xsl\" type=\"text/xsl\"")
local root = document:root()
root:add_child(processing_instruction)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <?xml-stylesheet href="www.test.com/test-style.xsl" type="text/xsl"?>
--</root>

