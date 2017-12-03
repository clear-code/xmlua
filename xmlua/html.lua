local HTML = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Document = require("xmlua.document")

function HTML.parse(html, options)
  local context = libxml2.htmlNewParserCtxt()
  if not context then
    error("failed to create context to parse HTML")
  end
  local raw_document = libxml2.htmlCtxtReadMemory(context, html, options)
  if raw_document == ffi.NULL then
    error("failed to parse HTML: " .. ffi.string(context.lastError.message))
  end
  local document = Document.new(raw_document)
  if options and not options["encoding"] and options["prefer_charset"] then
    -- TODO: Workaround for issue that
    -- libxml2 doesn't support <meta charset="XXX"> yet.
    -- We should feedback it to libxml2.
    local meta_charsets = document:search("/html/head/meta[@charset]")
    if #meta_charsets > 0 then
      local new_options = {
        url = options.url,
        encoding = meta_charsets[1].charset,
      }
      return HTML.parse(html, new_options)
    end
  end
  return document
end

return HTML
