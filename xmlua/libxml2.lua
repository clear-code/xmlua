local libxml2 = {}

require("xmlua.libxml2.memory")
require("xmlua.libxml2.global")
require("xmlua.libxml2.xmlstring")
require("xmlua.libxml2.xmlerror")
require("xmlua.libxml2.dict")
require("xmlua.libxml2.hash")
require("xmlua.libxml2.tree")
require("xmlua.libxml2.valid")
require("xmlua.libxml2.encoding")
require("xmlua.libxml2.parser")
require("xmlua.libxml2.html-parser")
require("xmlua.libxml2.html-tree")
require("xmlua.libxml2.xmlsave")
require("xmlua.libxml2.xpath")
require("xmlua.libxml2.entities")

local ffi = require("ffi")
local loaded, xml2 = pcall(ffi.load, "xml2")
if not loaded then
  xml2 = ffi.load("libxml2.so.2")
end

local function __xmlParserVersionIsAvailable()
  local success, err = pcall(function()
      local func = xml2.__xmlParserVersion
  end)
  return success
end

local xmlParserVersion
if __xmlParserVersionIsAvailable() then
  xmlParserVersion = xml2.__xmlParserVersion()[0]
else
  xmlParserVersion = xml2.xmlParserVersion
end

libxml2.VERSION = ffi.string(xmlParserVersion)
libxml2.XML_SAX2_MAGIC = 0xDEEDBEAF

local function __xmlMallocIsAvailable()
  local success, err = pcall(function()
      local func = xml2.__xmlMalloc
  end)
  return success
end

if __xmlMallocIsAvailable() then
  libxml2.xmlMalloc = xml2.__xmlMalloc()
else
  libxml2.xmlMalloc = xml2.xmlMalloc
end

local function __xmlFreeIsAvailable()
  local success, err = pcall(function()
      local func = xml2.__xmlFree
  end)
  return success
end

if __xmlFreeIsAvailable() then
  libxml2.xmlFree = xml2.__xmlFree()
else
  libxml2.xmlFree = xml2.xmlFree
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

function libxml2.htmlCreatePushParserCtxt(filename, encoding)
  local context = xml2.htmlCreatePushParserCtxt(nil, nil, nil, 0, filename, encoding)
  if context == ffi.NULL then
    return nil
  end
  return ffi.gc(context, xml2.htmlFreeParserCtxt)
end

function libxml2.htmlParseChunk(context, chunk, is_terminated)
  if chunk then
    return xml2.htmlParseChunk(context, chunk, #chunk, is_terminated)
  else
    return xml2.htmlParseChunk(context, nil, 0, is_terminated)
  end
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

function libxml2.htmlNewDoc(uri, externa_dtd)
  local document = xml2.htmlNewDoc(uri, externa_dtd)
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
  return ffi.gc(context, xml2.xmlFreeParserCtxt)
end

function libxml2.xmlCreatePushParserCtxt(filename)
  local context = xml2.xmlCreatePushParserCtxt(nil, nil, nil, 0, filename)
  if context == ffi.NULL then
    return nil
  end
  return ffi.gc(context, xml2.xmlFreeParserCtxt)
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

function libxml2.xmlParseChunk(context, chunk, is_terminated)
  if chunk then
    return xml2.xmlParseChunk(context, chunk, #chunk, is_terminated)
  else
    return xml2.xmlParseChunk(context, nil, 0, is_terminated)
  end
end

libxml2.xmlFreeDoc = xml2.xmlFreeDoc

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

function libxml2.xmlNewNs(node, uri, prefix)
  local new_namespace = xml2.xmlNewNs(node, uri, prefix)
  return new_namespace
end

function libxml2.xmlFreeNs(namespace)
  xml2.xmlFreeNs(namespace)
end

function libxml2.xmlSetNs(node, namespace)
  xml2.xmlSetNs(node, namespace)
  return
end

function libxml2.xmlNewDoc(xml_version)
  local document = xml2.xmlNewDoc(xml_version)
  if document == ffi.NULL then
    return nil
  end
  return ffi.gc(document, libxml2.xmlFreeDoc)
end

function libxml2.xmlDocSetRootElement(document, root)
  return xml2.xmlDocSetRootElement(document, root)
end

function libxml2.xmlNewNode(namespace, name)
  local new_element = xml2.xmlNewNode(namespace, name)
  return new_element
end

function libxml2.xmlNewText(content)
  return xml2.xmlNewText(content)
end

function libxml2.xmlNewCDataBlock(document,
                                  content,
                                  content_length)
  return xml2.xmlNewCDataBlock(document,
                               content,
                               content_length)
end

function libxml2.xmlNewComment(content)
  return xml2.xmlNewComment(content)
end

function libxml2.xmlNewDocFragment(document)
  return xml2.xmlNewDocFragment(document)
end

function libxml2.xmlNewReference(document, name)
  return xml2.xmlNewReference(document, name)
end

function libxml2.xmlNewPI(name, content)
  return xml2.xmlNewPI(name, content)
end

function libxml2.xmlAddPrevSibling(sibling, new_sibling)
  local new_node = xml2.xmlAddPrevSibling(sibling, new_sibling)
  if new_node == ffi.NULL then
    new_node = nil
  end
  return new_node
end

function libxml2.xmlAddChild(parent, child)
  local child_node = xml2.xmlAddChild(parent, child)
  if child_node == ffi.NULL then
    child_node = nil
  end
  return child_node
end

function libxml2.xmlSearchNs(document, node, namespace_prefix)
  local namespace = xml2.xmlSearchNs(document, node, namespace_prefix)
  if namespace == ffi.NULL then
    return nil
  end
  return namespace
end

function libxml2.xmlSearchNsByHref(document, node, href)
  local namespace = xml2.xmlSearchNsByHref(document, node, href)
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
  libxml2.xmlFree(value)
  return lua_string
end

function libxml2.xmlGetNsProp(node, name, namespace_uri)
  local value = xml2.xmlGetNsProp(node, name, namespace_uri)
  if value == ffi.NULL then
    return nil
  end
  local lua_string = ffi.string(value)
  libxml2.xmlFree(value)
  return lua_string
end

function libxml2.xmlGetProp(node, name)
  local value = xml2.xmlGetProp(node, name)
  if value == ffi.NULL then
    return nil
  end
  local lua_string = ffi.string(value)
  libxml2.xmlFree(value)
  return lua_string
end

function libxml2.xmlNewNsProp(node, namespace, name, value)
  xml2.xmlNewNsProp(node, namespace, name, value)
end

function libxml2.xmlNewProp(node, name, value)
  return xml2.xmlNewProp(node, name, value)
end

function libxml2.xmlUnsetNsProp(node, namespace, name)
  xml2.xmlUnsetNsProp(node, namespace, name)
end

function libxml2.xmlUnsetProp(node, name)
  xml2.xmlUnsetProp(node, name)
end

function libxml2.xmlNodeSetContent(node, content)
  xml2.xmlNodeSetContent(node, content)
  return
end

function libxml2.xmlNodeGetContent(node)
  local content = xml2.xmlNodeGetContent(node)
  if content == ffi.NULL then
    return nil
  end
  local lua_string = ffi.string(content)
  libxml2.xmlFree(content)
  return lua_string
end

function libxml2.xmlGetNodePath(node)
  local path = xml2.xmlGetNodePath(node)
  if path == ffi.NULL then
    return nil
  end
  local lua_string = ffi.string(path)
  libxml2.xmlFree(path)
  return lua_string
end

function libxml2.xmlUnlinkNode(node)
  xml2.xmlUnlinkNode(node)
  return ffi.gc(node, xml2.xmlFreeNode)
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

local function error_ignore(user_data, err)
end
local c_error_ignore = ffi.cast("xmlStructuredErrorFunc", error_ignore)
ffi.gc(c_error_ignore, function(callback) callback:free() end)

function libxml2.xmlXPathNewContext(document)
  local context = xml2.xmlXPathNewContext(document)
  if context == ffi.NULL then
    return nil
  end
  context.error = c_error_ignore
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

function libxml2.xmlStrdup(string)
  return xml2.xmlStrdup(string)
end

function libxml2.xmlAddDocEntity(document,
                                 name,
                                 entity_type,
                                 external_id,
                                 system_id,
                                 content)
  return xml2.xmlAddDocEntity(document,
                              name,
                              entity_type,
                              external_id,
                              system_id,
                              content)
end

function libxml2.xmlAddDtdEntity(document,
                                 name,
                                 entity_type,
                                 external_id,
                                 system_id,
                                 content)
  return xml2.xmlAddDtdEntity(document,
                              name,
                              entity_type,
                              external_id,
                              system_id,
                              content)
end

function libxml2.xmlGetDocEntity(document, name)
  return xml2.xmlGetDocEntity(document, name)
end

function libxml2.xmlGetDtdEntity(document, name)
 return xml2.xmlGetDtdEntity(document, name)
end

return libxml2
