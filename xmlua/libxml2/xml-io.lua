local ffi = require("ffi")

ffi.cdef[[

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

]]
