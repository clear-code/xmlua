local HTML = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Document = require("xmlua.document")

local function convert_xml_error(xml_error)
  local err = {
    domain = xml_error.domain,
    code = xml_error.code,
    message = ffi.string(xml_error.message),
    level  = tonumber(xml_error.level),
  }
  if xml_error.file == ffi.NULL then
    err.file = nil
  else
    err.file = ffi.string(xml_error.file)
  end
  err.line = xml_error.line
  return err
end

function HTML.parse(html, options)
  local context = libxml2.htmlNewParserCtxt()
  if not context then
    error("failed to create context to parse HTML")
  end

  local errors = {}
  local error_callback = function(user_data, xml_error)
    table.insert(errors, convert_xml_error(xml_error))
  end
  local c_error_callback = ffi.cast("xmlStructuredErrorFunc", error_callback)
  context.sax.initialized = libxml2.XML_SAX2_MAGIC
  context.sax.serror = c_error_callback
  local raw_document = libxml2.htmlCtxtReadMemory(context, html, options)
  c_error_callback:free()
  context.sax.serror = nil
  if raw_document == ffi.NULL then
    if context.lastError.message == ffi.NULL then
      error("Failed to parse HTML")
    else
      error("Failed to parse HTML: " .. ffi.string(context.lastError.message))
    end
  end
  local document = Document.new(raw_document, errors)

  local prefer_meta_charset = true
  if options then
    if options["encoding"] then
      prefer_meta_charset = false
    else
      prefer_meta_charset = options["prefer_meta_charset"]
      if prefer_meta_charset == nil then
        prefer_meta_charset = true
      end
    end
  end
  if prefer_meta_charset then
    -- TODO: Workaround for issue that
    -- libxml2 doesn't support <meta charset="XXX"> yet.
    -- We should feedback it to libxml2.
    local meta_charsets = document:search("//meta[@charset]")
    if #meta_charsets > 0 then
      local new_options = {encoding = meta_charsets[1].charset}
      if options then
        new_options.url = options.url
      end
      return HTML.parse(html, new_options)
    end
  end

  return document
end

return HTML
