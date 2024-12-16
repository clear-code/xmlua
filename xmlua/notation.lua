local Notation = {}

local Node = require("xmlua.node")
local ffi = require("ffi")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:node_name()
  return "notation"
end

function methods:name()
  return ffi.string(self.node.name)
end

function methods:public_id()
  return ffi.string(self.node.PublicID)
end

function methods:system_id()
  return ffi.string(self.node.SystemID)
end

function Notation.new(document, node)
  local notation = {
    document = document,
    node = node,
  }
  setmetatable(notation, metatable)
  return notation
end

return Notation
