local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestAttribute = {}

function TestAttribute.test_node_name()
  local document = xmlua.XML.build({"root", {["id"]="1"}})
  local attr = document:search("/root/@id")
  luaunit.assertEquals(attr[1]:node_name(),
                       "attribute")
end

function TestAttribute.test_path()
  local document =
    xmlua.XML.build({"root", {["id"]="1"}})
  local attr = document:search("/root/@id")
  luaunit.assertEquals(attr[1]:path(),
                       "/root/@id")
end

function TestAttribute.test_content()
  local document =
    xmlua.XML.build({"root", {["id"]="1"}})
  local attr = document:search("/root/@id")
  luaunit.assertEquals(attr[1]:content(),
                       "1")
end

function TestAttribute.test_set_content()
  local document =
    xmlua.XML.build({"root", {["id"]="1"}})
  local attr = document:search("/root/@id")
  attr[1]:set_content("345")
  luaunit.assertEquals(attr[1]:content(),
                       "345")
end

function TestAttribute.test_get_owner_element()
  local document =
    xmlua.XML.build({"root", {["id"]="1"}})
  local attr = document:search("/root/@id")
  local owner_element = attr[1]:get_owner_element()
  luaunit.assertEquals({
                         owner_element:name(),
                         owner_element:path()
                       },
                       {
                         "root",
                         "/root"
                       })
end

function TestAttribute.test_name()
  local document =
    xmlua.XML.build({"root", {["id"]="1"}})
  local attr = document:search("/root/@id")
  luaunit.assertEquals(attr[1]:name(),
                       "id")
end
