local C14n = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local DEFAULT_MODE = "C14N_EXCLUSIVE_1_0"

local Attribute
local AttributeDeclaration
local CDATASection
local Comment
local Document
local DocumentFragment
local DocumentType
local Element
local ElementDeclaration
local EntityDeclaration
local NamespaceDeclaration
local Notation
local ProcessingInstruction
local Text

function C14n.lazy_load()
  Attribute = require("xmlua.attribute")
  AttributeDeclaration = require("xmlua.attribute-declaration")
  Text = require("xmlua.text")
  CDATASection = require("xmlua.cdata-section")
  Comment = require("xmlua.comment")
  Document = require("xmlua.document")
  DocumentFragment = require("xmlua.document-fragment")
  DocumentType = require("xmlua.document-type")
  Element = require("xmlua.element")
  ElementDeclaration = require("xmlua.element-declaration")
  EntityDeclaration = require("xmlua.entity-declaration")
  NamespaceDeclaration = require("xmlua.namespace-declaration")
  Notation = require("xmlua.notation")
  ProcessingInstruction = require("xmlua.processing-instruction")
end



local C14N_MODES = {
  C14N_1_0            = ffi.C.XML_C14N_1_0,           -- Original C14N 1.0 spec
  C14N_EXCLUSIVE_1_0  = ffi.C.XML_C14N_EXCLUSIVE_1_0, -- Exclusive C14N 1.0 spec
  C14N_1_1            = ffi.C.XML_C14N_1_1,           -- C14N 1.1 spec
}



local C14N_MODES_LOOKUP = {} -- lookup by name or number, returns the number
for name, number in pairs(C14N_MODES) do
  C14N_MODES_LOOKUP[name] = number
  C14N_MODES_LOOKUP[number] = number
end



-- list can be a string (space separated), an array of strings, or nil
local function get_namespace_prefix_array(list)
  local list = list or {}

  if type(list) == "string" then
    -- list is a string, assume it is the space separated PrefixList attribute, split it
    local list_str = list
    list = {}
    list_str:gsub("([^%s]+)", function(cap) list[#list+1] = cap end)
  end

  if #list == 0 then
    return nil
  end

  local result = ffi.new('xmlChar*[?]', #list+1)
  local refs = {}
  for i, prefix in ipairs(list) do
    local c_ns = ffi.new("unsigned char[?]", #prefix+1, prefix)
    ffi.copy(c_ns, prefix)
    result[i-1] = c_ns
    refs[i] = c_ns -- hold on to refs to prevent GC while in use
  end
  result[#list] = nil

  return ffi.gc(result, function(ptr)
    refs = nil -- release references, so they can be GC'ed
  end)
end



local function create_xml_node_set(nodes)
  if (not nodes) or #nodes == 0 then
    return nil
  end

  local nodeTab = ffi.new("xmlNodePtr[?]", #nodes)
  for i = 1, #nodes do
      nodeTab[i - 1] = nodes[i] -- FFI side is 0 indexed
  end

  local set = ffi.new("xmlNodeSet")
  set.nodeNr = #nodes
  set.nodeMax = #nodes
  set.nodeTab = nodeTab

  return set
end



local wrap_raw_node do
  -- order is according to the constant value of xmlElementType enum in libxml2
  local type_generators = setmetatable({
    [ffi.C.XML_ELEMENT_NODE] = function(document, raw_node)
      return Element.new(document, raw_node)
    end,
    [ffi.C.XML_ATTRIBUTE_NODE] = function(document, raw_node)
      return Attribute.new(document, raw_node)
    end,
    [ffi.C.XML_TEXT_NODE] = function(document, raw_node)
      return Text.new(document, raw_node)
    end,
    [ffi.C.XML_CDATA_SECTION_NODE] = function(document, raw_node)
      return CDATASection.new(document, raw_node)
    end,
    [ffi.C.XML_ENTITY_REF_NODE] = function(document, raw_node)
      error("XML_ENTITY_REF_NODE not implemented")        -- TODO: implement
    end,
    [ffi.C.XML_ENTITY_NODE] = function(document, raw_node)
      error("XML_ENTITY_NODE not implemented")            -- TODO: implement
    end,
    [ffi.C.XML_PI_NODE] = function(document, raw_node)
      return ProcessingInstruction.new(document, raw_node)
    end,
    [ffi.C.XML_COMMENT_NODE] = function(document, raw_node)
      return Comment.new(document, raw_node)
    end,
    [ffi.C.XML_DOCUMENT_NODE] = function(document, raw_node)
      return Document.new(raw_node)
    end,
    [ffi.C.XML_DOCUMENT_TYPE_NODE] = function(document, raw_node)
      return DocumentType.new(document, raw_node)
    end,
    [ffi.C.XML_DOCUMENT_FRAG_NODE] = function(document, raw_node)
      return DocumentFragment.new(document, raw_node)
    end,
    [ffi.C.XML_NOTATION_NODE] = function(document, raw_node)
      return Notation.new(document, raw_node)
    end,
    [ffi.C.XML_HTML_DOCUMENT_NODE] = function(document, raw_node)
      error("XML_HTML_DOCUMENT_NODE not implemented")     -- TODO: implement
    end,
    [ffi.C.XML_DTD_NODE] = function(document, raw_node)
      error("XML_DTD_NODE not implemented")               -- TODO: implement
    end,
    [ffi.C.XML_ELEMENT_DECL] = function(document, raw_node)
      return ElementDeclaration.new(document, raw_node)
    end,
    [ffi.C.XML_ATTRIBUTE_DECL] = function(document, raw_node)
      return AttributeDeclaration.new(document, raw_node)
    end,
    [ffi.C.XML_ENTITY_DECL] = function(document, raw_node)
      return EntityDeclaration.new(document, raw_node)
    end,
    [ffi.C.XML_NAMESPACE_DECL] = function(document, raw_node)
      return NamespaceDeclaration.new(document, raw_node)
    end,
    [ffi.C.XML_XINCLUDE_START] = function(document, raw_node)
      error("XML_XINCLUDE_START not implemented")         -- TODO: implement
    end,
    [ffi.C.XML_XINCLUDE_END] = function(document, raw_node)
      error("XML_XINCLUDE_END not implemented")           -- TODO: implement
    end,
    [ffi.C.XML_DOCB_DOCUMENT_NODE] = function(document, raw_node)
      error("XML_DOCB_DOCUMENT_NODE not implemented")     -- TODO: implement
    end,
  }, {
    __index = function(self, key)
      error("Unknown node type: " .. tostring(key))
    end
  })

  function wrap_raw_node(document, raw_node)
    if raw_node == ffi.NULL then
      return nil
    end
    return type_generators[tonumber(raw_node.type)](document, raw_node)
  end
end



--- Canonicalise an xmlDocument or set of elements.
-- @param self xmlDoc from which to canonicalize elements
-- @param select array of nodes to include, or function to determine if a node should be included in the canonicalized output.
--        Signature: `boolean = function(node, parent)`
-- @param mode any of C14N_1_0, C14N_EXCLUSIVE_1_0 (default), C14N_1_1
-- @param inclusive_ns_prefixes array, or space-separated string, of namespace prefixes to include
-- @param with_comments if truthy, comments will be included (default: false)
-- @return string containing canonicalized xml
function C14n:canonicalize(select, mode, inclusive_ns_prefixes, with_comments)
  if mode == nil then
    mode = DEFAULT_MODE
  end
  with_comments = with_comments and 1 or 0 -- default = not including comments

  if not C14N_MODES_LOOKUP[mode] then
    error("mode must be a valid C14N mode constant, got: " .. tostring(mode))
  end
  mode = C14N_MODES_LOOKUP[mode]

  local prefixes = get_namespace_prefix_array(inclusive_ns_prefixes)
  local buffer = libxml2.xmlBufferCreate()
  local output_buffer = libxml2.xmlOutputBufferCreate(buffer)

  local success
  if type(select) == "function" then  -- callback function
    -- wrap the callback to pass wrapped objects, and return 1 or 0
    local cbwrapper = function(_, nodePtr, parentPtr)
      return select(wrap_raw_node(self, nodePtr), wrap_raw_node(self, parentPtr)) and 1 or 0
    end
    success = libxml2.xmlC14NExecute(self.document, cbwrapper, nil, mode,
                                      prefixes, with_comments, output_buffer)

  elseif type(select) == "table" then  -- array of nodes
    local nodeSet = create_xml_node_set(select)
    success = libxml2.xmlC14NDocSaveTo(self.document, nodeSet, mode,
                                      prefixes, with_comments, output_buffer)
  else
    error("select must be a function or an array of nodes")
  end

  if success < 0 then
    return nil, "failed to generate C14N string"
  end
  return libxml2.xmlBufferGetContent(buffer)
end


return C14n
