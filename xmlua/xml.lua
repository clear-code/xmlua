local XML = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Document = require("xmlua.document")
local Savable = require("xmlua.savable")
local Searchable = require("xmlua.searchable")

local metatable = {}
function metatable.__index(table, key)
  return Document[key] or
    Savable[key] or
    Searchable[key]
end

function XML.parse(xml)
  local context = libxml2.xmlCreateMemoryParserCtxt(xml)
  if not context then
    error({message = "failed to create context to parse XML"})
  end
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
