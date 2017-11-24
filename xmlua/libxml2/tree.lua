local ffi = require("ffi")

ffi.cdef[[
typedef void *xmlParserInputPtr;
typedef void *xmlDocPtr;
typedef void *xmlNodePtr;
typedef void *xmlAttrPtr;
]]
