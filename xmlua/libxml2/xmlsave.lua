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

typedef struct _xmlCharEncodingHandler xmlCharEncodingHandler;
typedef struct _xmlOutputBuffer xmlOutputBuffer;
typedef xmlOutputBuffer *xmlOutputBufferPtr;

typedef int (* xmlCharEncodingOutputFunc)(unsigned char *out, int *outlen,
                                          const unsigned char *in, int *inlen);

struct _xmlSaveCtxt {
    void *_private;
    int type;
    int fd;
    const xmlChar *filename;
    const xmlChar *encoding;
    xmlCharEncodingHandler *handler;
    xmlOutputBufferPtr buf;
    xmlDocPtr doc;
    int options;
    int level;
    int format;
    char indent[60 + 1];	/* array for indenting output */
    int indent_nr;
    int indent_size;
    xmlCharEncodingOutputFunc escape;	/* used for element content */
    xmlCharEncodingOutputFunc escapeAttr;/* used for attribute content */
};

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
int xmlCharEncCloseFunc(xmlCharEncodingHandler *handler);
]]
