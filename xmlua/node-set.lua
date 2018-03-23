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
                          function(node)
                            return node:to_xml(options)
                          end),
                      "")
end

function methods.to_html(self, options)
  return table.concat(map(self,
                          function(node)
                            return node:to_html(options)
                          end),
                      "")
end

function methods.search(self, xpath)
  local nodes = {}
  for i, node in ipairs(self) do
    local sub_nodes = node:search(xpath)
    for j, sub_node in ipairs(sub_nodes) do
      table.insert(nodes, sub_node)
    end
  end
  return NodeSet.new(nodes)
end

function methods.css_select(self, css_selectors)
  local nodes = {}
  for i, node in ipairs(self) do
    local sub_nodes = node:css_select(css_selectors)
    for j, sub_node in ipairs(sub_nodes) do
      table.insert(nodes, sub_node)
    end
  end
  return NodeSet.new(nodes)
end

function methods.content(self, xpath)
  return table.concat(map(self,
                          function(node)
                            return node:content() or ""
                          end),
                      "")
end

methods.text = methods.content

function methods.paths(self)
  return map(self,
             function(node)
               return node:path()
             end)
end

function methods.insert(self, node_or_position, node)
  local inserted_node = nil
  local position = nil

  if node == nil then
    inserted_node = node_or_position
  else
    position = node_or_position
    inserted_node = node
  end
  for i, self_node in ipairs(self) do
    if self_node.node == inserted_node.node then
      return nil
    end
  end
  if position == nil then
    return table.insert(self, inserted_node)
  else
    return table.insert(self, position, inserted_node)
  end
end

function methods.remove(self, node_or_position)
  if type(node_or_position) == "number" then
    local position = node_or_position
    return table.remove(self, position)
  else
    local node = node_or_position
    for position, self_node in ipairs(self) do
      if self_node.node == node.node then
        return table.remove(self, position)
      end
    end
    return nil
  end
end

function NodeSet.new(nodes)
  setmetatable(nodes, metatable)
  return nodes
end

return NodeSet
