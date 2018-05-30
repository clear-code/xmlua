local Comment = {}

local Node = require("xmlua.node")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:comment()
  return self:content()
end

function Comment.new(document, node)
  local comment = {
    document = document,
    node = node,
  }
  setmetatable(comment, metatable)
  return comment
end

return Comment
