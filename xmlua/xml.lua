local XML = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Document = require("xmlua.document")

function XML.parse(xml)
  local context = libxml2.xmlCreateMemoryParserCtxt(xml)
  if not context then
    error("failed to create context to parse XML")
  end
  local success = libxml2.xmlParseDocument(context)
  if not success then
    error("failed to parse XML: " .. ffi.string(context.lastError.message))
  end
  return Document.new(context.myDoc)
end

return XML
