local ffi = require("ffi")

ffi.cdef[[
typedef xmlParserCtxt htmlParserCtxt;

htmlParserCtxt *htmlCreateMemoryParserCtxt(const char *buffer, int size);
void htmlFreeParserCtxt(htmlParserCtxt *context);
int htmlCtxtUseOptions(htmlParserCtxt *context, int options);

int htmlParseDocument(htmlParserCtxt *context);
]]

