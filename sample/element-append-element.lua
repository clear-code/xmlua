#!/usr/bin/env luajit

local xmlua = require("xmlua")

local xml = [[
<root/>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()

-- Append a new <sub1> to <root>
root:append_element("sub1")
print(root:to_xml())
-- <root>
--   <sub1/>
-- </root>

-- Append a new <sub2> to <root>
root:append_element("sub2")
print(root:to_xml())
-- <root>
--   <sub1/>
--   <sub2/>
-- </root>

-- Append a new <sub3> with attributes to <root>
root:append_element("sub3", {attribute1 = "value1", attribute2 = "value2"})
print(root:to_xml())
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3 attribute2="value2" attribute1="value1"/>
-- </root>

-- Append a new <example:sub4> with namespace to <root>
root:append_element("example:sub4",
                    {
                      ["xmlns:example"] = "http://example.com/",
                      data = "without namespace",
                      ["example:data"] = "with namespace"})
print(root:to_xml())
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3 attribute2="value2" attribute1="value1"/>
--   <example:sub4
--     xmlns:example="http://example.com/"
--     example:data="with namespace"
--     data="without namespace"/>
-- </root>
