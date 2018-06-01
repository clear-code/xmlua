local DocumentFragment = {}

local Node = require("xmlua.node")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function DocumentFragment.new(document, node)
  local document_fragment = {
    document = document,
    node = node,
  }
  setmetatable(document_fragment, metatable)
  return document_fragment
end

return DocumentFragment
