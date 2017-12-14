local ffi = require("ffi")

ffi.cdef[[
xmlMallocFunc *__xmlMalloc(void);
xmlMallocFunc xmlMalloc;
xmlFreeFunc *__xmlFree(void);
xmlFreeFunc xmlFree;
]]
