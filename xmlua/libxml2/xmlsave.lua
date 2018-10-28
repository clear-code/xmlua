local ffi = require("ffi")

ffi.cdef[[
typedef enum {
    XML_SAVE_FORMAT     = 1<<0,	/* format save output */
    XML_SAVE_NO_DECL    = 1<<1,	/* drop the xml declaration */
    XML_SAVE_NO_EMPTY	= 1<<2, /* no empty tags */
    XML_SAVE_NO_XHTML	= 1<<3, /* disable XHTML1 specific rules */
    XML_SAVE_XHTML	= 1<<4, /* force XHTML1 specific rules */
    XML_SAVE_AS_XML     = 1<<5, /* force XML serialization on HTML doc */
    XML_SAVE_AS_HTML    = 1<<6, /* force HTML serialization on XML doc */
    XML_SAVE_WSNONSIG   = 1<<7  /* format with non-significant whitespace */
} xmlSaveOption;

typedef struct _xmlSaveCtxt xmlSaveCtxt;
typedef xmlSaveCtxt *xmlSaveCtxtPtr;

xmlSaveCtxtPtr xmlSaveToBuffer(xmlBuffer *buffer,
                               const char *encoding,
                               int options);
long xmlSaveDoc(xmlSaveCtxtPtr ctxt, xmlDocPtr doc);
long xmlSaveTree(xmlSaveCtxtPtr ctxt, xmlNodePtr node);
int xmlSaveClose(xmlSaveCtxtPtr ctxt);
int xmlSaveSetEscape(xmlSaveCtxtPtr ctxt,
                     xmlCharEncodingOutputFunc escape);
]]
