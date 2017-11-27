local ffi = require("ffi")

ffi.cdef[[
xmlFreeFunc *__xmlFree(void);
xmlFreeFunc xmlFree;
]]
