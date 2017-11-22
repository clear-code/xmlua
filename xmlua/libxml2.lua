local libxml2 = {}

local ffi = require("ffi")
ffi.cdef[[
typedef unsigned char xmlChar;
typedef void *xmlDocPtr;
typedef void *xmlParserInputPtr;
typedef void *xmlNodePtr;
typedef void *xmlDictPtr;
typedef void *xmlHashTablePtr;
typedef void *xmlAttrPtr;

typedef enum {
    XML_ERR_NONE = 0,
    XML_ERR_WARNING = 1,	/* A simple warning */
    XML_ERR_ERROR = 2,		/* A recoverable error */
    XML_ERR_FATAL = 3		/* A fatal error */
} xmlErrorLevel;

typedef struct _xmlError xmlError;
struct _xmlError {
    int		domain;	/* What part of the library raised this error */
    int		code;	/* The error code, e.g. an xmlParserError */
    char       *message;/* human-readable informative error message */
    xmlErrorLevel level;/* how consequent is the error */
    char       *file;	/* the filename */
    int		line;	/* the line number if available */
    char       *str1;	/* extra string information */
    char       *str2;	/* extra string information */
    char       *str3;	/* extra string information */
    int		int1;	/* extra number information */
    int		int2;	/* error column # or 0 if N/A (todo: rename field when we would brk ABI) */
    void       *ctxt;   /* the parser context if available */
    void       *node;   /* the node in the tree */
};

typedef struct _xmlParserNodeInfo xmlParserNodeInfo;
struct _xmlParserNodeInfo {
  const struct _xmlNode* node;
  /* Position & line # that text that created the node begins & ends on */
  unsigned long begin_pos;
  unsigned long begin_line;
  unsigned long end_pos;
  unsigned long end_line;
};

typedef struct _xmlParserNodeInfoSeq xmlParserNodeInfoSeq;
struct _xmlParserNodeInfoSeq {
  unsigned long maximum;
  unsigned long length;
  xmlParserNodeInfo* buffer;
};

typedef void (*xmlValidityErrorFunc) (void *ctx,
                                      const char *msg,
                                      ...);
typedef void (*xmlValidityWarningFunc) (void *ctx,
                                        const char *msg,
                                        ...);

typedef struct _xmlValidState xmlValidState;

typedef struct _xmlValidCtxt xmlValidCtxt;
struct _xmlValidCtxt {
    void *userData;			/* user specific data block */
    xmlValidityErrorFunc error;		/* the callback in case of errors */
    xmlValidityWarningFunc warning;	/* the callback in case of warning */

    /* Node analysis stack used when validating within entities */
    xmlNodePtr         node;          /* Current parsed Node */
    int                nodeNr;        /* Depth of the parsing stack */
    int                nodeMax;       /* Max depth of the parsing stack */
    xmlNodePtr        *nodeTab;       /* array of nodes */

    unsigned int     finishDtd;       /* finished validating the Dtd ? */
    xmlDocPtr              doc;       /* the document */
    int                  valid;       /* temporary validity check result */

    /* state state used for non-determinist content validation */
    xmlValidState     *vstate;        /* current state */
    int                vstateNr;      /* Depth of the validation stack */
    int                vstateMax;     /* Max depth of the validation stack */
    xmlValidState     *vstateTab;     /* array of validation states */

    void                     *am;
    void                  *state;
};

typedef enum {
    XML_PARSER_EOF = -1,	/* nothing is to be parsed */
    XML_PARSER_START = 0,	/* nothing has been parsed */
    XML_PARSER_MISC,		/* Misc* before int subset */
    XML_PARSER_PI,		/* Within a processing instruction */
    XML_PARSER_DTD,		/* within some DTD content */
    XML_PARSER_PROLOG,		/* Misc* after internal subset */
    XML_PARSER_COMMENT,		/* within a comment */
    XML_PARSER_START_TAG,	/* within a start tag */
    XML_PARSER_CONTENT,		/* within the content */
    XML_PARSER_CDATA_SECTION,	/* within a CDATA section */
    XML_PARSER_END_TAG,		/* within a closing tag */
    XML_PARSER_ENTITY_DECL,	/* within an entity declaration */
    XML_PARSER_ENTITY_VALUE,	/* within an entity value in a decl */
    XML_PARSER_ATTRIBUTE_VALUE,	/* within an attribute value */
    XML_PARSER_SYSTEM_LITERAL,	/* within a SYSTEM value */
    XML_PARSER_EPILOG,		/* the Misc* after the last end tag */
    XML_PARSER_IGNORE,		/* within an IGNORED section */
    XML_PARSER_PUBLIC_LITERAL	/* within a PUBLIC value */
} xmlParserInputState;

typedef enum {
    XML_PARSE_UNKNOWN = 0,
    XML_PARSE_DOM = 1,
    XML_PARSE_SAX = 2,
    XML_PARSE_PUSH_DOM = 3,
    XML_PARSE_PUSH_SAX = 4,
    XML_PARSE_READER = 5
} xmlParserMode;

typedef struct _xmlParserCtxt xmlParserCtxt;
struct _xmlParserCtxt {
    struct _xmlSAXHandler *sax;       /* The SAX handler */
    void            *userData;        /* For SAX interface only, used by DOM build */
    xmlDocPtr           myDoc;        /* the document being built */
    int            wellFormed;        /* is the document well formed */
    int       replaceEntities;        /* shall we replace entities ? */
    const xmlChar    *version;        /* the XML version string */
    const xmlChar   *encoding;        /* the declared encoding, if any */
    int            standalone;        /* standalone document */
    int                  html;        /* an HTML(1)/Docbook(2) document
                                       * 3 is HTML after <head>
                                       * 10 is HTML after <body>
                                       */

    /* Input stream stack */
    xmlParserInputPtr  input;         /* Current input stream */
    int                inputNr;       /* Number of current input streams */
    int                inputMax;      /* Max number of input streams */
    xmlParserInputPtr *inputTab;      /* stack of inputs */

    /* Node analysis stack only used for DOM building */
    xmlNodePtr         node;          /* Current parsed Node */
    int                nodeNr;        /* Depth of the parsing stack */
    int                nodeMax;       /* Max depth of the parsing stack */
    xmlNodePtr        *nodeTab;       /* array of nodes */

    int record_info;                  /* Whether node info should be kept */
    xmlParserNodeInfoSeq node_seq;    /* info about each node parsed */

    int errNo;                        /* error code */

    int     hasExternalSubset;        /* reference and external subset */
    int             hasPErefs;        /* the internal subset has PE refs */
    int              external;        /* are we parsing an external entity */

    int                 valid;        /* is the document valid */
    int              validate;        /* shall we try to validate ? */
    xmlValidCtxt        vctxt;        /* The validity context */

    xmlParserInputState instate;      /* current type of input */
    int                 token;        /* next char look-ahead */

    char           *directory;        /* the data directory */

    /* Node name stack */
    const xmlChar     *name;          /* Current parsed Node */
    int                nameNr;        /* Depth of the parsing stack */
    int                nameMax;       /* Max depth of the parsing stack */
    const xmlChar *   *nameTab;       /* array of nodes */

    long               nbChars;       /* number of xmlChar processed */
    long            checkIndex;       /* used by progressive parsing lookup */
    int             keepBlanks;       /* ugly but ... */
    int             disableSAX;       /* SAX callbacks are disabled */
    int               inSubset;       /* Parsing is in int 1/ext 2 subset */
    const xmlChar *    intSubName;    /* name of subset */
    xmlChar *          extSubURI;     /* URI of external subset */
    xmlChar *          extSubSystem;  /* SYSTEM ID of external subset */

    /* xml:space values */
    int *              space;         /* Should the parser preserve spaces */
    int                spaceNr;       /* Depth of the parsing stack */
    int                spaceMax;      /* Max depth of the parsing stack */
    int *              spaceTab;      /* array of space infos */

    int                depth;         /* to prevent entity substitution loops */
    xmlParserInputPtr  entity;        /* used to check entities boundaries */
    int                charset;       /* encoding of the in-memory content
				         actually an xmlCharEncoding */
    int                nodelen;       /* Those two fields are there to */
    int                nodemem;       /* Speed up large node parsing */
    int                pedantic;      /* signal pedantic warnings */
    void              *_private;      /* For user data, libxml won't touch it */

    int                loadsubset;    /* should the external subset be loaded */
    int                linenumbers;   /* set line number in element content */
    void              *catalogs;      /* document's own catalog */
    int                recovery;      /* run in recovery mode */
    int                progressive;   /* is this a progressive parsing */
    xmlDictPtr         dict;          /* dictionary for the parser */
    const xmlChar *   *atts;          /* array for the attributes callbacks */
    int                maxatts;       /* the size of the array */
    int                docdict;       /* use strings from dict to build tree */

    /*
     * pre-interned strings
     */
    const xmlChar *str_xml;
    const xmlChar *str_xmlns;
    const xmlChar *str_xml_ns;

    /*
     * Everything below is used only by the new SAX mode
     */
    int                sax2;          /* operating in the new SAX mode */
    int                nsNr;          /* the number of inherited namespaces */
    int                nsMax;         /* the size of the arrays */
    const xmlChar *   *nsTab;         /* the array of prefix/namespace name */
    int               *attallocs;     /* which attribute were allocated */
    void *            *pushTab;       /* array of data for push */
    xmlHashTablePtr    attsDefault;   /* defaulted attributes if any */
    xmlHashTablePtr    attsSpecial;   /* non-CDATA attributes if any */
    int                nsWellFormed;  /* is the document XML Nanespace okay */
    int                options;       /* Extra options */

    /*
     * Those fields are needed only for treaming parsing so far
     */
    int               dictNames;    /* Use dictionary names for the tree */
    int               freeElemsNr;  /* number of freed element nodes */
    xmlNodePtr        freeElems;    /* List of freed element nodes */
    int               freeAttrsNr;  /* number of freed attributes nodes */
    xmlAttrPtr        freeAttrs;    /* List of freed attributes nodes */

    /*
     * the complete error informations for the last error.
     */
    xmlError          lastError;
    xmlParserMode     parseMode;    /* the parser mode */
    unsigned long    nbentities;    /* number of entities references */
    unsigned long  sizeentities;    /* size of parsed entities */

    /* for use by HTML non-recursive parser */
    xmlParserNodeInfo *nodeInfo;      /* Current NodeInfo */
    int                nodeInfoNr;    /* Depth of the parsing stack */
    int                nodeInfoMax;   /* Max depth of the parsing stack */
    xmlParserNodeInfo *nodeInfoTab;   /* array of nodeInfos */

    int                input_id;      /* we need to label inputs */
    unsigned long      sizeentcopy;   /* volume of entity copy */
};

typedef xmlParserCtxt htmlParserCtxt;

htmlParserCtxt *htmlCreateMemoryParserCtxt(const char *buffer, int size);
void htmlFreeParserCtxt(htmlParserCtxt *context);
int htmlCtxtUseOptions(htmlParserCtxt *context, int options);

int htmlParseDocument(htmlParserCtxt *context);
]]
local xml2 = ffi.load("xml2")

libxml2.XML_ERR_NONE    = 0
libxml2.XML_ERR_WARNING = 1
libxml2.XML_ERR_ERROR   = 2
libxml2.XML_ERR_FATAL   = 3

libxml2.HTML_PARSE_RECOVER    = bit.lshift(1, 0)
libxml2.HTML_PARSE_NODEFDTD   = bit.lshift(1, 2)
libxml2.HTML_PARSE_NOERROR    = bit.lshift(1, 5)
libxml2.HTML_PARSE_NOWARNING  = bit.lshift(1, 6)
libxml2.HTML_PARSE_PEDANTIC   = bit.lshift(1, 7)
libxml2.HTML_PARSE_NOBLANKS   = bit.lshift(1, 8)
libxml2.HTML_PARSE_NONET      = bit.lshift(1, 11)
libxml2.HTML_PARSE_NOIMPLIED  = bit.lshift(1, 13)
libxml2.HTML_PARSE_COMPACT    = bit.lshift(1, 16)
libxml2.HTML_PARSE_IGNORE_ENC = bit.lshift(1, 21)

function libxml2.htmlCreateMemoryParserCtxt(html)
  local context = xml2.htmlCreateMemoryParserCtxt(html, #html)
  if not context then
    return nil
  end
  xml2.htmlCtxtUseOptions(context,
                          bit.bor(libxml2.HTML_PARSE_NOERROR,
                                  libxml2.HTML_PARSE_NOWARNING))
  return ffi.gc(context, xml2.htmlFreeParserCtxt)
end

function libxml2.htmlParseDocument(context)
  local status = xml2.htmlParseDocument(context)
  return status == 0
end

return libxml2
