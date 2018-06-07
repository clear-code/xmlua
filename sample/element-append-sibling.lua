#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child1/>
</root>
]])
local root = document:root()
local comment_node =
  document:create_comment("This is comment!")

local child = root:children()[1]
child:append_sibling(comment_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <child1/>
--<!--This is comment!--></root>

