local XMLSAXParser = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")
local converter = require("xmlua.converter")
local to_string = converter.to_string
local Document = require("xmlua.document")

local methods = {}

local metatable = {}

function metatable.__index(parser, key)
  if key == "is_pedantic" then
    return parser.context.pedantic == 1
  elseif key == "document" then
    return Document.new(parser.context.myDoc)
  else
    return methods[key]
  end
end

local function create_start_document_callback(user_callback)
  local callback = function(user_data)
    user_callback()
  end
  local c_callback = ffi.cast("startDocumentSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_attribute_declaration_callback(user_callback)
  local callback = function(user_data,
                            raw_element_name,
                            raw_attribute_name,
                            raw_attribute_type,
                            raw_default_value_type,
                            raw_default_value,
                            raw_enumrated_value)
    local enumrated_value = {}

    while raw_enumrated_value ~= ffi.NULL do
      table.insert(enumrated_value, to_string(raw_enumrated_value.name))
      if raw_enumrated_value.next then
        raw_enumrated_value = raw_enumrated_value.next
      end
    end

    user_callback(to_string(raw_element_name),
                  to_string(raw_attribute_name),
                  tonumber(raw_attribute_type),
                  tonumber(raw_default_value_type),
                  to_string(raw_default_value),
                  enumrated_value)
  end
  local c_callback = ffi.cast("attributeDeclSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_unparsed_entity_declaration_callback(user_callback)
  local callback = function(user_data,
                            raw_name,
                            raw_public_id,
                            raw_system_id,
                            raw_notation_name)
    user_callback(to_string(raw_name),
                  to_string(raw_public_id),
                  to_string(raw_system_id),
                  to_string(raw_notation_name))
  end
  local c_callback = ffi.cast("unparsedEntityDeclSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_notation_declaration_callback(user_callback)
  local callback = function(user_data,
                            raw_name,
                            raw_public_id,
                            raw_system_id)
    user_callback(to_string(raw_name),
                  to_string(raw_public_id),
                  to_string(raw_system_id))
  end
  local c_callback = ffi.cast("notationDeclSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_entity_declaration_callback(user_callback)
  local callback = function(user_data,
                            raw_name,
                            raw_type,
                            raw_public_id,
                            raw_system_id,
                            raw_content)
    user_callback(to_string(raw_name),
                  raw_type,
                  to_string(raw_public_id),
                  to_string(raw_system_id),
                  to_string(raw_content))
  end
  local c_callback = ffi.cast("entityDeclSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_internal_subset_callback(user_callback)
  local callback = function(user_data,
                            raw_name,
                            raw_external_id,
                            raw_system_id)
    local name = to_string(raw_name)
    local external_id = to_string(raw_external_id)
    local system_id = to_string(raw_system_id)
    user_callback(name, external_id, system_id)
  end
  local c_callback = ffi.cast("internalSubsetSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_external_subset_callback(user_callback)
  local callback = function(user_data,
                            raw_name,
                            raw_external_id,
                            raw_system_id)
    local name = to_string(raw_name)
    local external_id = to_string(raw_external_id)
    local system_id = to_string(raw_system_id)
    user_callback(name, external_id, system_id)
  end
  local c_callback = ffi.cast("externalSubsetSAXFunc", callback)
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

local function create_comment_callback(user_callback)
  local callback = function(user_data, raw_comment)
    user_callback(to_string(raw_comment))
  end
  local c_callback = ffi.cast("commentSAXFunc", callback)
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

local function create_ignorable_whitespace_callback(user_callback)
  local callback = function(user_data,
                            raw_ignorable_whitespaces,
                            raw_length)
    local ignorable_whitespaces = to_string(raw_ignorable_whitespaces,
                                            raw_length)
    user_callback(ignorable_whitespaces)
  end
  local c_callback = ffi.cast("ignorableWhitespaceSAXFunc", callback)
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

local function create_reference_callback(user_callback)
  local callback = function(user_data, raw_entity_name)
    user_callback(to_string(raw_entity_name))
  end
  local c_callback = ffi.cast("referenceSAXFunc", callback)
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

local function create_warning_callback(user_callback)
  local callback = function(user_data,
                            raw_warning_message,
                            raw_string_value)
    local warning_message = to_string(raw_warning_message)
    local message_value = to_string(raw_string_value)
    local xml_warning = string.format(warning_message, message_value)
    user_callback(xml_warning)
  end
  local c_callback = ffi.cast("warningSAXFunc", callback)
  ffi.gc(c_callback, function() c_callback:free() end)
  return c_callback
end

local function create_xml_structured_error_callback(user_callback)
  local callback = function(user_data, raw_xml_error)
    user_callback(converter.convert_xml_error(raw_xml_error))
  end
  local c_callback = ffi.cast("xmlStructuredErrorFunc", callback)
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

function metatable.__newindex(parser, key, value)
  if key == "start_document" then
    value = create_start_document_callback(value)
    parser.context.sax.startDocument = value
  elseif key == "attribute_declaration" then
    value = create_attribute_declaration_callback(value)
    parser.context.sax.attributeDecl = value
  elseif key == "unparsed_entity_declaration" then
    value = create_unparsed_entity_declaration_callback(value)
    parser.context.sax.unparsedEntityDecl = value
  elseif key == "notation_declaration" then
    value = create_notation_declaration_callback(value)
    parser.context.sax.notationDecl = value
  elseif key == "entity_declaration" then
    value = create_entity_declaration_callback(value)
    parser.context.sax.entityDecl = value
  elseif key == "internal_subset" then
    value = create_internal_subset_callback(value)
    parser.context.sax.internalSubset = value
  elseif key == "external_subset" then
    value = create_external_subset_callback(value)
    parser.context.sax.externalSubset = value
  elseif key == "cdata_block" then
    value = create_cdata_block_callback(value)
    parser.context.sax.cdataBlock = value
  elseif key == "comment" then
    value = create_comment_callback(value)
    parser.context.sax.comment = value
  elseif key == "processing_instruction" then
    value = create_processing_instruction_callback(value)
    parser.context.sax.processingInstruction = value
  elseif key == "ignorable_whitespace" then
    value = create_ignorable_whitespace_callback(value)
    parser.context.sax.ignorableWhitespace = value
  elseif key == "text" then
    value = create_text_callback(value)
    parser.context.sax.characters = value
  elseif key == "reference" then
    value = create_reference_callback(value)
    parser.context.sax.reference = value
  elseif key == "start_element" then
    value = create_start_element_callback(value)
    parser.context.sax.startElementNs = value
  elseif key == "end_element" then
    value = create_end_element_callback(value)
    parser.context.sax.endElementNs = value
  elseif key == "warning" then
    value = create_warning_callback(value)
    parser.context.sax.warning = value
  elseif key == "is_pedantic" then
    if value then
      parser.context.pedantic = 1
    else
      parser.context.pedantic = 0
    end
  elseif key == "error" then
    value = create_xml_structured_error_callback(value)
    parser.context.sax.serror = value
  elseif key == "end_document" then
    value = create_end_document_callback(value)
    parser.context.sax.endDocument = value
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

function XMLSAXParser.new(options)
  local parser = {}

  local filename = nil
  parser.context = libxml2.xmlCreatePushParserCtxt(filename)
  if not parser.context then
    error("Failed to create context to parse XML")
  end
  parser.context.sax.initialized = libxml2.XML_SAX2_MAGIC
  if options then
    if options["pedantic"] then
      parser.context.pedantic = 1
    elseif options["parser_dtd_load"] then
      parser.context.loadsubset = ffi.C.XML_DETECT_IDS
    end
  end
  setmetatable(parser, metatable)

  return parser
end

return XMLSAXParser
