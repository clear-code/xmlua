local DocumentFragment = {}

local Element = require("xmlua.element")

local methods = {}
local metatable = {}

function metatable.__index(document_fragment, key)
  return methods[key] or
    document_fragment.parent[key]
end

function methods:node_name()
  return "document-fragment"
end

function DocumentFragment.new(document, node)
  local document_fragment = {
    document = document,
    node = node,
    parent = Element.new(document, node)
  }
  setmetatable(document_fragment, metatable)
  return document_fragment
end

return DocumentFragment
