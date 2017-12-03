local Document = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Serializable = require("xmlua.serializable")
local Searchable = require("xmlua.searchable")

local Element

function Document.lazy_load()
  Element = require("xmlua.element")
end

local methods = {}

local metatable = {}
function metatable.__index(document, key)
  return methods[key] or
    Serializable[key] or
    Searchable[key]
end

function methods.root(self)
  local root_element = libxml2.xmlDocGetRootElement(self.document)
  if not root_element then
    return nil
  end
  return Element.new(self.document, root_element)
end

function methods.parent(self)
  return nil
end

function methods.encoding(self)
  return ffi.string(self.document.encoding)
end

function Document.new(raw_document, errors)
  if not errors then
    errors = {}
  end
  local document = {
    document = raw_document,
    errors = errors,
  }
  setmetatable(document, metatable)
  return document
end

return Document
