local Namespace = {}

local Node = require("xmlua.node")
local ffi = require("ffi")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:prefix()
  if self.node.prefix == ffi.NULL then
    return nil
  else
    return ffi.string(self.node.prefix)
  end
end

function methods:href()
  if self.node.href == ffi.NULL then
    return nil
  else
    return ffi.string(self.node.href)
  end
end

function Namespace.new(document, node)
  local namespace = {
    document = document,
    node = node,
  }
  setmetatable(namespace, metatable)
  return namespace
end

return Namespace
