local HTML = {}

local ffi = require("ffi")
local libxml2 = require("xmlua.libxml2")

local metatable = {}

function HTML.parse(html)
  local context = libxml2.htmlCreateMemoryParserCtxt(html)
  local success = libxml2.htmlParseDocument(context)
  if not success then
    error({message = ffi.string(context.lastError.message)})
  end
  local html_document = {
    document = context.myDoc,
  }
  setmetatable(html_document, {__index = metatable})
  return html_document
end

function metatable.to_html(self, options) -- TODO: Support encoding
  local buffer = libxml2.xmlBufferCreate();
  local context = libxml2.xmlSaveToBuffer(buffer,
                                          "UTF-8",
                                          bit.bor(libxml2.XML_SAVE_FORMAT,
                                                  libxml2.XML_SAVE_NO_DECL,
                                                  libxml2.XML_SAVE_NO_EMPTY,
                                                  libxml2.XML_SAVE_AS_HTML))
  local success = libxml2.xmlSaveDoc(context, self.document)
  libxml2.xmlSaveClose(context)
  if not success then
    error({message = "failed to generate HTML string"})
  end
  return libxml2.xmlBufferGetContent(buffer)
end

return HTML
