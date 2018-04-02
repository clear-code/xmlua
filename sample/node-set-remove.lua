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

-- Remove a node

local subs = document:search("//xml/contents/*")
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>

local sub1 = subs:remove(subs[1])
-- "<sub1>sub1</sub1>" is removed

print(sub1:to_xml())
-- <sub1>sub1</sub1>

print(subs:to_xml())
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>

-- Remove a node with position

local subs = document:search("//xml/contents/*")
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>

local sub2 = subs:remove(2)
-- "<sub2>sub2</sub2>" is removed

print(sub2:to_xml())
-- <sub2>sub2</sub2>

print(subs:to_xml())
-- <sub1>sub1</sub1>
-- <sub3>sub3</sub3>
