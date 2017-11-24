local ffi = require("ffi")

ffi.cdef[[
typedef struct _xmlSaveCtxt xmlSaveCtxt;
typedef xmlSaveCtxt *xmlSaveCtxtPtr;

xmlSaveCtxtPtr xmlSaveToBuffer(xmlBuffer *buffer,
                               const char *encoding,
                               int options);
long xmlSaveDoc(xmlSaveCtxtPtr ctxt, xmlDocPtr doc);
int xmlSaveClose(xmlSaveCtxtPtr ctxt);
]]
