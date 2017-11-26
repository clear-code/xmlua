local NodeSet = {}

local metatable = {}

function NodeSet.new(nodes)
  setmetatable(nodes, metatable)
  return nodes
end

return NodeSet
