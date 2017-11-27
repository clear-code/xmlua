local libxml2 = {}

require("xmlua.libxml2.xmlstring")
require("xmlua.libxml2.xmlerror")
require("xmlua.libxml2.dict")
require("xmlua.libxml2.hash")
require("xmlua.libxml2.tree")
require("xmlua.libxml2.valid")
require("xmlua.libxml2.parser")
require("xmlua.libxml2.parser-internals")
require("xmlua.libxml2.htmlparser")
require("xmlua.libxml2.xmlsave")
require("xmlua.libxml2.xpath")

local ffi = require("ffi")
local loaded, xml2 = pcall(ffi.load, "xml2")
if not loaded then
  xml2 = ffi.load("libxml2.so.2")
end

function libxml2.htmlCreateMemoryParserCtxt(html)
  local context = xml2.htmlCreateMemoryParserCtxt(html, #html)
  if context == ffi.NULL then
    return nil
  end
  xml2.htmlCtxtUseOptions(context,
                          bit.bor(ffi.C.HTML_PARSE_NOERROR,
                                  ffi.C.HTML_PARSE_NOWARNING))
  return ffi.gc(context, xml2.htmlFreeParserCtxt)
end

function libxml2.htmlParseDocument(context)
  local status = xml2.htmlParseDocument(context)
  return status == 0
end

function libxml2.xmlCreateMemoryParserCtxt(xml)
  local context = xml2.xmlCreateMemoryParserCtxt(xml, #xml)
  if context == ffi.NULL then
    return nil
  end
  ffi.gc(context, xml2.xmlFreeParserCtxt)
  xml2.xmlCtxtUseOptions(context,
                         bit.bor(ffi.C.XML_PARSE_NOERROR,
                                 ffi.C.XML_PARSE_NOWARNING))
  return context
end

function libxml2.xmlParseDocument(context)
  local status = xml2.xmlParseDocument(context)
  return status == 0
end

function libxml2.xmlDocGetRootElement(document)
  local root = xml2.xmlDocGetRootElement(document)
  if root == ffi.NULL then
    return nil
  else
    return root
  end
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
