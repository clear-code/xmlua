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

-- Insert a node

local node_set = document:search("//title")
-- <title>This is test</title>

local sub1 = document:search("//xml/contents/sub1")[1]
-- <sub1>sub1</sub1>

node_set:insert(sub1)

print(node_set:to_xml())
-- <title>This is test</title><sub1>sub1</sub1>

-- Insert a node with position

local node_set = document:search("//xml/contents/*")
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>

local title = document:search("//title")[1]
-- <title>This is test</title>
node_set:insert(1, title)

print(node_set:to_xml())
-- <title>This is test</title>
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>
