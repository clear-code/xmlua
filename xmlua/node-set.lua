local NodeSet = {}

local methods = {}

local metatable = {}
function metatable.__index(node_set, key)
  return methods[key]
end

local function map(values, func)
  local converted_values = {}
  for i, value in ipairs(values) do
    local converted_value = func(value)
    table.insert(converted_values, converted_value)
  end
  return converted_values
end

function methods.to_xml(self, options)
  return table.concat(map(self,
                          function(value)
                            return value:to_xml(options)
                          end),
                      "")
end

function methods.to_html(self, options)
  return table.concat(map(self,
                          function(value)
                            return value:to_html(options)
                          end),
                      "")
end

function NodeSet.new(nodes)
  setmetatable(nodes, metatable)
  return nodes
end

return NodeSet
