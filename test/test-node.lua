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

function TestNode.test_replace_node_receiver_nil()
  local document = xmlua.XML.build({"root", {}, "TextNode"})
  local text_nodes = document:search("/root/text()")
  local cdata_section_node =
    document:create_cdata_section("This is <CDATA>")
  text_nodes[1].node = nil

  local success, message =
    pcall(function() text_nodes[1]:replace(cdata_section_node) end)
  luaunit.assertEquals(success, false)
  luaunit.assertEquals(message:gsub("^.+:%d+: ", ""),
                       "Already freed receiver node")
  luaunit.assertEquals(document:to_xml(),
                       [=[
<?xml version="1.0" encoding="UTF-8"?>
<root>TextNode</root>
]=])
end

function TestNode.test_replace_node_replace_node_nil()
  local document = xmlua.XML.build({"root", {}, "TextNode"})
  local text_nodes = document:search("/root/text()")
  local cdata_section_node =
    document:create_cdata_section("This is <CDATA>")
  cdata_section_node.node = nil

  local success, message =
    pcall(function() text_nodes[1]:replace(cdata_section_node) end)
  luaunit.assertEquals(success, false)
  luaunit.assertEquals(message:gsub("^.+:%d+: ", ""),
                       "Already freed replace node")
  luaunit.assertEquals(document:to_xml(),
                       [=[
<?xml version="1.0" encoding="UTF-8"?>
<root>TextNode</root>
]=])
end

function TestNode.test_replace_node_both_nil()
  local document = xmlua.XML.build({"root", {}, "TextNode"})
  local text_nodes = document:search("/root/text()")
  local cdata_section_node =
    document:create_cdata_section("This is <CDATA>")
  cdata_section_node.node = nil
  text_nodes[1].node = nil

  local success, message =
    pcall(function() text_nodes[1]:replace(cdata_section_node) end)
  luaunit.assertEquals(success, false)
  luaunit.assertEquals(message:gsub("^.+:%d+: ", ""),
                       "Already freed receiver node and replace node")
  luaunit.assertEquals(document:to_xml(),
                       [=[
<?xml version="1.0" encoding="UTF-8"?>
<root>TextNode</root>
]=])
end

