local luaunit = require("luaunit")
local xmlua = require("xmlua")
local ffi = require("ffi")

TestDocument = {}

function TestDocument.test_node_name()
  local document = xmlua.XML.build({"root"})
  luaunit.assertEquals(document:node_name(),
                       "document")
end

function TestDocument.test_create_cdata_section()
  local document = xmlua.XML.build({"root"})
  local cdata_section_node =
    document:create_cdata_section("This is <CDATA>")
  root = document:root()
  root:add_child(cdata_section_node)
  luaunit.assertEquals(document:to_xml(),
                       [=[
<?xml version="1.0" encoding="UTF-8"?>
<root><![CDATA[This is <CDATA>]]></root>
]=]
                       )
end

function TestDocument.test_create_comment()
  local document = xmlua.XML.build({"root"})
  local comment_node = document:create_comment("This is comment")
  root = document:root()
  root:add_child(comment_node)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <!--This is comment-->
</root>
]])
end

function TestDocument.test_create_document_fragment()
  local document = xmlua.XML.build({"root"})

  local document_fragment = document:create_document_fragment()
  local comment_node = document:create_comment("This is comment")
  document_fragment:add_child(comment_node)

  root = document:root()
  root:add_child(document_fragment)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <!--This is comment-->

</root>
]])
end

function TestDocument.test_create_document_type_public_id()
  local document = xmlua.XML.build({})
  local document_type =
    document:create_document_type("TestDocumentDecl",
                                  "//test/uri")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE TestDocumentDecl PUBLIC "//test/uri" "">
]])
end

function TestDocument.test_create_document_type_system_id()
  local document = xmlua.XML.build({})
  local document_type =
    document:create_document_type("TestDocumentDecl",
                                  nil,
                                  "//system.dtd")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE TestDocumentDecl SYSTEM "//system.dtd">
]])
end

function TestDocument.test_add_entity_reference()
  local document = xmlua.XML.build({})
  local entity_reference = document:add_entity_reference("test_entity")
  luaunit.assertEquals(entity_reference:name(),
                       "test_entity")
end

function TestDocument.test_create_namespace()
  local document = xmlua.XML.build({"root"})
  local namespace =
    document:create_namespace("http://www.w3.org/1999/xhtml",
                              "xhtml")
  local root = document:root()
  root:set_namespace(namespace)
  luaunit.assertEquals({
                         namespace:href(),
                         namespace:prefix(),
                         document:to_xml()
                       },
                       {
                         "http://www.w3.org/1999/xhtml",
                         "xhtml",
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:root/>
]]
                       })
end

function TestDocument.test_create_default_namespace()
  local document = xmlua.XML.build({"root"})
  local namespace =
    document:create_namespace("http://www.w3.org/1999/xhtml",
                              nil)
  local root = document:root()
  root:set_namespace(namespace)
  luaunit.assertEquals({
                         namespace:href(),
                         document:to_xml()
                       },
                       {
                         "http://www.w3.org/1999/xhtml",
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
]]
                       })
end

function TestDocument.test_create_processing_instruction()
  local document = xmlua.XML.build({"root"})
  local processing_instruction =
    document:create_processing_instruction("xml-stylesheet",
                                           "href=\"www.test.com/test-style.xsl\" type=\"text/xsl\"")
  local root = document:root()
  root:add_child(processing_instruction)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <?xml-stylesheet href="www.test.com/test-style.xsl" type="text/xsl"?>
</root>
]])
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

function TestDocument.test_get_dtd_internal_subset()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE root SYSTEM "./test/test.dtd">
<root/>
]]
  local document = xmlua.XML.parse(xml)
  local dtd = document:get_internal_subset()
  luaunit.assertEquals({
                         dtd:name(),
                         dtd:system_id()
                       },
                       {
                         "root",
                         "./test/test.dtd"
                       })
end
