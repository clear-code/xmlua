local Savable = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local function save(target, flags, failure_message, options)
  local buffer = libxml2.xmlBufferCreate()
  local encoding = "UTF-8"
  if options and options.encoding then
    encoding = options.encoding
  end
  local context = libxml2.xmlSaveToBuffer(buffer, encoding, flags)
  local success
  if target.document then
    success = libxml2.xmlSaveDoc(context, target.document)
  else
    success = libxml2.xmlSaveTree(context, target.node)
  end
  libxml2.xmlSaveClose(context)
  if not success then
    error({message = failure_message})
  end
  return libxml2.xmlBufferGetContent(buffer)
end

function Savable.to_html(self, options)
  return save(self,
              bit.bor(ffi.C.XML_SAVE_FORMAT,
                      ffi.C.XML_SAVE_NO_DECL,
                      ffi.C.XML_SAVE_NO_EMPTY,
                      ffi.C.XML_SAVE_AS_HTML),
              "failed to generate HTML string",
              options)
end

function Savable.to_xml(self, options)
  return save(self,
              bit.bor(ffi.C.XML_SAVE_FORMAT,
                      ffi.C.XML_SAVE_AS_XML),
              "failed to generate XML string",
              options)
end

return Savable
