local ffi = require("ffi")

ffi.cdef[[
htmlDocPtr htmlNewDoc(const xmlChar *URI, const xmlChar *ExternalID);
]]
