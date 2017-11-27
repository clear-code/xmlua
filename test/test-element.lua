local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestElement = {}

function TestElement.test_to_html()
  local document = xmlua.XML.parse([[
<html>
  <head>
    <title>Title</title>
  </head>
</html>
]])
  local node_set = document:search("//title")
  luaunit.assertEquals(node_set[1]:to_html(),
                       "<title>Title</title>")
end

function TestElement.test_to_xml()
  local document = xmlua.XML.parse([[<root/>]])
  local node_set = document:search("/root")
  luaunit.assertEquals(node_set[1]:to_xml(),
                       "<root/>")
end

function TestElement.test_get_attribute_raw()
  local document = xmlua.XML.parse([[<root class="A"/>]])
  local node_set = document:search("/root")
  luaunit.assertEquals(node_set[1]:get_attribute("class"),
                       "A")
end

function TestElement.test_get_attribute_property()
  local document = xmlua.XML.parse([[<root class="A"/>]])
  local node_set = document:search("/root")
  luaunit.assertEquals(node_set[1].class,
                       "A")
end

function TestElement.test_get_attribute_array_referece()
  local document = xmlua.XML.parse([[<root class="A"/>]])
  local node_set = document:search("/root")
  luaunit.assertEquals(node_set[1]["class"],
                       "A")
end
