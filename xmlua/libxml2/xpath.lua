local ffi = require("ffi")

ffi.cdef[[
typedef struct _xmlXPathContext xmlXPathContext;
typedef xmlXPathContext *xmlXPathContextPtr;
xmlXPathContextPtr xmlXPathNewContext(xmlDocPtr doc);
]]
