local Element = {}

local Savable = require("xmlua.savable")

local metatable = {}
function metatable.__index(table, key)
  return Savable[key]
end

function Element.new(node)
  local element = {node = node}
  setmetatable(element, metatable)
  return element
end

return Element
