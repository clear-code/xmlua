#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  <sub1>sub1-1</sub1>
  <sub2>sub2-1</sub2>
  <sub1>sub1-2</sub1>
  <sub2>sub2-2</sub2>
  <sub3>sub3</sub3>
</root>
]])

local sub1s = document:search("/root/sub1")
-- <sub1>sub1-1</sub1>
-- <sub1>sub1-2</sub1>

local sub2s = document:search("/root/sub2")
-- <sub2>sub2-1</sub2>
-- <sub2>sub2-2</sub2>

-- Merge two node sets
local sub1_and_sub2s = sub1s:merge(sub2s)
print(sub1_and_sub2s:to_xml())
-- <sub1>sub1-1</sub1>
-- <sub1>sub1-2</sub1>
-- <sub2>sub2-1</sub2>
-- <sub2>sub2-2</sub2>

-- + is a shortcut for :merge()
local sub1_and_sub2s = sub1s + sub2s
print(sub1_and_sub2s:to_xml())
-- <sub1>sub1-1</sub1>
-- <sub1>sub1-2</sub1>
-- <sub2>sub2-1</sub2>
-- <sub2>sub2-2</sub2>

local sub2_and_sub3s = document:css_select("sub2, sub3")
-- <sub2>sub2-1</sub2>
-- <sub2>sub2-2</sub2>
-- <sub3>sub3</sub3>

-- Duplicated nodes (sub2s) are unified
local all_subs = sub1_and_sub2s + sub2_and_sub3s
print(all_subs:to_xml())
-- <sub1>sub1-1</sub1>
-- <sub1>sub1-2</sub1>
-- <sub2>sub2-1</sub2>
-- <sub2>sub2-2</sub2>
-- <sub3>sub3</sub3>
