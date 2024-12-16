local EntityReference = {}

local Node = require("xmlua.node")
local ffi = require("ffi")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:node_name()
  return "entity-reference"
end

function methods:name()
  return ffi.string(self.node.name)
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
