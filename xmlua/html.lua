local HTML = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Document = require("xmlua.document")

function HTML.parse(html, options)
  local context = libxml2.htmlNewParserCtxt()
  if not context then
    error("failed to create context to parse HTML")
  end
  local document = libxml2.htmlCtxtReadMemory(context, html, options)
  if document == ffi.NULL then
    error("failed to parse HTML: " .. ffi.string(context.lastError.message))
  end
  return Document.new(document)
end

return HTML
