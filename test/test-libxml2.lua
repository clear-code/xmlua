local luaunit = require("luaunit")
local libxml2 = require("xmlua").libxml2
local ffi = require("ffi")

TestLibxml2HTML = {}
function TestLibxml2HTML.test_parse_valid()
  local html = "<html></html>"
  local context = libxml2.htmlNewParserCtxt(html)
  luaunit.assertEquals(ffi.typeof(libxml2.htmlCtxtReadMemory(context, html)),
                       ffi.typeof("xmlDocPtr"))
end

function TestLibxml2HTML.test_parse_invalid()
  local html = " "
  local context = libxml2.htmlNewParserCtxt()
  luaunit.assertEquals(ffi.typeof(libxml2.htmlCtxtReadMemory(context, html)),
                       ffi.typeof("xmlDocPtr"))
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
  local context = libxml2.xmlNewParserCtxt(xml)
  luaunit.assertEquals(ffi.typeof(libxml2.xmlCtxtReadMemory(context, xml)),
                       ffi.typeof("xmlDocPtr"))
end

function TestLibxml2XML.test_parse_invalid()
  local xml = "<root>"
  local context = libxml2.xmlNewParserCtxt()
  local document = libxml2.xmlCtxtReadMemory(context, xml)
  luaunit.assertEquals(ffi.typeof(document),
                       ffi.typeof("xmlDocPtr"))
  -- This condition may be loose
  if tonumber(libxml2.VERSION) >= 20913 then
    luaunit.assertEquals(ffi.string(context.lastError.message),
                         "Premature end of data in tag root line 1\n")
  elseif tonumber(libxml2.VERSION) >= 20910 then
    luaunit.assertEquals(ffi.string(context.lastError.message),
                         "EndTag: '</' not found\n")
  else
    luaunit.assertEquals(ffi.string(context.lastError.message),
                         "Premature end of data in tag root line 1\n")
  end
end

local function parse_xml(xml)
  local context = libxml2.xmlNewParserCtxt()
  local document = libxml2.xmlCtxtReadMemory(context, xml)
  if not document then
    error({message = ffi.string(context.lastError.message)})
  end
  return document
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
  if object.nodesetval.nodeNr == 0 then
    return nil
  end
  return object.nodesetval.nodeTab[0]
end

local function root_element(document)
  return libxml2.xmlDocGetRootElement(document)
end

TestLibxml2Node = {}
function TestLibxml2Node.test_previous_sibling_element()
  local xml = "<root>text1<child1/>text2<child2/>text3</root>"
  local document = parse_xml(xml)
  local child2 = find_element(document, "/root/child2")
  local child1 = libxml2.xmlPreviousElementSibling(child2)
  luaunit.assertEquals(ffi.string(child1.name), "child1")
end

function TestLibxml2Node.test_previous_sibling_element_first()
  local xml = "<root>text1<child1/>text2<child2/>text3</root>"
  local document = parse_xml(xml)
  local child1 = find_element(document, "/root/child1")
  luaunit.assertNil(libxml2.xmlPreviousElementSibling(child1))
end

function TestLibxml2Node.test_next_sibling_element()
  local xml = "<root>text1<child1/>text2<child2/>text3</root>"
  local document = parse_xml(xml)
  local child1 = find_element(document, "/root/child1")
  local child2 = libxml2.xmlNextElementSibling(child1)
  luaunit.assertEquals(ffi.string(child2.name), "child2")
end

function TestLibxml2Node.test_next_sibling_element_last()
  local xml = "<root>text1<child1/>text2<child2/>text3</root>"
  local document = parse_xml(xml)
  local child2 = find_element(document, "/root/child2")
  luaunit.assertNil(libxml2.xmlNextElementSibling(child2))
end

function TestLibxml2Node.test_first_element_child()
  local xml = "<root>text1<child1/>text2<child2/>text3</root>"
  local document = parse_xml(xml)
  local root = find_element(document, "/root")
  local child1 = libxml2.xmlFirstElementChild(root)
  luaunit.assertEquals(ffi.string(child1.name), "child1")
end

function TestLibxml2Node.test_first_element_child_none()
  local xml = "<root>text</root>"
  local document = parse_xml(xml)
  local root = find_element(document, "/root")
  luaunit.assertNil(libxml2.xmlFirstElementChild(root))
end

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

function TestLibxml2Node.test_get_no_ns_prop_found()
  local xml = [[
<root attribute="value"/>
]]
  local document = parse_xml(xml)
  local root = root_element(document)
  luaunit.assertEquals(libxml2.xmlGetNoNsProp(root, "attribute"),
                       "value")
end

function TestLibxml2Node.test_get_no_ns_prop_found_with_namespace()
  local xml = [[
<root xmlns:example="http://example.com/"
      example:attribute="value"/>
]]
  local document = parse_xml(xml)
  local root = root_element(document)
  luaunit.assertNil(libxml2.xmlGetNoNsProp(root, "attribute"))
end

function TestLibxml2Node.test_get_no_ns_prop_not_found()
  local xml = [[
<root attribute="value"/>
]]
  local document = parse_xml(xml)
  local root = root_element(document)
  luaunit.assertNil(libxml2.xmlGetNoNsProp(root, "nonexistent"))
end

function TestLibxml2Node.test_get_ns_prop_found()
  local xml = [[
<root xmlns:example="http://example.com/"
      example:attribute="value-ns"
      attribute="value-no-ns"/>
]]
  local document = parse_xml(xml)
  local root = root_element(document)
  luaunit.assertEquals(libxml2.xmlGetNsProp(root,
                                            "attribute",
                                            "http://example.com/"),
                       "value-ns")
end

function TestLibxml2Node.test_get_ns_prop_not_found()
  local xml = [[
<root xmlns:example="http://example.com/"
      example:attribute="value"/>
]]
  local document = parse_xml(xml)
  local root = root_element(document)
  luaunit.assertNil(libxml2.xmlGetNsProp(root,
                                         "nonexistent",
                                         "http://example.com/"))
end

function TestLibxml2Node.test_get_prop_found()
  local xml = [[
<root attribute="value"/>
]]
  local document = parse_xml(xml)
  local root = root_element(document)
  luaunit.assertEquals(libxml2.xmlGetProp(root, "attribute"),
                       "value")
end

function TestLibxml2Node.test_get_prop_found_with_namespace()
  local xml = [[
<root xmlns:example="http://example.com/"
      example:attribute="value"/>
]]
  local document = parse_xml(xml)
  local root = root_element(document)
  luaunit.assertEquals(libxml2.xmlGetProp(root, "attribute"),
                       "value")
end

function TestLibxml2Node.test_get_prop_not_found()
  local xml = [[
<root attribute="value"/>
]]
  local document = parse_xml(xml)
  local root = root_element(document)
  luaunit.assertNil(libxml2.xmlGetProp(root, "nonexistent"))
end

function TestLibxml2Node.test_get_content_exist()
  local xml = [[
<root>root1<child>child</child>root2</root>
]]
  local document = parse_xml(xml)
  local root = root_element(document)
  luaunit.assertEquals(libxml2.xmlNodeGetContent(root),
                       "root1childroot2")
end

function TestLibxml2Node.test_get_content_none()
  luaunit.assertNil(libxml2.xmlNodeGetContent(nil))
end

function TestLibxml2Node.test_get_xpath_exist()
  local xml = [[
<root></root>
]]
  local document = parse_xml(xml)
  local root = root_element(document)
  luaunit.assertEquals(libxml2.xmlGetNodePath(root),
                       "/root")
end

function TestLibxml2Node.test_get_xpath_none()
  luaunit.assertNil(libxml2.xmlGetNodePath(nil))
end
