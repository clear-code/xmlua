local converter = {}

local ffi = require("ffi")

function converter.to_string(c_string, length)
  if c_string == ffi.NULL then
    return nil
  else
    return ffi.string(c_string, length)
  end
end

function converter.convert_xml_error(xml_error)
  return {
    domain = xml_error.domain,
    code = xml_error.code,
    message = converter.to_string(xml_error.message),
    level  = tonumber(xml_error.level),
    file = converter.to_string(xml_error.file),
    line = xml_error.line,
  }
end

return converter
