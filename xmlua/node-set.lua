local NodeSet = {}

local methods = {}

local metatable = {}
function metatable.__index(node_set, key)
  return methods[key]
end

function methods.to_xml(self, options)
  local xml = ""
  for i in pairs(self) do
    xml = xml .. self[i]:to_xml(options)
  end
  return xml
end

function NodeSet.new(nodes)
  setmetatable(nodes, metatable)
  return nodes
end

return NodeSet
