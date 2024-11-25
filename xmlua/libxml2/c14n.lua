local ffi = require("ffi")

ffi.cdef[[
/*
 * xmlC14NMode:
 *
 * Predefined values for C14N modes
 *
 */
 typedef enum {
  XML_C14N_1_0            = 0,    /* Original C14N 1.0 spec */
  XML_C14N_EXCLUSIVE_1_0  = 1,    /* Exclusive C14N 1.0 spec */
  XML_C14N_1_1            = 2     /* C14N 1.1 spec */
} xmlC14NMode;

int
  xmlC14NDocSaveTo	(xmlDocPtr doc,
         xmlNodeSetPtr nodes,
         int mode, /* a xmlC14NMode */
         xmlChar **inclusive_ns_prefixes,
         int with_comments,
         xmlOutputBufferPtr buf);
]]
