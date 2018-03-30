--- @module xmlua

--- The class for element node.
-- @type Element

local Element = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Serializable = require("xmlua.serializable")
local Searchable = require("xmlua.searchable")

local Node = require("xmlua.node")
local Document = require("xmlua.document")
local NodeSet = require("xmlua.node-set")

local methods = {}

local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key] or
    Serializable[key] or
    Searchable[key] or
    methods.get_attribute(element, key)
end

function metatable.__newindex(element, key, value)
  if key == "text" then
    return methods.append_text(element, value)
  else
    return methods.set_attribute(element, key, value)
  end
end

function methods.append_text(self, value)
  local raw_text = libxml2.xmlNewText(value)
  local new_text = Element.new(self.document, raw_text)
  if libxml2.xmlAddChild(self.node, new_text.node) then
    return new_text
  end
end

local function parse_name(name)
  local colon_start = name:find(":")
  local namespace_prefix
  local local_name
  if colon_start then
    namespace_prefix = name:sub(1, colon_start - 1)
    local_name = name:sub(colon_start + 1)
  else
    namespace_prefix = nil
    local_name = name
  end
  return namespace_prefix, local_name
end

function methods.append_element(self, name, attributes)
  local raw_element = nil
  local colon_start = name:find(":")
  if colon_start then
    local namespace_prefix = name:sub(0, colon_start - 1)
    local local_name = name:sub(colon_start + 1)
    local namespace = libxml2.xmlSearchNs(self.document,
                                          self.node,
                                          namespace_prefix)
    if namespace then
      raw_element = libxml2.xmlNewNode(namespace, local_name)
    else
      raw_element = libxml2.xmlNewNode(nil, local_name)

      local new_namespace = nil
      for attribute_name, uri in pairs(attributes) do
        local _, prefix_start = attribute_name:find("xmlns:")
        if prefix_start then
          local new_namespace_prefix = attribute_name:sub(prefix_start + 1)
          new_namespace = libxml2.xmlNewNs(raw_element,
                                           uri,
                                           new_namespace_prefix)
          libxml2.xmlSetNs(raw_element, new_namespace)
          attributes[attribute_name] = nil
          break
        end
      end
    end
  else
    raw_element = libxml2.xmlNewNode(nil, name)
  end
  local new_element = Element.new(self.document, raw_element)
  if attributes then
    for name, value in pairs(attributes) do
      new_element:set_attribute(name, value)
    end
  end
  if libxml2.xmlAddChild(self.node, new_element.node) then
    return new_element
  end
end

function methods.insert_element(self, position, name, attributes)
  raw_element = nil
  local colon_start = name:find(":")
  if colon_start then
    local namespace_prefix = name:sub(0, colon_start - 1)
    local local_name = name:sub(colon_start + 1)
    local namespace = libxml2.xmlSearchNs(self.document,
                                          self.node,
                                          namespace_prefix)
    if namespace then
      raw_element = libxml2.xmlNewNode(namespace, local_name)
    else
      raw_element = libxml2.xmlNewNode(nil, local_name)

      local new_namespace = nil
      for attribute_name, uri in pairs(attributes) do
        local _, prefix_start = attribute_name:find("xmlns:")
        if prefix_start then
          local new_namespace_prefix = attribute_name:sub(prefix_start + 1)
          new_namespace = libxml2.xmlNewNs(raw_element,
                                           uri,
                                           new_namespace_prefix)
          libxml2.xmlSetNs(raw_element, new_namespace)
          attributes[attribute_name] = nil
          break
        end
      end
    end
  else
    raw_element = libxml2.xmlNewNode(nil, name)
  end
  local new_element = Element.new(self.document, raw_element)
  if attributes then
    for name, value in pairs(attributes) do
      new_element:set_attribute(name, value)
    end
  end
  if libxml2.xmlAddPrevSibling(self:children()[position].node,
                               new_element.node) then
    return new_element
  end
end

function methods.unlink(self)
  local unlinked_node = Node.unlink(self)
  return Element.new(nil, unlinked_node)
end

function methods.get_attribute(self, name)
  local value = nil
  local colon_start = name:find(":")
  if colon_start then
    local namespace_prefix = name:sub(0, colon_start - 1)
    local local_name = name:sub(colon_start + 1)
    local namespace = libxml2.xmlSearchNs(self.document,
                                          self.node,
                                          namespace_prefix)
    if namespace then
      value = libxml2.xmlGetNsProp(self.node, local_name, namespace.href)
    else
      value = libxml2.xmlGetProp(self.node, name)
    end
  else
    value = libxml2.xmlGetNoNsProp(self.node, name)
  end
  return value
end

function methods.set_attribute(self, name, value)
  local colon_start = name:find(":")
  if colon_start then
    local namespace_prefix = name:sub(0, colon_start - 1)
    local local_name = name:sub(colon_start + 1)
    local namespace = libxml2.xmlSearchNs(self.document,
                                          self.node,
                                          namespace_prefix)
    if namespace then
      libxml2.xmlNewNsProp(self.node, namespace, local_name, value)
      return
    end
  end
  libxml2.xmlNewProp(self.node, name, value)
end

local function unset_namespace(node, namespace)
  if node.ns == namespace then
    node.ns = ffi.NULL
  end
  local attributes = node.properties
  while attributes ~= ffi.NULL do
    if attributes.ns == namespace then
      attributes.ns = ffi.NULL
    end
    attributes = attributes.next
  end
  local children = node.children
  while children ~= ffi.NULL do
    unset_namespace(children, namespace)
    children = children.next
  end
end

local function remove_namespace(node, namespace, namespace_previous)
  unset_namespace(node, namespace)
  if namespace_previous then
    namespace_previous.next = namespace.next
  else
    node.nsDef = namespace.next
  end
  libxml2.xmlFreeNs(namespace)
end

function methods.remove_attribute(self, name)
  local namespace_prefix, local_name = parse_name(name)
  local namespace
  if namespace_prefix == "xmlns" then
    namespace = self.node.nsDef
    local namespace_previous = nil
    while namespace ~= ffi.NULL do
      if ffi.string(namespace.prefix) == local_name then
        remove_namespace(self.node, namespace, namespace_previous)
        return
      end
      namespace_previous = namespace
      namespace = namespace.next
    end
  elseif namespace_prefix == nil and local_name == "xmlns" then
    namespace = self.node.nsDef
    local namespace_previous = nil
    while namespace ~= ffi.NULL do
      if namespace.prefix == ffi.NULL then
        remove_namespace(self.node, namespace, namespace_previous)
        return
      end
      namespace_previous = namespace
      namespace = namespace.next
    end
  elseif namespace_prefix then
    namespace = libxml2.xmlSearchNs(self.document,
                                    self.node,
                                    namespace_prefix)
    if namespace then
      libxml2.xmlUnsetNsProp(self.node, namespace, local_name)
    else
      libxml2.xmlUnsetProp(self.node, name)
    end
  else
    libxml2.xmlUnsetProp(self.node, name)
  end
end

function methods.name(self)
  return ffi.string(self.node.name)
end

function methods.previous(self)
  local element = libxml2.xmlPreviousElementSibling(self.node)
  if not element then
    return nil
  end
  return Element.new(self.document, element)
end

--- Gets the next sibling element.
-- @function next
-- @return xmlua.Element: The next sibling element.
function methods.next(self)
  local element = libxml2.xmlNextElementSibling(self.node)
  if not element then
    return nil
  end
  return Element.new(self.document, element)
end

function methods.parent(self)
  if tonumber(self.node.parent.type) == ffi.C.XML_DOCUMENT_NODE then
    return Document.new(self.document)
  else
    return Element.new(self.document, self.node.parent)
  end
end

function methods.children(self)
  local children = {}
  local child = libxml2.xmlFirstElementChild(self.node)
  while child do
    table.insert(children, Element.new(self.document, child))
    child = libxml2.xmlNextElementSibling(child)
  end
  return NodeSet.new(children)
end

function methods.text(self)
  return self:content()
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
