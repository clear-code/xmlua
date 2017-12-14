local HTMLSAXParser = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Document = require("xmlua.document")

local methods = {}

local metatable = {}
function metatable.__index(parser, key)
  return methods[key]
end

local function create_start_element_callback(user_callback)
  local callback = function(user_data,
                            raw_local_name,
                            raw_prefix,
                            raw_uri,
                            n_namespaces,
                            raw_namespaces,
                            n_attributes,
                            n_defaulted,
                            raw_attributes)
    local namespaces = {}
    for i = 1, n_namespaces do
      table.insert(namespaces, ffi.string(raw_namespaces[i]))
    end
    local attributes = {}
    for i = 1, n_attributes + n_defaulted do
      local base_index = (5 * (i - 1))
      local raw_attribute_local_name = raw_attributes[base_index + 0]
      local raw_attribute_prefix = raw_attributes[base_index + 1]
      local raw_attribute_uri = raw_attributes[base_index + 2]
      local raw_attribute_value = raw_attributes[base_index + 3]
      local raw_attribute_end = raw_attributes[base_index + 4]
      local attribute_local_name = ffi.string(raw_attribute_local_name)
      local attribute_prefix = nil
      local attribute_uri = nil
      local attribute_value = nil
      if raw_attribute_prefix ~= ffi.NULL then
        attribute_prefix = ffi.string(raw_attribute_prefix)
      end
      if raw_attribute_uri ~= ffi.NULL then
        attribute_uri = ffi.string(raw_attribute_uri)
      end
      attribute_value = ffi.string(raw_attribute_value,
                                   raw_attribute_end - raw_attribute_value)
      local attribute = {
        local_name = attribute_local_name,
        prefix = attribute_prefix,
        uri = attribute_uri,
        value = attribute_value,
        is_default = i > n_attributes,
      }
      table.insert(attributes, attribute)
    end
    local local_name = ffi.string(raw_local_name)
    local prefix = nil
    if raw_prefix ~= ffi.NULL then
      prefix = ffi.string(raw_prefix)
    end
    local uri = nil
    if raw_uri ~= ffi.NULL then
      uri = ffi.string(raw_uri)
    end
    user_callback(local_name, prefix, uri, attributes)
  end
  c_callback = ffi.cast("startElementNsSAX2Func", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_error_callback(user_callback)
  local callback = function(user_data, raw_error)
    local error = {
      domain = raw_error.domain,
      code = raw_error.code,
      message = ffi.string(raw_error.message),
      level  = tonumber(raw_error.level),
    }
    if raw_error.file == ffi.NULL then
      error.file = nil
    else
      error.file = ffi.string(raw_error.file)
    end
    error.line = raw_error.line
    user_callback(error)
  end
  c_callback = ffi.cast("xmlStructuredErrorFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

function metatable.__newindex(parser, key, value)
  if key == "start_element" then
    value = create_start_element_callback(value)
    parser.context.sax.startElementNs = value
  elseif key == "error" then
    value = create_error_callback(value)
    parser.context.sax.serror = value
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

function HTMLSAXParser.new()
  local parser = {}

  local filename = nil
  local encoding = ffi.C.XML_CHAR_ENCODING_NONE
  parser.context = libxml2.htmlCreatePushParserCtxt(filename, encoding)
  if not parser.context then
    error("Failed to create context to parse HTML")
  end
  -- TODO: Workaround for htmlCreatePushParserCtxt().
  -- It should allocate htmlParserCtxt::pushTab.
  if parser.context.pushTab == ffi.NULL then
    parser.context.pushTab =
      libxml2.xmlMalloc(parser.context.nameMax * 3 * ffi.sizeof("xmlChar *"));
  end

  parser.context.sax.initialized = libxml2.XML_SAX2_MAGIC

  setmetatable(parser, metatable)

  return parser
end

return HTMLSAXParser
