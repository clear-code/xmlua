local Attr = {}

local Node = require("xmlua.node")
local ffi = require("ffi")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods.name(self)
  return ffi.string(self.node.name)
end

function Attr.new(document, node)
  local attr = {
    document = document,
    node = node,
  }
  setmetatable(attr, metatable)
  return attr
end

return Attr
