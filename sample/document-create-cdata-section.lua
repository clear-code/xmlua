#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local cdata_section_node =
  document:create_cdata_section("This is <CDATA>")
root = document:root()
root:add_child(cdata_section_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root><![CDATA[This is <CDATA>]]></root>
