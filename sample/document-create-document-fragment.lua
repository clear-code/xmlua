#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})

local document_fragment = document:create_document_fragment()
local comment_node = document:create_comment("This is comment")
document_fragment:add_child(comment_node)

root = document:root()
root:add_child(document_fragment)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <!--This is comment-->
--
--</root>

