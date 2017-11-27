local ffi = require("ffi")

ffi.cdef[[
typedef void (*xmlFreeFunc)(void *mem);
]]
