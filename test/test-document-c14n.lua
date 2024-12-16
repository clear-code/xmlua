local luaunit = require("luaunit")
local xmlua = require("xmlua")
local ffi = require("ffi")

TestDocumentC14N = {}

local input = [[
<?xml version="1.0"?>
<root xml:space="default" xmlns:ns1="http://example.com/ns1" xmlns:ns2="http://example.com/ns2">
  <ns1:child ns2:attribute="ns2-value">
    <!-- comment --><ns2:grand-child/>
  </ns1:child>
</root>
]]

function TestDocumentC14N.test_select_nil()
  local document = xmlua.XML.parse(input)
  luaunit.assertEquals(document:canonicalize(),
                       [[
<root xml:space="default">
  <ns1:child xmlns:ns1="http://example.com/ns1" xmlns:ns2="http://example.com/ns2" ns2:attribute="ns2-value">
    <ns2:grand-child></ns2:grand-child>
  </ns1:child>
</root>]])
end

function TestDocumentC14N.test_select_function()
  local document = xmlua.XML.parse(input)
  local function is_grand_child(node, parent)
    if not node then
      return false
    end
    if node:node_name() ~= "element" then
      return false
    end
    return node:name() == "grand-child"
  end
  luaunit.assertEquals(document:canonicalize(is_grand_child),
                       [[<ns2:grand-child></ns2:grand-child>]])
end

function TestDocumentC14N.test_select_function()
  local document = xmlua.XML.parse(input)
  local function is_grand_child(node, parent)
    if not node then
      return false
    end
    if node:node_name() ~= "element" then
      return false
    end
    return node:name() == "grand-child"
  end
  luaunit.assertEquals(document:canonicalize(is_grand_child),
                       [[<ns2:grand-child></ns2:grand-child>]])
end

function TestDocumentC14N.test_select_array()
  local document = xmlua.XML.parse(input)
  local child = document:search("/root/ns1:child")[1]
  local grand_child = document:search("/root/ns1:child/ns2:grand-child")[1]
  luaunit.assertEquals(document:canonicalize({child, grand_child}),
                       [[<ns1:child><ns2:grand-child></ns2:grand-child></ns1:child>]])
end

function TestDocumentC14N.test_mode()
  local document = xmlua.XML.parse(input)
  local options = {
    mode = "1_0",
  }
  luaunit.assertEquals(document:canonicalize(nil, options),
                       [[
<root xmlns:ns1="http://example.com/ns1" xmlns:ns2="http://example.com/ns2" xml:space="default">
  <ns1:child ns2:attribute="ns2-value">
    <ns2:grand-child></ns2:grand-child>
  </ns1:child>
</root>]])
end

function TestDocumentC14N.test_inclusive_ns_prefixes()
  local document = xmlua.XML.parse(input)
  local options = {
    inclusive_ns_prefixes = {"ns1"},
  }
  luaunit.assertEquals(document:canonicalize(nil, options),
                       [[
<root xmlns:ns1="http://example.com/ns1" xml:space="default">
  <ns1:child xmlns:ns2="http://example.com/ns2" ns2:attribute="ns2-value">
    <ns2:grand-child></ns2:grand-child>
  </ns1:child>
</root>]])
end

function TestDocumentC14N.test_with_comments()
  local document = xmlua.XML.parse(input)
  local options = {
    with_comments = true,
  }
  luaunit.assertEquals(document:canonicalize(nil, options),
                       [[
<root xml:space="default">
  <ns1:child xmlns:ns1="http://example.com/ns1" xmlns:ns2="http://example.com/ns2" ns2:attribute="ns2-value">
    <!-- comment --><ns2:grand-child></ns2:grand-child>
  </ns1:child>
</root>]])
end
