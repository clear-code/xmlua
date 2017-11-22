local luaunit = require("luaunit")
local libxml2 = require("xmlua").libxml2
local ffi = require("ffi")

TestLibxml2HTML = {}
function TestLibxml2HTML:test_parse_valid()
  local html = "<html></html>"
  local context = libxml2.htmlCreateMemoryParserCtxt(html)
  luaunit.assertEquals(true,
                       libxml2.htmlParseDocument(context))
end

function TestLibxml2HTML:test_parse_invalid()
  local html = " "
  local context = libxml2.htmlCreateMemoryParserCtxt(html)
  luaunit.assertEquals(false,
                       libxml2.htmlParseDocument(context))
  luaunit.assertEquals("Document is empty\n",
                       ffi.string(context.lastError.message))
end
