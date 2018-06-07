#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root id="1">
  <child1/>
</root>
]])
local attribute_node = document:search("/root/@id")

local root = document:root()
local child = root:children()[1]
--Add attribute node
child:add_child(attribute_node[1])
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <child1 id="1"/>
--</root>

local document_fragment = document:create_document_fragment()
local comment_node = document:create_comment("This is comment in document fragment")
document_fragment:add_child(comment_node)
root:add_child(document_fragment)
print(document:to_xml())

--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <child1 id="1"/>
--<!--This is comment in document fragment--></root>
