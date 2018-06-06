local DocumentFragment = {}

local Element = require("xmlua.element")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key]
end

function DocumentFragment.new(document, node)
  return Element.new(document, node)
end

return DocumentFragment
