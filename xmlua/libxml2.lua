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

libxml2.XML_ERR_NONE    = 0
libxml2.XML_ERR_WARNING = 1
libxml2.XML_ERR_ERROR   = 2
libxml2.XML_ERR_FATAL   = 3

libxml2.XML_SAVE_FORMAT   = bit.bor(1, 0)
libxml2.XML_SAVE_NO_DECL  = bit.bor(1, 1)
libxml2.XML_SAVE_NO_EMPTY = bit.bor(1, 2)
libxml2.XML_SAVE_NO_XHTML = bit.bor(1, 3)
libxml2.XML_SAVE_XHTML    = bit.bor(1, 4)
libxml2.XML_SAVE_AS_XML   = bit.bor(1, 5)
libxml2.XML_SAVE_AS_HTML  = bit.bor(1, 6)
libxml2.XML_SAVE_WSNONSIG = bit.bor(1, 7)

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
