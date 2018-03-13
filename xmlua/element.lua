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
