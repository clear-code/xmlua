local Document = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")
local converter = require("xmlua.converter")

local Serializable = require("xmlua.serializable")
local Searchable = require("xmlua.searchable")


local CDATASection
local Comment
local DocumentFragment
local DocumentType
local Element
local EntityReference
local Namespace
local ProcessingInstruction

function Document.lazy_load()
  CDATASection = require("xmlua.cdata-section")
  Comment = require("xmlua.comment")
  DocumentFragment = require("xmlua.document-fragment")
  DocumentType = require("xmlua.document-type")
  Element = require("xmlua.element")
  EntityReference = require("xmlua.entity-reference")
  Namespace = require("xmlua.namespace")
  ProcessingInstruction = require("xmlua.processing-instruction")
end

local function print_dbg(...)
  -- if ngx then
  --   ngx.log(ngx.DEBUG, ...)
  -- else
  --   print(...)
  -- end
end

local methods = {}

local metatable = {}

function metatable.__index(document, key)
  return methods[key] or
    Serializable[key] or
    Searchable[key]
end

function methods:root()
  local node = libxml2.xmlDocGetRootElement(self.raw_document)
  if not node then
    return nil
  end
  return Element.new(self, node)
end

function methods:parent()
  return nil
end

function methods:encoding()
  return ffi.string(self.raw_document.encoding)
end

function methods:create_cdata_section(data)
  local raw_cdata_section_node =
    libxml2.xmlNewCDataBlock(self.raw_document,
                             data,
                             data:len())
  return CDATASection.new(self, raw_cdata_section_node)
end

function methods:create_comment(data)
  local raw_comment_node =
    libxml2.xmlNewComment(data)
  return Comment.new(self, raw_comment_node)
end

function methods:create_document_fragment()
  local raw_document_fragment_node =
    libxml2.xmlNewDocFragment(self.raw_document)
  return DocumentFragment.new(self,
                              raw_document_fragment_node)
end

function methods:create_document_type(name, external_id, system_id)
  local raw_document_type =
    libxml2.xmlCreateIntSubset(self.raw_document, name, external_id, system_id)
  return DocumentType.new(self,
                          raw_document_type)
end

function methods:get_internal_subset()
  local raw_document_type =
    libxml2.xmlGetIntSubset(self.raw_document)
  if raw_document_type ~= nil then
    return DocumentType.new(self,
                            raw_document_type)
  else
    return nil
  end
end

function methods:add_entity_reference(name)
  local raw_entity_reference =
    libxml2.xmlNewReference(self.raw_document, name)
  return EntityReference.new(self,
                             raw_entity_reference)
end

function methods:create_namespace(href, prefix)
  local raw_namespace =
    libxml2.xmlNewNs(self.node, href, prefix)
  return Namespace.new(self, raw_namespace)
end

function methods:create_processing_instruction(name, content)
  local raw_processing_instruction =
    libxml2.xmlNewPI(name, content)
  return ProcessingInstruction.new(self,
                             raw_processing_instruction)
end

function methods:add_entity(entity_info)
  local entity_type_name = entity_info["entity_type"]
  local entity_type = converter.convert_entity_type_name(entity_type_name)
  local raw_entity = libxml2.xmlAddDocEntity(self.raw_document,
                                             entity_info["name"],
                                             entity_type,
                                             entity_info["external_id"],
                                             entity_info["system_id"],
                                             entity_info["content"])
  return converter.convert_xml_entity(raw_entity)
end

function methods:get_entity(name)
  local raw_entity = libxml2.xmlGetDocEntity(self.raw_document, name)
  return converter.convert_xml_entity(raw_entity)
end

function methods:add_dtd_entity(entity_info)
  local entity_type_name = entity_info["entity_type"]
  local entity_type = converter.convert_entity_type_name(entity_type_name)
  local raw_dtd_entity =  libxml2.xmlAddDtdEntity(self.raw_document,
                                              entity_info["name"],
                                              entity_type,
                                              entity_info["external_id"],
                                              entity_info["system_id"],
                                              entity_info["content"])
  return converter.convert_xml_entity(raw_dtd_entity)
end

function methods:get_dtd_entity(name)
  local raw_dtd_entity = libxml2.xmlGetDtdEntity(self.raw_document, name)
  return converter.convert_xml_entity(raw_dtd_entity)
end

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
    --root:unlink()
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
  local unlinked = {}
  local document = {
    raw_document = raw_document,
    errors = errors,
    unlinked = unlinked
  }
  ffi.gc(document.raw_document, function(pdocument)
    for node in pairs(unlinked) do
      if node.parent == ffi.NULL then
        print_dbg("Free unlinked: ", node)
        libxml2.xmlFreeNode(node)
      end
    end
    print_dbg("xmlFreeDoc: ", pdocument)
    libxml2.xmlFreeDoc(pdocument)
  end)
  setmetatable(document, metatable)
  return document
end

return Document
