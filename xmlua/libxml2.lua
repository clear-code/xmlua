local libxml2 = {}

require("xmlua.libxml2.memory")
require("xmlua.libxml2.global")
require("xmlua.libxml2.xmlstring")
require("xmlua.libxml2.xmlerror")
require("xmlua.libxml2.dict")
require("xmlua.libxml2.hash")
require("xmlua.libxml2.tree")
require("xmlua.libxml2.valid")
require("xmlua.libxml2.parser")
require("xmlua.libxml2.html-parser")
require("xmlua.libxml2.xmlsave")
require("xmlua.libxml2.xpath")

local ffi = require("ffi")
local loaded, xml2 = pcall(ffi.load, "xml2")
if not loaded then
  xml2 = ffi.load("libxml2.so.2")
end

libxml2.XML_SAX2_MAGIC = 0xDEEDBEAF

local function __xmlFreeIsAvailable()
  local success, err = pcall(function()
      local func = xml2.__xmlFree
  end)
  return success
end

local xmlFree
if __xmlFreeIsAvailable() then
  xmlFree = xml2.__xmlFree()
else
  xmlFree = xml2.xmlFree
end

libxml2.xmlInitParser = xml2.xmlInitParser
libxml2.xmlCleanupParser = xml2.xmlCleanupParser

function libxml2.htmlNewParserCtxt()
  local context = xml2.htmlNewParserCtxt()
  if context == ffi.NULL then
    return nil
  end
  return ffi.gc(context, xml2.htmlFreeParserCtxt)
end

function libxml2.htmlCtxtReadMemory(context, html, options)
  local url = nil
  local encoding = nil
  if options then
    url = options.url
    encoding = options.encoding
  end
  local parse_options = bit.bor(ffi.C.HTML_PARSE_RECOVER,
                                ffi.C.HTML_PARSE_NOERROR,
                                ffi.C.HTML_PARSE_NOWARNING,
                                ffi.C.HTML_PARSE_NONET)
  local document = xml2.htmlCtxtReadMemory(context,
                                           html,
                                           #html,
                                           url,
                                           encoding,
                                           parse_options)
  if document == ffi.NULL then
    return nil
  end
  return ffi.gc(document, libxml2.xmlFreeDoc)
end

function libxml2.xmlNewParserCtxt()
  local context = xml2.xmlNewParserCtxt()
  if context == ffi.NULL then
    return nil
  end
  return context
  -- return ffi.gc(context, xml2.xmlFreeParserCtxt)
end

function libxml2.xmlCtxtReadMemory(context, xml, options)
  local url = nil
  local encoding = nil
  if options then
    url = options.url
    encoding = options.encoding
  end
  local parse_options = bit.bor(ffi.C.XML_PARSE_RECOVER,
                                ffi.C.XML_PARSE_NOERROR,
                                ffi.C.XML_PARSE_NOWARNING,
                                ffi.C.XML_PARSE_NONET)
  local document = xml2.xmlCtxtReadMemory(context,
                                          xml,
                                          #xml,
                                          url,
                                          encoding,
                                          parse_options)
  if document == ffi.NULL then
    return nil
  end
  return ffi.gc(document, libxml2.xmlFreeDoc)
end

function libxml2.xmlDocGetRootElement(document)
  local root = xml2.xmlDocGetRootElement(document)
  if root == ffi.NULL then
    return nil
  end
  return root
end


local function xmlPreviousElementSiblingIsBuggy()
  local xml = "<root><child1/>text<child2/></root>"
  local context = libxml2.xmlNewParserCtxt()
  local document = libxml2.xmlCtxtReadMemory(context, xml)
  local root = xml2.xmlDocGetRootElement(document)
  local child2 = xml2.xmlLastElementChild(root)
  return xml2.xmlPreviousElementSibling(child2) == child2
end

if xmlPreviousElementSiblingIsBuggy() then
  -- For libxml2 < 2.7.7. CentOS 6 ships libxml2 2.7.6.
  function libxml2.xmlPreviousElementSibling(node)
    local node = node.prev
    while node ~= ffi.NULL do
      if tonumber(node.type) == ffi.C.XML_ELEMENT_NODE then
        return node
      end
      node = node.prev
    end
    return nil
  end
else
  function libxml2.xmlPreviousElementSibling(node)
    local element = xml2.xmlPreviousElementSibling(node)
    if element == ffi.NULL then
      return nil
    end
    return element
  end
end

function libxml2.xmlNextElementSibling(node)
  local element = xml2.xmlNextElementSibling(node)
  if element == ffi.NULL then
    return nil
  end
  return element
end

function libxml2.xmlFirstElementChild(node)
  local element = xml2.xmlFirstElementChild(node)
  if element == ffi.NULL then
    return nil
  end
  return element
end

function libxml2.xmlSearchNs(document, node, namespace_prefix)
  local namespace = xml2.xmlSearchNs(document, node, namespace_prefix)
  if namespace == ffi.NULL then
    return nil
  end
  return namespace
end

function libxml2.xmlGetNoNsProp(node, name)
  local value = xml2.xmlGetNoNsProp(node, name)
  if value == ffi.NULL then
    return nil
  end
  local lua_string = ffi.string(value)
  xmlFree(value)
  return lua_string
end

function libxml2.xmlGetNsProp(node, name, namespace_uri)
  local value = xml2.xmlGetNsProp(node, name, namespace_uri)
  if value == ffi.NULL then
    return nil
  end
  local lua_string = ffi.string(value)
  xmlFree(value)
  return lua_string
end

function libxml2.xmlGetProp(node, name)
  local value = xml2.xmlGetProp(node, name)
  if value == ffi.NULL then
    return nil
  end
  local lua_string = ffi.string(value)
  xmlFree(value)
  return lua_string
end

function libxml2.xmlNodeGetContent(node)
  local content = xml2.xmlNodeGetContent(node)
  if content == ffi.NULL then
    return nil
  end
  local lua_string = ffi.string(content)
  xmlFree(content)
  return lua_string
end


function libxml2.xmlBufferCreate()
  return ffi.gc(xml2.xmlBufferCreate(), xml2.xmlBufferFree)
end

function libxml2.xmlBufferGetContent(buffer)
  return ffi.string(buffer.content, buffer.use)
end

libxml2.xmlSaveToBuffer = xml2.xmlSaveToBuffer
libxml2.xmlSaveClose = xml2.xmlSaveClose

function libxml2.xmlSaveDoc(context, document)
  local written = xml2.xmlSaveDoc(context, document)
  return written ~= -1
end

function libxml2.xmlSaveTree(context, node)
  local written = xml2.xmlSaveTree(context, node)
  return written ~= -1
end

local suppress_error = ffi.cast("xmlStructuredErrorFunc",
                                function(user_data, err) end)

function libxml2.xmlXPathNewContext(document)
  local context = xml2.xmlXPathNewContext(document)
  if context == ffi.NULL then
    return nil
  end
  context.error = suppress_error
  return ffi.gc(context, xml2.xmlXPathFreeContext)
end

local function xmlXPathSetContextNodeIsAvailable()
  local success, err = pcall(function()
      local func = xml2.xmlXPathSetContextNode
  end)
  return success
end

if xmlXPathSetContextNodeIsAvailable() then
  function libxml2.xmlXPathSetContextNode(node, context)
    local status = xml2.xmlXPathSetContextNode(node, context)
    return status == 0
  end
else
  function libxml2.xmlXPathSetContextNode(node, context)
    if not node then
      return false
    end
    context.node = node
    return true
  end
end

function libxml2.xmlXPathEvalExpression(expression, context)
  local object = xml2.xmlXPathEvalExpression(expression, context)
  if object == ffi.NULL then
    return nil
  end
  return ffi.gc(object, xml2.xmlXPathFreeObject)
end

return libxml2
