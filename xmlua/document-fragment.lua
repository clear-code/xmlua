local DocumentFragment = {}

local Element = require("xmlua.element")

local methods = {}
local metatable = {}
local document_fragment

function metatable.__index(element, key)
  return methods[key] or
  document_fragment.parent[key]
end

function DocumentFragment.new(document, node)
  document_fragment = {
    document = document,
    node = node,
    parent = Element.new(document, node)
  }
  setmetatable(document_fragment, metatable)
  return document_fragment
end

return DocumentFragment
