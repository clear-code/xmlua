local NodeSet = {}

local methods = {}

local metatable = {}

function metatable.__index(node_set, key)
  return methods[key]
end

function metatable.__add(added_node_set, add_node_set)
  return methods.merge(added_node_set, add_node_set)
end

local function map(values, func)
  local converted_values = {}
  for i, value in ipairs(values) do
    local converted_value = func(value)
    table.insert(converted_values, converted_value)
  end
  return converted_values
end

function methods:to_xml(options)
  return table.concat(map(self,
                          function(node)
                            return node:to_xml(options)
                          end),
                      "")
end

function methods:to_html(options)
  return table.concat(map(self,
                          function(node)
                            return node:to_html(options)
                          end),
                      "")
end

function methods:search(xpath)
  local node_set = nil
  for _, node in ipairs(self) do
    if node_set == nil then
      node_set = node:search(xpath)
    else
      node_set = node_set + node:search(xpath)
    end
  end
  return node_set
end

function methods:css_select(css_selectors)
  local node_set = nil
  for _, node in ipairs(self) do
    if node_set == nil then
      node_set = node:css_select(css_selectors)
    else
      node_set = node_set + node:css_select(css_selectors)
    end
  end
  return node_set
end

function methods:content(xpath)
  return table.concat(map(self,
                          function(node)
                            return node:content() or ""
                          end),
                      "")
end

methods.text = methods.content

function methods:paths()
  return map(self,
             function(node)
               return node:path()
             end)
end

function methods:insert(node_or_position, node)
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
      return
    end
  end
  if position == nil then
    table.insert(self, inserted_node)
  else
    table.insert(self, position, inserted_node)
  end
end

function methods:remove(node_or_position)
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

function methods:unlink()
  for _, node in ipairs(self) do
    node:unlink()
  end
end

local function is_included(node_set, search_node)
  for _, node in ipairs(node_set) do
    if node.node == search_node.node then
      return true
    end
  end
  return false
end

function methods:merge(node_set)
  local raw_node_set = {}
  for _, node in ipairs(self) do
    table.insert(raw_node_set, node)
  end
  for _, node in ipairs(node_set) do
    if not is_included(self, node) then
      table.insert(raw_node_set, node)
    end
  end
  return NodeSet.new(raw_node_set)
end

function NodeSet.new(nodes)
  setmetatable(nodes, metatable)
  return nodes
end

return NodeSet
