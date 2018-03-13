#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]])

-- All elements under <root> (<sub1>, <sub2> and <sub3>)
local node_set = document:search("/root/*")
-- Gets xpath of all elements under <root> (<sub1>, <sub2> and <sub3>)
for i=1, #node_set do
  print(node_set[i]:path())
  --/root/sub1
  --/root/sub2
  --/root/sub3
end

