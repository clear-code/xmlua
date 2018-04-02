#!/usr/bin/env luajit

local xmlua = require("xmlua")

local xml = [[
<root/>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()

-- Insert a new <sub1> to <root> as the first element
root:insert_element(1, "sub1")
print(root:to_xml())
-- <root>
--   <sub1/>
-- </root>

-- Insert a new <sub2> to <root> as the first element
root:insert_element(1, "sub2")
print(root:to_xml())
-- <root>
--   <sub2/>
--   <sub1/>
-- </root>

-- Insert a new <sub3> with attributes to <root> as the first element
root:insert_element(1, "sub3", {attribute1 = "value1", attribute2 = "value2"})
print(root:to_xml())
-- <root>
--   <sub3 attribute2="value2" attribute1="value1"/>
--   <sub2/>
--   <sub1/>
-- </root>

-- Insert a new <example:sub4> with namespace to <root> as the first element
root:insert_element(1,
                    "example:sub4",
                    {
                      ["xmlns:example"] = "http://example.com/",
                      data = "without namespace",
                      ["example:data"] = "with namespace"})
print(root:to_xml())
-- <root>
--   <example:sub4
--     xmlns:example="http://example.com/"
--     example:data="with namespace"
--     data="without namespace"/>
--   <sub3 attribute2="value2" attribute1="value1"/>
--   <sub2/>
--   <sub1/>
-- </root>
