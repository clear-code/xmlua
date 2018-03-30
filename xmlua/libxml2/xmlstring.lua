local ffi = require("ffi")

ffi.cdef[[
typedef unsigned char xmlChar;

xmlChar *xmlStrdup(const xmlChar *cur);
]]
