#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local comment_node = document:create_comment("This is comment")
root = document:root()
root:add_child(comment_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <!--This is comment-->
--</root>
