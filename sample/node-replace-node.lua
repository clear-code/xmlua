#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local comment_node =
  document:create_comment("This is comment")

local replace_node =
  document:create_cdata_section("This is <CDATASetion>")

root = document:root()
root:add_child(comment_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <!--This is Comment-->
--</root>

comment_node:replace(replace_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root><!--[CDATA[This is <CDATA>]]></root>

