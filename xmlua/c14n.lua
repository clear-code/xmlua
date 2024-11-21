local C14n = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")



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
local function getNamespacePrefixArray(list)
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



local function getNodesList(nodes)
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



--- Canonicalise an xmlDocument or set of elements.
-- @param self xmlDoc from which to canonicalize elements
-- @param nodes list of nodes to include when canonicalizing, if 'nil' entire doc will be canonicalized
-- @param mode any of C14N_1_0, C14N_EXCLUSIVE_1_0 (default), C14N_1_1
-- @param inclusive_ns_prefixes array, or space-separated string, of namespace prefixes to include
-- @param with_comments if truthy, comments will be included (default: false)
-- @return string containing canonicalized xml
function C14n:c14n(nodes, mode, inclusive_ns_prefixes, with_comments)
  if mode == nil then -- default is exclusive 1.0
    mode = "C14N_EXCLUSIVE_1_0"
  end
  with_comments = with_comments and 1 or 0 -- default = not including comments

  mode = assert(C14N_MODES_LOOKUP[mode], "mode must be a valid C14N mode constant")
  local prefixes = getNamespacePrefixArray(inclusive_ns_prefixes)
  local nodeSet = getNodesList(nodes)
  local buffer = libxml2.xmlBufferCreate()
  local output_buffer = libxml2.xmlOutputBufferCreate(buffer)

  local success = libxml2.xmlC14NDocSaveTo(self.document, nodeSet, mode,
                                            prefixes, with_comments, output_buffer)

  if success < 0 then
    return nil, "failed to generate C14N string"
  end
  return libxml2.xmlBufferGetContent(buffer)
end


return C14n
