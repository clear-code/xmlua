local Searchable = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Element = require("xmlua.element")
local NodeSet = require("xmlua.node-set")

local ERROR_MESSAGES = {}
ERROR_MESSAGES[ffi.C.XPATH_NUMBER_ERROR]             = "Number encoding\n"
ERROR_MESSAGES[ffi.C.XPATH_UNFINISHED_LITERAL_ERROR] = "Unfinished literal\n"
ERROR_MESSAGES[ffi.C.XPATH_START_LITERAL_ERROR]      = "Start of literal\n"
ERROR_MESSAGES[ffi.C.XPATH_VARIABLE_REF_ERROR]       = "Expected $ for variable reference\n"
ERROR_MESSAGES[ffi.C.XPATH_UNDEF_VARIABLE_ERROR]     = "Undefined variable\n"
ERROR_MESSAGES[ffi.C.XPATH_INVALID_PREDICATE_ERROR]  = "Invalid predicate\n"
ERROR_MESSAGES[ffi.C.XPATH_EXPR_ERROR]               = "Invalid expression\n"
ERROR_MESSAGES[ffi.C.XPATH_UNCLOSED_ERROR]           = "Missing closing curly brace\n"
ERROR_MESSAGES[ffi.C.XPATH_UNKNOWN_FUNC_ERROR]       = "Unregistered function\n"
ERROR_MESSAGES[ffi.C.XPATH_INVALID_OPERAND]          = "Invalid operand\n"
ERROR_MESSAGES[ffi.C.XPATH_INVALID_TYPE]             = "Invalid type\n"
ERROR_MESSAGES[ffi.C.XPATH_INVALID_ARITY]            = "Invalid number of arguments\n"
ERROR_MESSAGES[ffi.C.XPATH_INVALID_CTXT_SIZE]        = "Invalid context size\n"
ERROR_MESSAGES[ffi.C.XPATH_INVALID_CTXT_POSITION]    = "Invalid context position\n"
ERROR_MESSAGES[ffi.C.XPATH_MEMORY_ERROR]             = "Memory allocation error\n"
ERROR_MESSAGES[ffi.C.XPTR_SYNTAX_ERROR]              = "Syntax error\n"
ERROR_MESSAGES[ffi.C.XPTR_RESOURCE_ERROR]            = "Resource error\n"
ERROR_MESSAGES[ffi.C.XPTR_SUB_RESOURCE_ERROR]        = "Sub resource error\n"
ERROR_MESSAGES[ffi.C.XPATH_UNDEF_PREFIX_ERROR]       = "Undefined namespace prefix\n"
ERROR_MESSAGES[ffi.C.XPATH_ENCODING_ERROR]           = "Encoding error\n"
ERROR_MESSAGES[ffi.C.XPATH_INVALID_CHAR_ERROR]       = "Char out of XML range\n"
ERROR_MESSAGES[ffi.C.XPATH_INVALID_CTXT]             = "Invalid or incomplete context\n"
ERROR_MESSAGES[ffi.C.XPATH_STACK_ERROR]              = "Stack usage error\n"
ERROR_MESSAGES[ffi.C.XPATH_FORBID_VARIABLE_ERROR]    = "Forbidden variable\n"

function Searchable.search(self, xpath)
  local context = libxml2.xmlXPathNewContext(self.document)
  local object = libxml2.xmlXPathEvalExpression(xpath, context)
  if not object then
    local raw_error_message = context.lastError.message
    if raw_error_message == ffi.NULL then
      local xpath_error_code =
        context.lastError.code - ffi.C.XML_XPATH_EXPRESSION_OK
      error({message = ERROR_MESSAGES[xpath_error_code]})
    else
      error({message = ffi.string(context.lastError.message)})
    end
  end

  local type = tonumber(object.type)
  if type == ffi.C.XPATH_NODESET then
    local found_node_set = object.nodesetval
    local raw_node_set = {}
    for i = 1, found_node_set.nodeNr do
      local node = found_node_set.nodeTab[i - 1]
      if tonumber(node.type) == ffi.C.XML_ELEMENT_NODE then
        table.insert(raw_node_set, Element.new(node))
      else
        table.insert(raw_node_set, node)
      end
    end
    return(NodeSet.new(raw_node_set))
  end
end

return Searchable
