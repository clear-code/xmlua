local ffi = require("ffi")

ffi.cdef[[
typedef xmlDocPtr htmlDocPtr;
typedef xmlParserCtxt htmlParserCtxt;
typedef xmlParserCtxtPtr htmlParserCtxtPtr;
typedef xmlSAXHandler htmlSAXHandler;
typedef xmlSAXHandlerPtr htmlSAXHandlerPtr;

typedef enum {
    HTML_PARSE_RECOVER  = 1<<0, /* Relaxed parsing */
    HTML_PARSE_NODEFDTD = 1<<2, /* do not default a doctype if not found */
    HTML_PARSE_NOERROR	= 1<<5,	/* suppress error reports */
    HTML_PARSE_NOWARNING= 1<<6,	/* suppress warning reports */
    HTML_PARSE_PEDANTIC	= 1<<7,	/* pedantic error reporting */
    HTML_PARSE_NOBLANKS	= 1<<8,	/* remove blank nodes */
    HTML_PARSE_NONET	= 1<<11,/* Forbid network access */
    HTML_PARSE_NOIMPLIED= 1<<13,/* Do not add implied html/body... elements */
    HTML_PARSE_COMPACT  = 1<<16,/* compact small text nodes */
    HTML_PARSE_IGNORE_ENC=1<<21 /* ignore internal document encoding hint */
} htmlParserOption;

htmlParserCtxtPtr htmlNewParserCtxt(void);
htmlParserCtxtPtr htmlCreatePushParserCtxt(htmlSAXHandlerPtr sax,
                                           void *user_data,
                                           const char *chunk,
                                           int size,
                                           const char *filename,
			                   xmlCharEncoding enc);
void htmlFreeParserCtxt(htmlParserCtxtPtr context);

htmlDocPtr htmlCtxtReadMemory(xmlParserCtxtPtr ctxt,
                              const char *buffer,
                              int size,
                              const char *URL,
                              const char *encoding,
                              int options);
]]
