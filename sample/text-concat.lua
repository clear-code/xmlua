#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document =
  xmlua.XML.build({"root", {}, "Text1"})
local text_nodes = document:search("/root/text()")
text_nodes[1]:concat("Text2")
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>Text1Text2</root>
