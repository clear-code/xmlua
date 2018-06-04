local NameSpace = {}

local Node = require("xmlua.node")
local ffi = require("ffi")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:get_prefix()
  return ffi.string(self.node.prefix)
end

function methods:get_href()
  return ffi.string(self.node.href)
end

function NameSpace.new(document, node)
  local namespace = {
    document = document,
    node = node,
  }
  setmetatable(namespace, metatable)
  return namespace
end

return NameSpace
