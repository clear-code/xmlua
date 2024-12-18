local Document = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")
local converter = require("xmlua.converter")

local Serializable = require("xmlua.serializable")
local Searchable = require("xmlua.searchable")


local Attribute
local AttributeDeclaration
local CDATASection
local Comment
local DocumentFragment
local DocumentType
local Element
local ElementDeclaration
local EntityDeclaration
local EntityReference
local Namespace
local NamespaceDeclaration
local Notation
local ProcessingInstruction
local Text

function Document.lazy_load()
  Attribute = require("xmlua.attribute")
  AttributeDeclaration = require("xmlua.attribute-declaration")
  CDATASection = require("xmlua.cdata-section")
  Comment = require("xmlua.comment")
  DocumentFragment = require("xmlua.document-fragment")
  DocumentType = require("xmlua.document-type")
  Element = require("xmlua.element")
  ElementDeclaration = require("xmlua.element-declaration")
  EntityDeclaration = require("xmlua.entity-declaration")
  EntityReference = require("xmlua.entity-reference")
  Namespace = require("xmlua.namespace")
  NamespaceDeclaration = require("xmlua.namespace-declaration")
  Notation = require("xmlua.notation")
  ProcessingInstruction = require("xmlua.processing-instruction")
  Text = require("xmlua.text")
end

local DEFAULT_C14N_MODE = "EXCLUSIVE_1_0"

local C14N_MODES = {
  ["1_0"]           = ffi.C.XML_C14N_1_0,           -- Original C14N 1.0 spec
  ["EXCLUSIVE_1_0"] = ffi.C.XML_C14N_EXCLUSIVE_1_0, -- Exclusive C14N 1.0 spec
  ["1_1"]           = ffi.C.XML_C14N_1_1,           -- C14N 1.1 spec
}

local C14N_MODES_LOOKUP = {} -- lookup by name or number, returns the number
for name, number in pairs(C14N_MODES) do
  C14N_MODES_LOOKUP[name] = number
  C14N_MODES_LOOKUP[number] = number
end

local methods = {}

local metatable = {}

function metatable.__index(document, key)
  return methods[key] or
    Serializable[key] or
    Searchable[key]
end

function methods:node_name()
  return "document"
end

function methods:root()
  local root_element = libxml2.xmlDocGetRootElement(self.document)
  if not root_element then
    return nil
  end
  return Element.new(self.document, root_element)
end

function methods:parent()
  return nil
end

function methods:encoding()
  return ffi.string(self.document.encoding)
end

function methods:create_cdata_section(data)
  local raw_cdata_section_node =
    libxml2.xmlNewCDataBlock(self.document,
                             data,
                             data:len())
  return CDATASection.new(self.document, raw_cdata_section_node)
end

function methods:create_comment(data)
  local raw_comment_node =
    libxml2.xmlNewComment(data)
  return Comment.new(self.document, raw_comment_node)
end

function methods:create_document_fragment()
  local raw_document_fragment_node =
    libxml2.xmlNewDocFragment(self.document)
  return DocumentFragment.new(self.document,
                              raw_document_fragment_node)
end

function methods:create_document_type(name, external_id, system_id)
  local raw_document_type =
    libxml2.xmlCreateIntSubset(self.document, name, external_id, system_id)
  return DocumentType.new(self.document,
                          raw_document_type)
end

function methods:get_internal_subset()
  local raw_document_type =
    libxml2.xmlGetIntSubset(self.document)
  if raw_document_type ~= nil then
    return DocumentType.new(self.document,
                            raw_document_type)
  else
    return nil
  end
end

function methods:add_entity_reference(name)
  local raw_entity_reference =
    libxml2.xmlNewReference(self.document, name)
  return EntityReference.new(self.document,
                             raw_entity_reference)
end

function methods:create_namespace(href, prefix)
  local raw_namespace =
    libxml2.xmlNewNs(self.node, href, prefix)
  return Namespace.new(self.document, raw_namespace)
end

function methods:create_processing_instruction(name, content)
  local raw_processing_instruction =
    libxml2.xmlNewPI(name, content)
  return ProcessingInstruction.new(self.document,
                             raw_processing_instruction)
end

function methods:add_entity(entity_info)
  local entity_type_name = entity_info["entity_type"]
  local entity_type = converter.convert_entity_type_name(entity_type_name)
  local raw_entity = libxml2.xmlAddDocEntity(self.document,
                                             entity_info["name"],
                                             entity_type,
                                             entity_info["external_id"],
                                             entity_info["system_id"],
                                             entity_info["content"])
  return converter.convert_xml_entity(raw_entity)
end

function methods:get_entity(name)
  local raw_entity = libxml2.xmlGetDocEntity(self.document, name)
  return converter.convert_xml_entity(raw_entity)
end

function methods:add_dtd_entity(entity_info)
  local entity_type_name = entity_info["entity_type"]
  local entity_type = converter.convert_entity_type_name(entity_type_name)
  local raw_dtd_entity =  libxml2.xmlAddDtdEntity(self.document,
                                              entity_info["name"],
                                              entity_type,
                                              entity_info["external_id"],
                                              entity_info["system_id"],
                                              entity_info["content"])
  return converter.convert_xml_entity(raw_dtd_entity)
end

function methods:get_dtd_entity(name)
  local raw_dtd_entity = libxml2.xmlGetDtdEntity(self.document, name)
  return converter.convert_xml_entity(raw_dtd_entity)
end


do  -- C14N methods
  local function create_xml_string_array(list)
    if (not list) or #list == 0 then
      return nil
    end

    local result = ffi.new('xmlChar*[?]', #list+1)
    local xml_nses = {}
    for i, prefix in ipairs(list) do
      local xml_ns = ffi.new("unsigned char[?]", #prefix+1, prefix)
      ffi.copy(xml_ns, prefix)
      result[i-1] = xml_ns
      xml_nses[i] = xml_ns -- hold on to xml_nses to prevent GC while in use
    end
    result[#list] = nil

    return ffi.gc(result, function(ptr)
      xml_nses = nil -- release references, so they can be GC'ed
    end)
  end

  local function create_xml_node_set(nodes)
    if (not nodes) or #nodes == 0 then
      return nil
    end

    local xml_nodes = ffi.new("xmlNodePtr[?]", #nodes)
    for i = 1, #nodes do
      xml_nodes[i - 1] = nodes[i].node -- FFI side is 0 indexed
    end

    local set = ffi.new("xmlNodeSet")
    set.nodeNr = #nodes
    set.nodeMax = #nodes
    set.nodeTab = xml_nodes

    return ffi.gc(set, function(ptr)
      xml_nodes = nil -- release references, so they can be GC'ed
    end)
  end

  local wrap_raw_node do
    -- order is according to the constant value of xmlElementType enum in libxml2
    local type_generators = setmetatable({
      [ffi.C.XML_ELEMENT_NODE] = function(document, xml_node)
        return Element.new(document, xml_node)
      end,
      [ffi.C.XML_ATTRIBUTE_NODE] = function(document, xml_node)
        return Attribute.new(document, xml_node)
      end,
      [ffi.C.XML_TEXT_NODE] = function(document, xml_node)
        return Text.new(document, xml_node)
      end,
      [ffi.C.XML_CDATA_SECTION_NODE] = function(document, xml_node)
        return CDATASection.new(document, xml_node)
      end,
      [ffi.C.XML_ENTITY_REF_NODE] = function(document, xml_node)
        error("XML_ENTITY_REF_NODE not implemented")        -- TODO: implement
      end,
      [ffi.C.XML_ENTITY_NODE] = function(document, xml_node)
        error("XML_ENTITY_NODE not implemented")            -- TODO: implement
      end,
      [ffi.C.XML_PI_NODE] = function(document, xml_node)
        return ProcessingInstruction.new(document, xml_node)
      end,
      [ffi.C.XML_COMMENT_NODE] = function(document, xml_node)
        return Comment.new(document, xml_node)
      end,
      [ffi.C.XML_DOCUMENT_NODE] = function(document, xml_node)
        return Document.new(xml_node)
      end,
      [ffi.C.XML_DOCUMENT_TYPE_NODE] = function(document, xml_node)
        return DocumentType.new(document, xml_node)
      end,
      [ffi.C.XML_DOCUMENT_FRAG_NODE] = function(document, xml_node)
        return DocumentFragment.new(document, xml_node)
      end,
      [ffi.C.XML_NOTATION_NODE] = function(document, xml_node)
        return Notation.new(document, xml_node)
      end,
      [ffi.C.XML_HTML_DOCUMENT_NODE] = function(document, xml_node)
        error("XML_HTML_DOCUMENT_NODE not implemented")     -- TODO: implement
      end,
      [ffi.C.XML_DTD_NODE] = function(document, xml_node)
        error("XML_DTD_NODE not implemented")               -- TODO: implement
      end,
      [ffi.C.XML_ELEMENT_DECL] = function(document, xml_node)
        return ElementDeclaration.new(document, xml_node)
      end,
      [ffi.C.XML_ATTRIBUTE_DECL] = function(document, xml_node)
        return AttributeDeclaration.new(document, xml_node)
      end,
      [ffi.C.XML_ENTITY_DECL] = function(document, xml_node)
        return EntityDeclaration.new(document, xml_node)
      end,
      [ffi.C.XML_NAMESPACE_DECL] = function(document, xml_node)
        return NamespaceDeclaration.new(document, xml_node)
      end,
      [ffi.C.XML_XINCLUDE_START] = function(document, xml_node)
        error("XML_XINCLUDE_START not implemented")         -- TODO: implement
      end,
      [ffi.C.XML_XINCLUDE_END] = function(document, xml_node)
        error("XML_XINCLUDE_END not implemented")           -- TODO: implement
      end,
      [ffi.C.XML_DOCB_DOCUMENT_NODE] = function(document, xml_node)
        error("XML_DOCB_DOCUMENT_NODE not implemented")     -- TODO: implement
      end,
    }, {
      __index = function(self, key)
        error("Unknown node type: " .. tostring(key))
      end
    })

    function wrap_xml_node(document, xml_node)
      if xml_node == ffi.NULL then
        return nil
      end
      return type_generators[tonumber(xml_node.type)](document, xml_node)
    end
  end

  --- Canonicalize an XML document or set of elements.
  -- @param self xmlua.Document from which to canonicalize elements
  -- @tparam[opt={}] array|function select array of nodes to include, or function to determine if a node should be
  --        included in the canonicalized output. Signature: `boolean = function(node, parent)`. Defaults to an empty
  --        array, which canonicalizes the entire document.
  -- @tparam[opt] table opts options table with the following fields:
  -- @tparam[opt="EXCLUSIVE_1_0"] string|number opts.mode any of '1_0", "EXCLUSIVE_1_0", "1_1"
  -- @tparam[opt] array opts.inclusive_ns_prefixes array of namespace prefixes to include
  -- @tparam[opt=false] boolean with_comments if truthy, comments will be included
  -- @return string containing canonicalized XML, or throws an error if it fails
  function methods:canonicalize(select, opts)
    select = select or {} -- default to include all nodes in the output
    opts = opts or {}

    local with_comments = 0 -- default = not including comments
    if opts.with_comments then
      with_comments = 1
    end

    local mode = opts.mode or DEFAULT_C14N_MODE
    if not C14N_MODES_LOOKUP[mode] then
      error("mode must be a valid C14N mode constant, got: " .. tostring(mode))
    end
    mode = C14N_MODES_LOOKUP[mode]

    local prefixes = create_xml_string_array(opts.inclusive_ns_prefixes)
    local buffer = libxml2.xmlBufferCreate()
    local output_buffer = libxml2.xmlOutputBufferCreate(buffer)

    local success
    if type(select) == "function" then  -- callback function
      -- wrap the callback to pass wrapped objects, and return 1 or 0
      local callback = function(_, xml_node, xml_parent)
        local node = wrap_xml_node(self, xml_node)
        local parent = wrap_xml_node(self, xml_parent)
        if select(node, parent) then
          return 1
        else
          return 0
        end
      end
      success = libxml2.xmlC14NExecute(self.document, callback, nil, mode,
                                       prefixes, with_comments, output_buffer)

    elseif type(select) == "table" then  -- array of nodes
      local node_set = create_xml_node_set(select)
      success = libxml2.xmlC14NDocSaveTo(self.document, node_set, mode,
                                         prefixes, with_comments, output_buffer)
    else
      error("select must be a function or an array of nodes")
    end

    if success < 0 then
      error("failed to generate C14N string")
    end
    return libxml2.xmlBufferGetContent(buffer)
  end
end -- end of C14N methods

local function build_element(element, tree)
  local sub_element = element:append_element(tree[1], tree[2])
  for i = 3, #tree do
    if type(tree[i]) == "table" then
      build_element(sub_element, tree[i])
    else
      sub_element:append_text(tree[i])
    end
  end
end

function Document.build(raw_document, tree)
  local document = Document.new(raw_document)
  if #tree == 0 then
    return document
  end

  local root = Element.build(document, tree[1], tree[2])
  if not libxml2.xmlDocSetRootElement(raw_document, root.node) then
    root:unlink()
    return nil
  end

  for i = 3, #tree do
    if type(tree[i]) == "table" then
      build_element(root, tree[i])
    else
      root:append_text(tree[i])
    end
  end

  return document
end

function Document.new(raw_document, errors)
  if not errors then
    errors = {}
  end
  local document = {
    document = raw_document,
    errors = errors,
  }
  setmetatable(document, metatable)
  return document
end

return Document
