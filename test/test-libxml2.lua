local luaunit = require("luaunit")
local libxml2 = require("xmlua").libxml2
local ffi = require("ffi")

TestLibxml2HTML = {}
function TestLibxml2HTML:test_parse_valid()
  local html = "<html></html>"
  local context = libxml2.htmlCreateMemoryParserCtxt(html)
  luaunit.assertEquals(libxml2.htmlParseDocument(context),
                       true)
end

function TestLibxml2HTML:test_parse_invalid()
  local html = " "
  local context = libxml2.htmlCreateMemoryParserCtxt(html)
  luaunit.assertEquals(libxml2.htmlParseDocument(context),
                       false)
  luaunit.assertEquals(ffi.string(context.lastError.message),
                       "Document is empty\n")
end

-- TODO
TestLibxml2XMLBuffer = {}

-- TODO
TestLibxml2XMLSave = {}

TestLibxml2XPath = {}
function TestLibxml2XPath:test_create_doc()
  local xml = [[
 <!DOCTYPE doc [
 <!ELEMENT doc (src | dest)*>
 <!ELEMENT src EMPTY>
 <!ELEMENT dest EMPTY>
 <!ATTLIST src ref IDREF #IMPLIED>
 <!ATTLIST dest id ID #IMPLIED>
 ]>
 <doc>
   <src ref="foo"/>
   <dest id="foo"/>
   <src ref="foo"/>
 </doc>
]]
-- TODO
-- Add assertion
  libxml2.xmlParseMemory(xml)
end

function TestLibxml2XPath:test_xpath_new_context()
  local xml = [[
 <!DOCTYPE doc [
 <!ELEMENT doc (src | dest)*>
 <!ELEMENT src EMPTY>
 <!ELEMENT dest EMPTY>
 <!ATTLIST src ref IDREF #IMPLIED>
 <!ATTLIST dest id ID #IMPLIED>
 ]>
 <doc>
   <src ref="foo"/>
   <dest id="foo"/>
   <src ref="foo"/>
 </doc>
]]
  doc = libxml2.xmlParseMemory(xml)
  luaunit.assertNotNil(libxml2.xmlXPathNewContext(doc))
end
