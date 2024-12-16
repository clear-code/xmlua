local ElementDeclaration = {}

local Node = require("xmlua.node")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:node_name()
  return "element-declaration"
end

function ElementDeclaration.new(document, node)
  local element_declaration = {
    document = document,
    node = node,
  }
  setmetatable(element_declaration, metatable)
  return element_declaration
end

return ElementDeclaration
