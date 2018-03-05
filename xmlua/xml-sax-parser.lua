local XMLSAXParser = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local methods = {}

local metatable = {}
function metatable.__index(parser, key)
  return methods[key]
end

local function create_start_document_callback(user_callback)
  local callback = function(user_data)
    user_callback()
  end
  local c_callback = ffi.cast("startDocumentSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

function metatable.__newindex(parser, key, value)
  if key == "start_document" then
    value = create_start_document_callback(value)
    parser.context.sax.startDocument = value
  end
  rawset(parser, key, value)
end

function methods.parse(self, chunk)
  local parser_error = libxml2.xmlParseChunk(self.context, chunk, false)
  return parser_error == ffi.C.XML_ERR_OK
end

function methods.finish(self)
  local parser_error = libxml2.xmlParseChunk(self.context, nil, true)
  return parser_error == ffi.C.XML_ERR_OK
end

function XMLSAXParser.new()
  local parser = {}

  local filename = nil
  parser.context = libxml2.xmlCreatePushParserCtxt(filename)
  if not parser.context then
    error("Failed to create context to parse XML")
  end
  parser.context.sax.initialized = libxml2.XML_SAX2_MAGIC

  setmetatable(parser, metatable)

  return parser
end

return XMLSAXParser
