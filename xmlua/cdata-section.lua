local CDATASection = {}

local Node = require("xmlua.node")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function CDATASection.new(document, node)
  local cdata_section = {
    document = document,
    node = node,
  }
  setmetatable(cdata_section, metatable)
  return cdata_section
end

return CDATASection
