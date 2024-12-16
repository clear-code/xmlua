local NotationDeclaration = {}

local Node = require("xmlua.node")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:node_name()
  return "notation-declaration"
end

function NotationDeclaration.new(document, node)
  local notation_declaration = {
    document = document,
    node = node,
  }
  setmetatable(notation_declaration, metatable)
  return notation_declaration
end

return NotationDeclaration
