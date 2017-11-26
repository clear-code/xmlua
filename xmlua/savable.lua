local Savable = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

function Savable.to_html(self, options) -- TODO: Support encoding
  local buffer = libxml2.xmlBufferCreate()
  local context = libxml2.xmlSaveToBuffer(buffer,
                                          "UTF-8",
                                          bit.bor(ffi.C.XML_SAVE_FORMAT,
                                                  ffi.C.XML_SAVE_NO_DECL,
                                                  ffi.C.XML_SAVE_NO_EMPTY,
                                                  ffi.C.XML_SAVE_AS_HTML))
  local success
  if self.document then
    success = libxml2.xmlSaveDoc(context, self.document)
  else
    success = libxml2.xmlSaveTree(context, self.node)
  end
  libxml2.xmlSaveClose(context)
  if not success then
    error({message = "failed to generate HTML string"})
  end
  return libxml2.xmlBufferGetContent(buffer)
end

return Savable
