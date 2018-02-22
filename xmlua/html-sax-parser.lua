local HTMLSAXParser = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")
local converter = require("xmlua.converter")
local to_string = converter.to_string

local Document = require("xmlua.document")

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

local function create_comment_callback(user_callback)
  local callback = function(user_data)
    user_callback()
  end
  local c_callback = ffi.cast("commentSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
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
      local base_index = (2 * (i - 1))
      local prefix = to_string(raw_namespaces[base_index + 0])
      local uri = to_string(raw_namespaces[base_index + 1])
      if prefix then
        namespaces[prefix] = uri
      else
        namespaces[""] = uri
      end
    end
    local attributes = {}
    for i = 1, n_attributes + n_defaulted do
      local base_index = (5 * (i - 1))
      local raw_attribute_local_name = raw_attributes[base_index + 0]
      local raw_attribute_prefix = raw_attributes[base_index + 1]
      local raw_attribute_uri = raw_attributes[base_index + 2]
      local raw_attribute_value = raw_attributes[base_index + 3]
      local raw_attribute_end = raw_attributes[base_index + 4]
      local attribute = {
        local_name = to_string(raw_attribute_local_name),
        prefix = to_string(raw_attribute_prefix),
        uri = to_string(raw_attribute_uri),
        value = to_string(raw_attribute_value,
                          raw_attribute_end - raw_attribute_value),
        is_default = i > n_attributes,
      }
      table.insert(attributes, attribute)
    end
    user_callback(to_string(raw_local_name),
                  to_string(raw_prefix),
                  to_string(raw_uri),
                  namespaces,
                  attributes)
  end
  local c_callback = ffi.cast("startElementNsSAX2Func", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_end_element_callback(user_callback)
  local callback = function(user_data,
                            raw_local_name,
                            raw_prefix,
                            raw_uri)
    user_callback(to_string(raw_local_name),
                  to_string(raw_prefix),
                  to_string(raw_uri))
  end
  local c_callback = ffi.cast("endElementNsSAX2Func", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_text_callback(user_callback)
  local callback = function(user_data, raw_text, raw_length)
    user_callback(to_string(raw_text, raw_length))
  end
  local c_callback = ffi.cast("charactersSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_end_document_callback(user_callback)
  local callback = function(user_data)
    user_callback()
  end
  local c_callback = ffi.cast("endDocumentSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_error_callback(user_callback)
  local callback = function(user_data, raw_error)
    local error = {
      domain = raw_error.domain,
      code = raw_error.code,
      message = to_string(raw_error.message),
      level  = tonumber(raw_error.level),
      file = to_string(raw_error.file),
      line = raw_error.line,
    }
    user_callback(error)
  end
  local c_callback = ffi.cast("xmlStructuredErrorFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

function metatable.__newindex(parser, key, value)
  if key == "start_document" then
    value = create_start_document_callback(value)
    parser.context.sax.startDocument = value
  elseif key == "comment" then
    value = create_comment_callback(value)
    parser.context.sax.comment = value
  elseif key == "start_element" then
    value = create_start_element_callback(value)
    parser.context.sax.startElementNs = value
  elseif key == "end_element" then
    value = create_end_element_callback(value)
    parser.context.sax.endElementNs = value
  elseif key == "text" then
    value = create_text_callback(value)
    parser.context.sax.characters = value
  elseif key == "end_document" then
    value = create_end_document_callback(value)
    parser.context.sax.endDocument = value
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
  -- TODO: Workaround for htmlCreatePushParserCtxt().
  -- It should allocate htmlParserCtxt::spaceTab.
  if parser.context.spaceTab == ffi.NULL then
    parser.context.spaceMax = 10
    parser.context.spaceTab =
      libxml2.xmlMalloc(parser.context.spaceMax * ffi.sizeof("int"));
  end

  parser.context.sax.initialized = libxml2.XML_SAX2_MAGIC

  setmetatable(parser, metatable)

  return parser
end

return HTMLSAXParser
