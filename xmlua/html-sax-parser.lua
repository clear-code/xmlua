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

local function create_processing_instruction_callback(user_callback)
  local callback = function(user_data, raw_target, raw_data)
    local target = to_string(raw_target)
    local data = to_string(raw_data)
    user_callback(target, data)
  end
  local c_callback = ffi.cast("processingInstructionSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_cdata_block_callback(user_callback)
  local callback = function(user_data, raw_cdata_block, raw_length)
    local cdata_block = to_string(raw_cdata_block, raw_length)
    user_callback(cdata_block)
  end
  local c_callback = ffi.cast("cdataBlockSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_ignorable_whitespace_callback(user_callback)
  local callback = function(user_data, raw_ignorable_whitespaces, raw_length)
    local ignorable_whitespaces = to_string(raw_ignorable_whitespaces, raw_length)
    user_callback(ignorable_whitespaces)
  end
  local c_callback = ffi.cast("ignorableWhitespaceSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_comment_callback(user_callback)
  local callback = function(user_data, raw_comment)
    user_callback(to_string(raw_comment))
  end
  local c_callback = ffi.cast("commentSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_start_element_callback(user_callback)
  local callback = function(user_data,
                            raw_name,
                            raw_attributes)
    local attributes = {}
    if raw_attributes ~= ffi.NULL then
      local i = 0;
      while true do
        local raw_attribute_name = raw_attributes[i];
        if raw_attribute_name == ffi.NULL then
          break
        end
        i = i + 1
        local raw_attribute_value = raw_attributes[i]
        i = i + 1
        local attribute = {
          name = to_string(raw_attribute_name),
          value = to_string(raw_attribute_value),
        }
        table.insert(attributes, attribute)
      end
    end
    user_callback(to_string(raw_name), attributes)
  end
  local c_callback = ffi.cast("startElementSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_end_element_callback(user_callback)
  local callback = function(user_data, raw_name)
    user_callback(to_string(raw_name))
  end
  local c_callback = ffi.cast("endElementSAXFunc", callback)
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
  local callback = function(user_data, raw_xml_error)
    user_callback(converter.convert_xml_error(raw_xml_error))
  end
  local c_callback = ffi.cast("xmlStructuredErrorFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

function metatable.__newindex(parser, key, value)
  if key == "start_document" then
    value = create_start_document_callback(value)
    parser.context.sax.startDocument = value
  elseif key == "processing_instruction" then
    value = create_processing_instruction_callback(value)
    parser.context.sax.processingInstruction = value
  elseif key == "cdata_block" then
    value = create_cdata_block_callback(value)
    parser.context.sax.cdataBlock = value
  elseif key == "ignorable_whitespace" then
    value = create_ignorable_whitespace_callback(value)
    parser.context.sax.ignorableWhitespace = value
  elseif key == "comment" then
    value = create_comment_callback(value)
    parser.context.sax.comment = value
  elseif key == "start_element" then
    value = create_start_element_callback(value)
    parser.context.sax.startElement = value
  elseif key == "end_element" then
    value = create_end_element_callback(value)
    parser.context.sax.endElement = value
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
  local parser_error = libxml2.htmlParseChunk(self.context, chunk, false)
  return parser_error == ffi.C.XML_ERR_OK
end

function methods.finish(self)
  local parser_error = libxml2.htmlParseChunk(self.context, nil, true)
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
