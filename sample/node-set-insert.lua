#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<xml>
  <header>
    <title>This is test</title>
  </header>
  <contents>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </contents>
</xml>
]])

local inserted_node_set = document:search("//title")
-- <title>This is test</title>
local insert_node = document:search("//xml/contents/sub1")[1]
-- <sub1>sub1</sub1>
inserted_node_set:insert(insert_node)

print(inserted_node_set:to_xml())
-- <title>This is test</title><sub1>sub1</sub1>
