local ffi = require("ffi")

ffi.cdef[[

/**
 * xmlOutputWriteCallback:
 * @context:  an Output context
 * @buffer:  the buffer of data to write
 * @len:  the length of the buffer in bytes
 *
 * Callback used in the I/O Output API to write to the resource
 *
 * Returns the number of bytes written or -1 in case of error
 */
 typedef int (*xmlOutputWriteCallback) (void * context, const char * buffer,
                                        int len);
/**
 * xmlOutputCloseCallback:
 * @context:  an Output context
 *
 * Callback used in the I/O Output API to close the resource
 *
 * Returns 0 or -1 in case of error
 */
typedef int (*xmlOutputCloseCallback) (void * context);

struct _xmlOutputBuffer {
  void*                   context;
  xmlOutputWriteCallback  writecallback;
  xmlOutputCloseCallback  closecallback;

  xmlCharEncodingHandlerPtr encoder; /* I18N conversions to UTF-8 */

  xmlBufPtr buffer;    /* Local buffer encoded in UTF-8 or ISOLatin */
  xmlBufPtr conv;      /* if encoder != NULL buffer for output */
  int written;            /* total number of byte written */
  int error;
};

xmlOutputBufferPtr
	xmlAllocOutputBuffer		(xmlCharEncodingHandlerPtr encoder);

xmlOutputBufferPtr
	xmlOutputBufferCreateBuffer	(xmlBufferPtr buffer,
					 xmlCharEncodingHandlerPtr encoder);

int
	xmlOutputBufferClose		(xmlOutputBufferPtr out);

]]
