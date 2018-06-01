local EntityReference = {}

local Node = require("xmlua.node")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function EntityReference.new(document, node)
  local entity_reference = {
    document = document,
    node = node,
  }
  setmetatable(entity_reference, metatable)
  return entity_reference
end

return EntityReference
