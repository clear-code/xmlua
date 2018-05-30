local Comment = {}

local libxml2 = require("xmlua.libxml2")
local Node = require("xmlua.node")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods.set_content(self, content)
  libxml2.xmlNodeSetContent(self.node, content)
  return
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
