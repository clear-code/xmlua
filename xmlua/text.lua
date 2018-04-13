local Text = {}

local Node = require("xmlua.node")

local methods = {}

local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:text()
  return self:content()
end

function Text.new(document, node)
  local text = {
    document = document,
    node = node,
  }
  setmetatable(text, metatable)
  return text
end

return Text
