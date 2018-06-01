local Attr = {}

local Node = require("xmlua.node")
local Element = require("xmlua.element")
local ffi = require("ffi")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:name()
  return ffi.string(self.node.name)
end

function methods:content()
  return ffi.string(self.node.children.content)
end

function methods:value()
  return self:content()
end

function methods:get_owner_element()
  return Element.new(self.document,
                     self.node.parent)
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
