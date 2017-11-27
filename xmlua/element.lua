local Element = {}

local Savable = require("xmlua.savable")
local Searchable = require("xmlua.searchable")

local metatable = {}
function metatable.__index(table, key)
  return Savable[key] or Searchable[key]
end

function Element.new(document, node)
  local element = {
    document = document,
    node = node,
  }
  setmetatable(element, metatable)
  return element
end

return Element
