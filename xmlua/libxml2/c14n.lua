local ffi = require("ffi")

ffi.cdef[[
  typedef enum {
    XML_C14N_1_0 = 0, /* Original C14N 1.0 spec */
    XML_C14N_EXCLUSIVE_1_0 = 1, /* Exclusive C14N 1.0 spec */
    XML_C14N_1_1 = 2, /*  C14N 1.1 spec */
  } xmlC14NMode;

  typedef unsigned char xmlChar;
  typedef struct _xmlBuffer xmlBuffer;
  typedef xmlBuffer *xmlBufferPtr;

  typedef struct _xmlCharEncodingHandler xmlCharEncodingHandler;
  typedef xmlCharEncodingHandler *xmlCharEncodingHandlerPtr;

  typedef int (*xmlOutputWriteCallback) (void * context, const char * buffer, int len);
  typedef int (*xmlOutputCloseCallback) (void * context);

  struct _xmlOutputBuffer {
     void*                   context;
     xmlOutputWriteCallback  writecallback;
     xmlOutputCloseCallback  closecallback;

     xmlCharEncodingHandlerPtr encoder; /* I18N conversions to UTF-8 */

     xmlBufferPtr buffer;    /* Local buffer encoded in UTF-8 or ISOLatin */
     xmlBufferPtr conv;      /* if encoder != NULL buffer for output */
     int written;            /* total number of byte written */
     int error;
 };

  typedef struct _xmlOutputBuffer xmlOutputBuffer;
  typedef xmlOutputBuffer *xmlOutputBufferPtr;

  xmlOutputBufferPtr xmlAllocOutputBuffer (xmlCharEncodingHandlerPtr encoder);
  xmlOutputBufferPtr xmlOutputBufferCreateBuffer	(xmlBufferPtr buffer, xmlCharEncodingHandlerPtr encoder);
  int xmlOutputBufferClose	(xmlOutputBufferPtr out);

  int xmlC14NDocSaveTo	(xmlDocPtr doc,
          xmlNodeSetPtr nodes,
          int mode, /* a xmlC14NMode */
          xmlChar **inclusive_ns_prefixes,
          int with_comments,
          xmlOutputBufferPtr buf);
]]
