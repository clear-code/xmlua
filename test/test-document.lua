local luaunit = require("luaunit")
local xmlua = require("xmlua")
local ffi = require("ffi")

TestDocument = {}

function TestDocument.test_create_cdata_section()
  local document = xmlua.XML.build({})
  local cdata_section_node =
    document:create_cdata_section("This is <CDATA>")
  luaunit.assertEquals(cdata_section_node:content(),
                       "This is <CDATA>")
end

function TestDocument.test_create_comment()
  local document = xmlua.XML.build({})
  local comment_node = document:create_comment("This is comment")

  luaunit.assertEquals(comment_node:content(),
                       "This is comment")
end

function TestDocument.test_create_document_fragment()
  local document = xmlua.XML.build({})
  local document_fragment = document:create_document_fragment()
  luaunit.assertEquals(tonumber(document_fragment.node.type),
                       ffi.C.XML_DOCUMENT_FRAG_NODE)
end

function TestDocument.test_add_entity_reference()
  local document = xmlua.XML.build({})
  local entity_reference = document:add_entity_reference("test_entity")
  luaunit.assertEquals(entity_reference:name(),
                       "test_entity")
end

function TestDocument.test_create_namespace()
  local document = xmlua.XML.build({})
  local namespace =
    document:create_namespace("http://www.w3.org/1999/xhtml",
                              "xhtml")
  luaunit.assertEquals({
                         namespace:href(),
                         namespace:prefix()
                       },
                       {
                         "http://www.w3.org/1999/xhtml",
                         "xhtml"
                       })
end

function TestDocument.test_create_processing_instruction()
  local document = xmlua.XML.build({})
  local processing_instruction =
    document:create_processing_instruction("xml-stylesheet",
                                           "href=\"www.test.com/test-style.xsl\" type=\"text/xsl\"")

  luaunit.assertEquals({
                         processing_instruction:target(),
                         processing_instruction:content()
                       },
                       {
                         "xml-stylesheet",
                         "href=\"www.test.com/test-style.xsl\" type=\"text/xsl\"",
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

