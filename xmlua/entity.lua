local Entity = {}

local Node = require("xmlua.node")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:node_name()
  return "entity"
end

function Entity.new(document, node)
  local entity = {
    document = document,
    node = node,
  }
  setmetatable(entity, metatable)
  return entity
end

return Entity
