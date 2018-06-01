local luaunit = require("luaunit")
local xmlua = require("xmlua")
local ffi = require("ffi")

TestDocument = {}

function TestDocument.test_create_attribute()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
]]
  local parser = xmlua.XMLSAXParser.new()
  local succeeded = parser:parse(xml)
  local document = parser.document
  local attr_node = document:create_attribute("id", "1")

  luaunit.assertEquals({
                         attr_node:name(),
                         attr_node:value()
                       },
                       {
                         "id",
                         "1"
                       })
end

function TestDocument.test_add_entity()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE example [
]>
]]
  local parser = xmlua.XMLSAXParser.new()
  local succeeded = parser:parse(xml)
  local document = parser.document

  local entity_info = {
    name = "Sample",
    entity_type = "INTERNAL_ENTITY",
    external_id = "-//W3C//DTD XHTML 1.0 Transitional//EN",
    system_id = "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
    content = "This is test."
  }
  local added_entity = document:add_entity(entity_info)
  local entity = document:get_entity("Sample")
  luaunit.assertEquals({
                         {
                           entity["name"],
                           entity["entity_type"],
                           entity["external_id"],
                           entity["system_id"],
                           entity["content"],
                         },
                         {
                           added_entity["name"],
                           added_entity["entity_type"],
                           added_entity["external_id"],
                           added_entity["system_id"],
                           added_entity["content"],
                         }
                       },
                       {
                         {
                           "Sample",
                           "INTERNAL_ENTITY",
                           "-//W3C//DTD XHTML 1.0 Transitional//EN",
                           "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
                           "This is test."
                         },
                         {
                           "Sample",
                           "INTERNAL_ENTITY",
                           "-//W3C//DTD XHTML 1.0 Transitional//EN",
                           "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
                           "This is test."
                         }
                       })
end

function TestDocument.test_add_dtd_entity()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE root SYSTEM "./test/test.dtd">
<root>
<A></A>
</root>
]]
  local options = {load_dtd = true}
  local parser = xmlua.XMLSAXParser.new(options)
  local succeeded = parser:parse(xml)
  local document = parser.document

  local entity_info = {
    name = "Sample",
    entity_type = "INTERNAL_ENTITY",
    external_id = "-//W3C//DTD XHTML 1.0 Transitional//EN",
    system_id = "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
    content = "This is test."
  }
  local added_entity = document:add_entity(entity_info)
  local entity = document:get_entity("Sample")
  luaunit.assertEquals({
                         {
                           entity["name"],
                           entity["entity_type"],
                           entity["external_id"],
                           entity["system_id"],
                           entity["content"],
                         },
                         {
                           added_entity["name"],
                           added_entity["entity_type"],
                           added_entity["external_id"],
                           added_entity["system_id"],
                           added_entity["content"],
                         }
                       },
                       {
                         {
                           "Sample",
                           "INTERNAL_ENTITY",
                           "-//W3C//DTD XHTML 1.0 Transitional//EN",
                           "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
                           "This is test."
                         },
                         {
                           "Sample",
                           "INTERNAL_ENTITY",
                           "-//W3C//DTD XHTML 1.0 Transitional//EN",
                           "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
                           "This is test."
                         }
                       })
end

