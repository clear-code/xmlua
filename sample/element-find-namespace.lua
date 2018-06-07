#!/usr/bin/env luajit

local xmlua = require("xmlua")

local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<test xmlns='http://www.test.org/xhtml'
      xmlns:xhtml='http://www.w3.org/1999/xhtml'
      xmlns:sample='http://www.sample.org/sample'>
</test>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()
--Search by prefix
local namespace = root:find_namespace("xhtml")
print(namespace:prefix(), namespace:href())
--"xhtml" "http://www.w3.org/1999/xhtml"

--Search by href
local namespace = root:find_namespace(nil, "http://www.sample.org/sample")
print(namespace:prefix(), namespace:href())
--"sample" "http://www.sample.org/sample"

--Search default namespace
namespace = root:find_namespace()
print(namespace:href())
--"http://www.test.org/xhtml"
