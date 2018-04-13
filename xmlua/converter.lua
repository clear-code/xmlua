local converter = {}

local ffi = require("ffi")

function converter.to_string(c_string, length)
  if c_string == ffi.NULL then
    return nil
  else
    return ffi.string(c_string, length)
  end
end

function converter.convert_xml_error(raw_xml_error)
  return {
    domain = raw_xml_error.domain,
    code = raw_xml_error.code,
    message = converter.to_string(raw_xml_error.message),
    level  = tonumber(raw_xml_error.level),
    file = converter.to_string(raw_xml_error.file),
    line = raw_xml_error.line,
  }
end

local entity_type_names = {
  INTERNAL_ENTITY            = ffi.C.XML_INTERNAL_GENERAL_ENTITY,
  EXTERNAL_PARSED_ENTITY     = ffi.C.XML_EXTERNAL_GENERAL_PARSED_ENTITY,
  EXTERNAL_UNPARSED_ENTITY   = ffi.C.XML_EXTERNAL_GENERAL_UNPARSED_ENTITY,
  INTERNAL_PARAMETER_ENTITY  = ffi.C.XML_INTERNAL_PARAMETER_ENTITY,
  EXTERNAL_PARAMETER_ENTITY  = ffi.C.XML_EXTERNAL_PARAMETER_ENTITY,
  INTERNAL_PREDEFINED_ENTITY = ffi.C.XML_INTERNAL_PREDEFINED_ENTITY,
}

local entity_type_numbers = {}
for name, number in pairs(entity_type_names) do
  entity_type_numbers[number] = name
end

function converter.convert_entity_type_name(name)
  return entity_type_names[name]
end

function converter.convert_xml_entity(raw_xml_entity)
  return {
    entity_type = tonumber(raw_xml_entity.type),
    name = converter.to_string(raw_xml_entity.name),
    orig = converter.to_string(raw_xml_entity.orig),
    content = converter.to_string(raw_xml_entity.content),
    entity_type = entity_type_numbers[tonumber(raw_xml_entity.etype)],
    external_id = converter.to_string(raw_xml_entity.ExternalID),
    system_id = converter.to_string(raw_xml_entity.SystemID),
    uri = converter.to_string(raw_xml_entity.URI),
    owner = tonumber(raw_xml_entity.owner),
    checked = tonumber(raw_xml_entity.checked),
  }
end

local function convert_element_content_pcdata(raw_content)
  return {
    type = tonumber(raw_content.type),
  }
end

local function convert_element_content_element(raw_content)
  return {
    type = tonumber(raw_content.type),
    occur = tonumber(raw_content.ocur),
    name = converter.to_string(raw_content.name),
    prefix = converter.to_string(raw_content.prefix),
  }
end

local function convert_element_content_container(raw_content, raw_type)
  local children = {}
  table.insert(children, converter.convert_element_content(raw_content.c1))

  local raw_child = raw_content.c2
  while raw_child.type == raw_type and
        raw_child.ocur == ffi.C.XML_ELEMENT_CONTENT_ONCE do
    table.insert(children, converter.convert_element_content(raw_child.c1))
    raw_child = raw_child.c2
  end
  if raw_child ~= ffi.NULL then
    table.insert(children, converter.convert_element_content(raw_child))
  end
  return {
    type = tonumber(raw_content.type),
    occur = tonumber(raw_content.ocur),
    children = children,
  }
end

local function convert_element_content_seq(raw_content)
  return convert_element_content_container(raw_content,
                                           ffi.C.XML_ELEMENT_CONTENT_SEQ)
end

local function convert_element_content_or(raw_content)
  return convert_element_content_container(raw_content,
                                           ffi.C.XML_ELEMENT_CONTENT_OR)
end

function converter.convert_element_content(raw_content)
  if raw_content == ffi.NULL then
    return nil
  end

  if raw_content.type == ffi.C.XML_ELEMENT_CONTENT_PCDATA then
    return convert_element_content_pcdata(raw_content)
  elseif raw_content.type == ffi.C.XML_ELEMENT_CONTENT_ELEMENT then
    return convert_element_content_element(raw_content)
  elseif raw_content.type == ffi.C.XML_ELEMENT_CONTENT_SEQ then
    return convert_element_content_seq(raw_content)
  elseif raw_content.type == ffi.C.XML_ELEMENT_CONTENT_OR then
    return convert_element_content_or(raw_content)
  end
end

return converter
