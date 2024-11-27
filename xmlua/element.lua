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
local Text = require("xmlua.text")
local Namespace = require("xmlua.namespace")
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
  return methods.set_attribute(element, key, value)
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

local function set_default_namespace(node, namespace)
  if node.ns == ffi.NULL then
    libxml2.xmlSetNs(node, namespace)
  end
  local children = node.children
  while children ~= ffi.NULL do
    set_default_namespace(children, namespace)
    children = children.next
  end
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

local function remove_namespace(node, prefix)
  local is_target_namespace = function(namespace)
    if prefix then
      if namespace.prefix == ffi.NULL then
        return false
      end
      return ffi.string(namespace.prefix) == prefix
    else
      return namespace.prefix == ffi.NULL
    end
  end

  local namespace = node.nsDef
  local namespace_previous = nil
  while namespace ~= ffi.NULL do
    if is_target_namespace(namespace) then
      unset_namespace(node, namespace)
      if namespace_previous then
        namespace_previous.next = namespace.next
      else
        node.nsDef = namespace.next
      end
      libxml2.xmlFreeNs(namespace)
      return
    end
    namespace_previous = namespace
    namespace = namespace.next
  end
end

local function set_attributes(element, attributes)
  local raw_element = element.node
  local attributes_without_ns = {}
  if attributes then
    for name, value in pairs(attributes) do
      local namespace_prefix, local_name = parse_name(name)
      if namespace_prefix == "xmlns" then
        libxml2.xmlNewNs(raw_element, value, local_name)
      elseif namespace_prefix == nil and local_name == "xmlns" then
        libxml2.xmlNewNs(raw_element, value, nil)
      else
        attributes_without_ns[name] = value
      end
    end
  end

  for name, value in pairs(attributes_without_ns) do
    element:set_attribute(name, value)
  end
end

local function create_sub_element(document, parent, name, attributes)
  local namespace_prefix, local_name = parse_name(name)
  local node = libxml2.xmlNewNode(nil, local_name)
  local element = Element.new(document, node)
  set_attributes(element, attributes)
  local namespace = libxml2.xmlSearchNs(document.raw_document, node, namespace_prefix)
  if not namespace and parent then
    namespace = libxml2.xmlSearchNs(document.raw_document, parent, namespace_prefix)
  end
  if namespace then
    libxml2.xmlSetNs(node, namespace)
  elseif namespace_prefix then
    element:unlink()
    node = libxml2.xmlNewNode(nil, name)
    element = Element.new(document, node)
    set_attributes(element, attributes)
  end
  return element
end

function methods:add_child(element)
  local node
  if self.document == element.document then
    if element.node.parent ~= ffi.NULL then
      element:unlink()
    end
    node = element.node
    -- node back to the document but to the another place
    element.document.unlinked[node] = nil
  else
    node = libxml2.xmlDocCopyNode(element.node, self.document.raw_document)
  end
  libxml2.xmlAddChild(self.node, node)
end

function methods:add_previous_sibling(element)
  if not self.node and not element.node then
    error("Already freed receiver node and added node")
  elseif not self.node then
    error("Already freed receiver node")
  elseif not element.node then
    error("Already freed added node")
  end

  local raw_added_node, was_freed =
    libxml2.xmlAddPrevSibling(self.node, element.node)
  if was_freed then
    element.node = nil
  end
end

function methods:append_sibling(element)
  if not self.node and not element.node then
    error("Already freed receiver node and appended node")
  elseif not self.node then
    error("Already freed receiver node")
  elseif not element.node then
    error("Already freed appended node")
  end

  local was_freed = libxml2.xmlAddSibling(self.node, element.node)
  if was_freed then
    element.node = nil
  end
end

function methods:add_next_sibling(node)
  if not self.node and not node.node then
    error("Already freed receiver node and added node")
  elseif not self.node then
    error("Already freed receiver node")
  elseif not node.node then
    error("Already freed added node")
  end

  local was_freed =
    libxml2.xmlAddNextSibling(self.node, node.node)
  if was_freed then
    node.node = nil
  end
end

function methods:append_text(value)
  local raw_text = libxml2.xmlNewText(value)
  local added_raw_text = libxml2.xmlAddChild(self.node, raw_text)
  if added_raw_text then
    return Text.new(self.document, added_raw_text)
  else
    local text = Text.new(self.document, raw_text)
    text:unlink()
    return nil
  end
end

function methods:append_element(name, attributes)
  local sub_element = create_sub_element(self.document,
                                         self.node,
                                         name,
                                         attributes)
  if libxml2.xmlAddChild(self.node, sub_element.node) then
    return sub_element
  else
    sub_element:unlink()
    return nil
  end
end

function methods:insert_element(position, name, attributes)
  local base_element = libxml2.xmlFirstElementChild(self.node)
  for i = 1, position - 1 do
    if not base_element then
      return nil
    end
    base_element = libxml2.xmlNextElementSibling(base_element)
  end

  if not base_element then
    return self:append_element(name, attributes)
  end

  local sub_element = create_sub_element(self.document,
                                         self.node,
                                         name,
                                         attributes)
  if libxml2.xmlAddPrevSibling(base_element, sub_element.node) then
    return sub_element
  else
    sub_element:unlink()
    return nil
  end
end

function methods:unlink()
  Node.unlink(self)
  return self
end

function methods:get_attribute(name)
  local namespace_prefix, local_name = parse_name(name)
  if namespace_prefix == "xmlns" then
    local namespace = libxml2.xmlSearchNs(self.document.raw_document, self.node, local_name)
    if namespace then
      return ffi.string(namespace.href)
    else
      return nil
    end
  elseif namespace_prefix == ffi.NULL and local_name == "xmlns" then
    local namespace = libxml2.xmlSearchNs(self.document.raw_document, self.node, nil)
    if namespace then
      return ffi.string(namespace.href)
    else
      return nil
    end
  elseif namespace_prefix then
    local namespace = libxml2.xmlSearchNs(self.document.raw_document,
                                          self.node,
                                          namespace_prefix)
    if namespace then
      return libxml2.xmlGetNsProp(self.node, local_name, namespace.href)
    else
      return libxml2.xmlGetProp(self.node, name)
    end
  else
    return libxml2.xmlGetNoNsProp(self.node, name)
  end
end

function methods:set_attribute(name, value)
  if value == nil then
    return self:remove_attribute(name)
  end

  local namespace_prefix, local_name = parse_name(name)
  local namespace
  if namespace_prefix == "xmlns" then
    namespace = libxml2.xmlSearchNs(self.document.raw_document,
                                    self.node,
                                    local_name)
    if namespace then
      libxml2.xmlFree(ffi.cast("void *", namespace.href))
      namespace.href = libxml2.xmlStrdup(value)
    else
      libxml2.xmlNewNs(self.node, value, local_name)
    end
  elseif namespace_prefix == nil and local_name == "xmlns" then
    namespace = libxml2.xmlSearchNs(self.document.raw_document, self.node, nil)
    if namespace then
      libxml2.xmlFree(ffi.cast("void *", namespace.href))
      namespace.href = libxml2.xmlStrdup(value)
    else
      namespace = libxml2.xmlNewNs(self.node, value, nil)
      set_default_namespace(self.node, namespace)
    end
  elseif namespace_prefix then
    namespace = libxml2.xmlSearchNs(self.document.raw_document,
                                    self.node,
                                    namespace_prefix)
    if namespace then
      libxml2.xmlUnsetNsProp(self.node, namespace, local_name)
      libxml2.xmlNewNsProp(self.node, namespace, local_name, value)
    else
      libxml2.xmlUnsetProp(self.node, name)
      libxml2.xmlNewProp(self.node, name, value)
    end
  else
    libxml2.xmlUnsetProp(self.node, name)
    libxml2.xmlNewProp(self.node, name, value)
  end
end

function methods:remove_attribute(name)
  local namespace_prefix, local_name = parse_name(name)
  local namespace
  if namespace_prefix == "xmlns" then
    remove_namespace(self.node, local_name)
  elseif namespace_prefix == nil and local_name == "xmlns" then
    remove_namespace(self.node, nil)
  elseif namespace_prefix then
    namespace = libxml2.xmlSearchNs(self.document.raw_document,
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

function methods:name()
  return ffi.string(self.node.name)
end

function methods:previous()
  local element = libxml2.xmlPreviousElementSibling(self.node)
  if not element then
    return nil
  end
  return Element.new(self.document, element)
end

--- Gets the next sibling element.
-- @function next
-- @return xmlua.Element: The next sibling element.
function methods:next()
  local element = libxml2.xmlNextElementSibling(self.node)
  if not element then
    return nil
  end
  return Element.new(self.document, element)
end

function methods:root()
  return self.document:root()
end

function methods:parent()
  if tonumber(self.node.parent.type) == ffi.C.XML_DOCUMENT_NODE then
    return self.document
  else
    return Element.new(self.document, self.node.parent)
  end
end

function methods:children()
  local children = {}
  local child = libxml2.xmlFirstElementChild(self.node)
  while child do
    table.insert(children, Element.new(self.document, child))
    child = libxml2.xmlNextElementSibling(child)
  end
  return NodeSet.new(children)
end

function methods:text()
  return self:content()
end

function methods:namespaces()
  local raw_namespaces = libxml2.xmlGetNsList(self.document.raw_document, self.node)
  if not raw_namespaces then
    return nil
  end

  local namespaces = {}
  local i = 0;
  while raw_namespaces[i] ~= ffi.NULL do
    local raw_namespace = raw_namespaces[i]
    table.insert(namespaces, Namespace.new(self.document, raw_namespace))
    i = i + 1
  end
  return namespaces
end

function methods:set_namespace(namespace)
  libxml2.xmlSetNs(self.node, namespace.node)
end

function methods:find_namespace(prefix, href)
  local raw_namespace
  if not prefix and href then
    raw_namespace =
      libxml2.xmlSearchNsByHref(self.document.raw_document, self.node, href)
  else
    raw_namespace =
      libxml2.xmlSearchNs(self.document.raw_document, self.node, prefix)
  end
  return Namespace.new(self.document, raw_namespace)
end

-- For internal use
function Element.build(document, name, attributes)
  return create_sub_element(document, nil, name, attributes)
end

function Element.new(document, node)
  local element = {
    document = document,
    node = node
  }
  setmetatable(element, metatable)
  return element
end

return Element
