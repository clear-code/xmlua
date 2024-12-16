local Text = {}

local libxml2 = require("xmlua.libxml2")
local Node = require("xmlua.node")

local methods = {}

local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:node_name()
  return "text"
end

function methods:text()
  return self:content()
end

function methods:concat(content)
  return libxml2.xmlTextConcat(self.node,
                               content,
                               content:len())
end

function methods:merge(merge_node)
  if not self.node and not merge_node.node then
    error("Already freed receiver node and merged node")
  elseif not self.node then
    error("Already freed receiver node")
  elseif not merge_node.node then
    error("Already freed merged node")
  end

  local was_freed = libxml2.xmlTextMerge(self.node, merge_node.node)
  if was_freed then
    merge_node.node = nil
  end
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
