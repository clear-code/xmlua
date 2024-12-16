local AttributeDeclaration = {}

local Node = require("xmlua.node")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:node_name()
  return "attribute-declaration"
end

function AttributeDeclaration.new(document, node)
  local attribute_declaration = {
    document = document,
    node = node,
  }
  setmetatable(attribute_declaration, metatable)
  return attribute_declaration
end

return AttributeDeclaration
