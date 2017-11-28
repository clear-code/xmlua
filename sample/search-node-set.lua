#!/usr/bin/env luajit

local xmlua = require("xmlua")

local xml = [[
<root>
  <sub class="A"><subsub1/></sub>
  <sub class="B"><subsub2/></sub>
  <sub class="A"><subsub3/></sub>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Searches all <sub class="A"> elements
local class_a_subs = document:search("//sub[@class='A']")

-- Searches all elements under <sub class="A"> elements
local subsubs_in_class_a = class_a_subs:search("*")

print(#subsubs_in_class_a) -- -> 2

-- It's /root/sub[@class="A"]/subsub1
print(subsubs_in_class_a[1]:to_xml())
-- <subsub1/>

-- It's /root/sub[@class="A"]/subsub3
print(subsubs_in_class_a[2]:to_xml())
-- <subsub3/>
