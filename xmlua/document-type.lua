local DocumentType = {}

local Node = require("xmlua.node")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function DocumentType.new(document, node)
  local document_type = {
    document = document,
    node = node,
  }
  setmetatable(document_type, metatable)
  return document_type
end

return DocumentType
