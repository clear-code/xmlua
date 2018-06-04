local luaunit = require("luaunit")
local xmlua = require("xmlua")
local ffi = require("ffi")

TestNode = {}

function TestNode.test_replace_node()
  local document = xmlua.XML.build({"root", {}, "TextNode"})
  local text_nodes = document:search("/root/text()")
  local cdata_section_node =
    document:create_cdata_section("This is <CDATA>")
  text_nodes[1]:replace(cdata_section_node)

  luaunit.assertEquals(document:to_xml(),
                       [=[
<?xml version="1.0" encoding="UTF-8"?>
<root><![CDATA[This is <CDATA>]]></root>
]=])
end

