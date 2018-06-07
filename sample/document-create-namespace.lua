#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local namespace =
  document:create_namespace("http://www.w3.org/1999/xhtml",
                            "xhtml")
local root = document:root()
root:set_namespace(namespace)
print(namespace:href(), namespace:prefix(), document:to_xml())
--"http://www.w3.org/1999/xhtml",
--"xhtml",
--<?xml version="1.0" encoding="UTF-8"?>
--<xhtml:root/>

