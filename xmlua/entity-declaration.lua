local EntityDeclaration = {}

local Node = require("xmlua.node")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function EntityDeclaration.new(document, node)
  local entity_declaration = {
    document = document,
    node = node,
  }
  setmetatable(entity_declaration, metatable)
  return entity_declaration
end

return EntityDeclaration
