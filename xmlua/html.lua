local HTML = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Document = require("xmlua.document")

function HTML.parse(html)
  local context = libxml2.htmlCreateMemoryParserCtxt(html)
  if not context then
    error({message = "failed to create context to parse HTML"})
  end
  local success = libxml2.htmlParseDocument(context)
  if not success then
    error({message = ffi.string(context.lastError.message)})
  end
  return Document.new(context.myDoc)
end

return HTML
