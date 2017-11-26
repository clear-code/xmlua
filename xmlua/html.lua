local HTML = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Savable = require("xmlua.savable")
local Searchable = require("xmlua.searchable")

local metatable = {}
function metatable.__index(table, key)
  return Savable[key] or Searchable[key]
end

function HTML.parse(html)
  local context = libxml2.htmlCreateMemoryParserCtxt(html)
  local success = libxml2.htmlParseDocument(context)
  if not success then
    error({message = ffi.string(context.lastError.message)})
  end
  local html_document = {
    document = context.myDoc,
  }
  setmetatable(html_document, metatable)
  return html_document
end

return HTML
