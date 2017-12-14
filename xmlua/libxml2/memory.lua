local ffi = require("ffi")

ffi.cdef[[
typedef void *(*xmlMallocFunc)(size_t size);
typedef void (*xmlFreeFunc)(void *mem);
]]
