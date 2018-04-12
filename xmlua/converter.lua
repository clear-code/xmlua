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

function converter.convert_xml_entity(raw_xml_entity)
  return {
    entity_type = tonumber(raw_xml_entity.type),
    name = converter.to_string(raw_xml_entity.name),
    orig = converter.to_string(raw_xml_entity.orig),
    content = converter.to_string(raw_xml_entity.content),
    entity_type = tonumber(raw_xml_entity.etype),
    external_id = converter.to_string(raw_xml_entity.ExternalID),
    system_id = converter.to_string(raw_xml_entity.SystemID),
    uri = converter.to_string(raw_xml_entity.URI),
    owner = tonumber(raw_xml_entity.owner),
    checked = tonumber(raw_xml_entity.checked),
  }
end

function converter.convert_element_content(raw_content)
  local content = {}
  content["content_type"] = tonumber(raw_content.type)
  content["content_ocur"] = tonumber(raw_content.ocur)
  content["name"] = converter.to_string(raw_content.name)
  content["prefix"] = converter.to_string(raw_content.prefix)
  if raw_content.c1 ~= ffi.NULL then
    content["first_child"] =
      converter.convert_element_content(raw_content.c1)
  end
  if raw_content.c2 ~= ffi.NULL then
    content["second_child"] =
      converter.convert_element_content(raw_content.c2)
  end
  return content
end

return converter
