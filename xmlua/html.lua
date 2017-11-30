local HTML = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Document = require("xmlua.document")

function HTML.parse(html)
  local context = libxml2.htmlCreateMemoryParserCtxt(html)
  if not context then
    error("failed to create context to parse HTML")
  end
  libxml2.htmlParseDocument(context)
  local document = context.myDoc
  if document == ffi.NULL then
    error("failed to parse HTML: " .. ffi.string(context.lastError.message))
  end
  return Document.new(document)
end

return HTML
