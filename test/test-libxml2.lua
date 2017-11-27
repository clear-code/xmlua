local luaunit = require("luaunit")
local libxml2 = require("xmlua").libxml2
local ffi = require("ffi")

TestLibxml2HTML = {}
function TestLibxml2HTML.test_parse_valid()
  local html = "<html></html>"
  local context = libxml2.htmlCreateMemoryParserCtxt(html)
  luaunit.assertEquals(libxml2.htmlParseDocument(context),
                       true)
end

function TestLibxml2HTML.test_parse_invalid()
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
function TestLibxml2XML.test_parse_valid()
  local xml = "<root/>"
  local context = libxml2.xmlCreateMemoryParserCtxt(xml)
  luaunit.assertEquals(libxml2.xmlParseDocument(context),
                       true)
end

function TestLibxml2XML.test_parse_invalid()
  local xml = "<root>"
  local context = libxml2.xmlCreateMemoryParserCtxt(xml)
  luaunit.assertEquals(libxml2.xmlParseDocument(context),
                       false)
  luaunit.assertEquals(ffi.string(context.lastError.message),
                       "Premature end of data in tag root line 1\n")
end

local function parse_xml(xml)
  local context = libxml2.xmlCreateMemoryParserCtxt(xml)
  if not libxml2.xmlParseDocument(context) then
    error({message = ffi.string(context.lastError.message)})
  end
  return context.myDoc
end

TestLibxml2XPathContext = {}
function TestLibxml2XPathContext.test_new()
  local xml = "<root/>"
  local document = parse_xml(xml)
  luaunit.assertEquals(ffi.typeof(libxml2.xmlXPathNewContext(document)),
                       ffi.typeof("xmlXPathContextPtr"))
end

function TestLibxml2XPathContext.test_set_context_node_valid()
  local xml = "<root/>"
  local document = parse_xml(xml)
  local root = libxml2.xmlDocGetRootElement(document)
  local context = libxml2.xmlXPathNewContext(document)
  luaunit.assertEquals(libxml2.xmlXPathSetContextNode(root, context),
                       true)
end

function TestLibxml2XPathContext.test_set_context_node_invalid()
  local xml = "<root/>"
  local document = parse_xml(xml)
  local context = libxml2.xmlXPathNewContext(document)
  luaunit.assertEquals(libxml2.xmlXPathSetContextNode(nil, context),
                       false)
end

TestLibxml2XPath = {}
function TestLibxml2XPath.test_eval_expression_valid()
  local xml = "<root><sub/></root>"
  local document = parse_xml(xml)
  local context = libxml2.xmlXPathNewContext(document)
  local object = libxml2.xmlXPathEvalExpression("/root/sub", context)
  luaunit.assertEquals(tonumber(object.type),
                       ffi.C.XPATH_NODESET)
end

function TestLibxml2XPath.test_eval_expression_invalid()
  local xml = "<root><sub/></root>"
  local document = parse_xml(xml)
  local context = libxml2.xmlXPathNewContext(document)
  luaunit.assertNil(libxml2.xmlXPathEvalExpression("", context))
  luaunit.assertEquals(context.lastError.code,
                       ffi.C.XML_XPATH_EXPRESSION_OK + ffi.C.XPATH_EXPR_ERROR)
end

local function find_element(document, xpath)
  local context = libxml2.xmlXPathNewContext(document)
  local object = libxml2.xmlXPathEvalExpression(xpath, context)
  return object.nodesetval.nodeTab[0]
end

TestLibxml2Node = {}
function TestLibxml2Node.test_search_namespace_found()
  local xml = "<root xmlns:example=\"http://example.com/\"/>"
  local document = parse_xml(xml)
  local root = find_element(document, "/root")
  local namespace = libxml2.xmlSearchNs(document, root, "example")
  luaunit.assertEquals(ffi.string(namespace.href),
                       "http://example.com/")
end

function TestLibxml2Node.test_search_namespace_not_found()
  local xml = "<root xmlns:example=\"http://example.com/\"/>"
  local document = parse_xml(xml)
  local root = find_element(document, "/root")
  luaunit.assertNil(libxml2.xmlSearchNs(document, root, "nonexistent"))
end
