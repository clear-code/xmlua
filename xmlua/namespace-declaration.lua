local NameSpaceDeclaration = {}

local Node = require("xmlua.node")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:node_name()
  return "namespace-declaration"
end

function NameSpaceDeclaration.new(document, node)
  local namespace_declaration = {
    document = document,
    node = node,
  }
  setmetatable(namespace_declaration, metatable)
  return namespace_declaration
end

return NameSpaceDeclaration
