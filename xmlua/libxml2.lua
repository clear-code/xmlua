local libxml2 = {}

require("xmlua.libxml2.xmlstring")
require("xmlua.libxml2.xmlerror")
require("xmlua.libxml2.dict")
require("xmlua.libxml2.hash")
require("xmlua.libxml2.tree")
require("xmlua.libxml2.valid")
require("xmlua.libxml2.parser")
require("xmlua.libxml2.htmlparser")
require("xmlua.libxml2.xmlsave")

local ffi = require("ffi")
local xml2 = ffi.load("xml2")

function libxml2.htmlCreateMemoryParserCtxt(html)
  local context = xml2.htmlCreateMemoryParserCtxt(html, #html)
  if not context then
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

return libxml2
