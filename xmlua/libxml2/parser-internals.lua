local ffi = require("ffi")

ffi.cdef[[
xmlParserCtxtPtr xmlCreateMemoryParserCtxt(const char *buffer, int size);
]]
