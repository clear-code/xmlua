local Searchable = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local luacs = require("luacs")

local Attribute
local CDATASection
local Comment
local Element
local NodeSet
local ProcessingInstruction
local Text

function Searchable.lazy_load()
  Attribute = require("xmlua.attribute")
  CDATASection = require("xmlua.cdata-section")
  Comment = require("xmlua.comment")
  Element = require("xmlua.element")
  NodeSet = require("xmlua.node-set")
  ProcessingInstruction = require("xmlua.processing-instruction")
  Text = require("xmlua.text")
end

local ERROR_MESSAGES = {
  [ffi.C.XPATH_NUMBER_ERROR]             = "Number encoding\n",
  [ffi.C.XPATH_UNFINISHED_LITERAL_ERROR] = "Unfinished literal\n",
  [ffi.C.XPATH_START_LITERAL_ERROR]      = "Start of literal\n",
  [ffi.C.XPATH_VARIABLE_REF_ERROR]       = "Expected $ for variable reference\n",
  [ffi.C.XPATH_UNDEF_VARIABLE_ERROR]     = "Undefined variable\n",
  [ffi.C.XPATH_INVALID_PREDICATE_ERROR]  = "Invalid predicate\n",
  [ffi.C.XPATH_EXPR_ERROR]               = "Invalid expression\n",
  [ffi.C.XPATH_UNCLOSED_ERROR]           = "Missing closing curly brace\n",
  [ffi.C.XPATH_UNKNOWN_FUNC_ERROR]       = "Unregistered function\n",
  [ffi.C.XPATH_INVALID_OPERAND]          = "Invalid operand\n",
  [ffi.C.XPATH_INVALID_TYPE]             = "Invalid type\n",
  [ffi.C.XPATH_INVALID_ARITY]            = "Invalid number of arguments\n",
  [ffi.C.XPATH_INVALID_CTXT_SIZE]        = "Invalid context size\n",
  [ffi.C.XPATH_INVALID_CTXT_POSITION]    = "Invalid context position\n",
  [ffi.C.XPATH_MEMORY_ERROR]             = "Memory allocation error\n",
  [ffi.C.XPTR_SYNTAX_ERROR]              = "Syntax error\n",
  [ffi.C.XPTR_RESOURCE_ERROR]            = "Resource error\n",
  [ffi.C.XPTR_SUB_RESOURCE_ERROR]        = "Sub resource error\n",
  [ffi.C.XPATH_UNDEF_PREFIX_ERROR]       = "Undefined namespace prefix\n",
  [ffi.C.XPATH_ENCODING_ERROR]           = "Encoding error\n",
  [ffi.C.XPATH_INVALID_CHAR_ERROR]       = "Char out of XML range\n",
  [ffi.C.XPATH_INVALID_CTXT]             = "Invalid or incomplete context\n",
  [ffi.C.XPATH_STACK_ERROR]              = "Stack usage error\n",
  [ffi.C.XPATH_FORBID_VARIABLE_ERROR]    = "Forbidden variable\n",
}

function Searchable:search(xpath, namespaces)
  local document = self.document
  local context = libxml2.xmlXPathNewContext(document)
  if not context then
    error("failed to create XPath context")
  end
  if self.node then
    if not libxml2.xmlXPathSetContextNode(self.node, context) then
      error("failed to set target node: <" .. tostring(self.node) .. ">")
    end
  end
  if not namespaces then
    namespaces = self:root():namespaces()
  end
  if namespaces then
    for _, namespace in ipairs(namespaces) do
      local prefix = nil
      local href = nil
      if type(namespace.prefix) == "function" then
        prefix = namespace:prefix()
        href = namespace:href()
      else
        prefix = namespace.prefix
        href = namespace.href
      end
      if prefix then
        libxml2.xmlXPathRegisterNs(context, prefix, href)
      end
    end
  end
  local object = libxml2.xmlXPathEvalExpression(xpath, context)
  if not object then
    local raw_error_message = context.lastError.message
    if raw_error_message == ffi.NULL then
      local xpath_error_code =
        context.lastError.code - ffi.C.XML_XPATH_EXPRESSION_OK
      error(ERROR_MESSAGES[xpath_error_code])
    else
      error(ffi.string(context.lastError.message))
    end
  end

  local type = tonumber(object.type)
  if type == ffi.C.XPATH_NODESET then
    local found_node_set = object.nodesetval
    if found_node_set == ffi.NULL then
      return NodeSet.new({})
    end
    local raw_node_set = {}
    for i = 1, found_node_set.nodeNr do
      local node = found_node_set.nodeTab[i - 1]
      local node_type = tonumber(node.type)
      if node_type == ffi.C.XML_ELEMENT_NODE then
        table.insert(raw_node_set, Element.new(document, node))
      elseif node_type == ffi.C.XML_TEXT_NODE then
        table.insert(raw_node_set, Text.new(document, node))
      elseif node_type == ffi.C.XML_COMMENT_NODE then
        table.insert(raw_node_set, Comment.new(document, node))
      elseif node_type == ffi.C.XML_PI_NODE then
        table.insert(raw_node_set,
                     ProcessingInstruction.new(document, node))
      elseif node_type == ffi.C.XML_ATTRIBUTE_NODE then
        table.insert(raw_node_set, Attribute.new(document, node))
      elseif node_type == ffi.C.XML_CDATA_SECTION_NODE then
        table.insert(raw_node_set, CDATASection.new(document, node))
      else
        -- TODO: Support more nodes such as text node
        -- table.insert(raw_node_set, node)
      end
    end
    return NodeSet.new(raw_node_set)
  end
end

-- For LuaWebDriver compatibility
Searchable.xpath_search = Searchable.search

function Searchable:css_select(css_selector_groups)
  local xpaths = luacs.to_xpaths(css_selector_groups)
  local node_set = nil
  for _, xpath in ipairs(xpaths) do
    if self.node then
      xpath = "." .. xpath
    end
    if node_set == nil then
      node_set = self:search(xpath)
    else
      node_set = node_set + self:search(xpath)
    end
  end
  if node_set == nil then
    NodeSet.new({})
  else
    return node_set
  end
end

return Searchable
