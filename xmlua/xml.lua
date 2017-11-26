local XML = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Savable = require("xmlua.savable")
local Searchable = require("xmlua.searchable")

local metatable = {}
function metatable.__index(table, key)
  return Savable[key] or Searchable[key]
end

function XML.parse(xml)
  local context = libxml2.xmlCreateMemoryParserCtxt(xml)
  local success = libxml2.xmlParseDocument(context)
  if not success then
    error({message = ffi.string(context.lastError.message)})
  end
  local xml_document = {
    document = context.myDoc,
  }
  setmetatable(xml_document, metatable)
  return xml_document
end

return XML
