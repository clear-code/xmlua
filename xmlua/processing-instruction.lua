local ProcessingInstruction = {}

local Node = require("xmlua.node")
local ffi = require("ffi")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:target()
  return ffi.string(self.node.name)
end

function ProcessingInstruction.new(document, node)
  local pi = {
    document = document,
    node = node,
  }
  setmetatable(pi, metatable)
  return pi
end

return ProcessingInstruction
