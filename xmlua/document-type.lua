local DocumentType = {}

local Node = require("xmlua.node")
local ffi = require("ffi")

local methods = {}
local metatable = {}

function metatable.__index(element, key)
  return methods[key] or
    Node[key]
end

function methods:node_name()
  return "document-type"
end

function methods:name()
  return ffi.string(self.node.name)
end

function methods:external_id()
  return ffi.string(self.node.ExternalID)
end

function methods:system_id()
  return ffi.string(self.node.SystemID)
end

function DocumentType.new(document, node)
  local document_type = {
    document = document,
    node = node,
  }
  setmetatable(document_type, metatable)
  return document_type
end

return DocumentType
