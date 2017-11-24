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

local function to_xml(document)
  local buffer = libxml2.xmlBufferCreate()
  local context = libxml2.xmlSaveToBuffer(buffer,
                                          "UTF-8",
                                          bit.bor(ffi.C.XML_SAVE_FORMAT,
                                                  ffi.C.XML_SAVE_NO_DECL,
                                                  ffi.C.XML_SAVE_AS_XML))
  libxml2.xmlSaveDoc(context, document)
  libxml2.xmlSaveClose(context)
  return libxml2.xmlBufferGetContent(buffer)
end

TestLibxml2XML = {}
function TestLibxml2XML:test_parse_valid()
  local xml = "<root/>"
  local context = libxml2.xmlCreateMemoryParserCtxt(xml)
  luaunit.assertEquals(libxml2.xmlParseDocument(context),
                       true)
end

function TestLibxml2XML:test_parse_invalid()
  local xml = "<root>"
  local context = libxml2.xmlCreateMemoryParserCtxt(xml)
  luaunit.assertEquals(libxml2.xmlParseDocument(context),
                       false)
  luaunit.assertEquals(ffi.string(context.lastError.message),
                       "Premature end of data in tag root line 1\n")
end

TestLibxml2XPath = {}
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
  local context = libxml2.xmlCreateMemoryParserCtxt(xml)
  libxml2.xmlParseDocument(context)
  local document = context.myDoc
  luaunit.assertNotNil(libxml2.xmlXPathNewContext(document))
end
