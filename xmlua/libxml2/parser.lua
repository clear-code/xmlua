local ffi = require("ffi")

ffi.cdef[[
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
    XML_PARSE_RECOVER	= 1<<0,	/* recover on errors */
    XML_PARSE_NOENT	= 1<<1,	/* substitute entities */
    XML_PARSE_DTDLOAD	= 1<<2,	/* load the external subset */
    XML_PARSE_DTDATTR	= 1<<3,	/* default DTD attributes */
    XML_PARSE_DTDVALID	= 1<<4,	/* validate with the DTD */
    XML_PARSE_NOERROR	= 1<<5,	/* suppress error reports */
    XML_PARSE_NOWARNING	= 1<<6,	/* suppress warning reports */
    XML_PARSE_PEDANTIC	= 1<<7,	/* pedantic error reporting */
    XML_PARSE_NOBLANKS	= 1<<8,	/* remove blank nodes */
    XML_PARSE_SAX1	= 1<<9,	/* use the SAX1 interface internally */
    XML_PARSE_XINCLUDE	= 1<<10,/* Implement XInclude substitition  */
    XML_PARSE_NONET	= 1<<11,/* Forbid network access */
    XML_PARSE_NODICT	= 1<<12,/* Do not reuse the context dictionary */
    XML_PARSE_NSCLEAN	= 1<<13,/* remove redundant namespaces declarations */
    XML_PARSE_NOCDATA	= 1<<14,/* merge CDATA as text nodes */
    XML_PARSE_NOXINCNODE= 1<<15,/* do not generate XINCLUDE START/END nodes */
    XML_PARSE_COMPACT   = 1<<16,/* compact small text nodes; no modification of
                                   the tree allowed afterwards (will possibly
				   crash if you try to modify the tree) */
    XML_PARSE_OLD10	= 1<<17,/* parse using XML-1.0 before update 5 */
    XML_PARSE_NOBASEFIX = 1<<18,/* do not fixup XINCLUDE xml:base uris */
    XML_PARSE_HUGE      = 1<<19,/* relax any hardcoded limit from the parser */
    XML_PARSE_OLDSAX    = 1<<20,/* parse using SAX2 interface before 2.7.0 */
    XML_PARSE_IGNORE_ENC= 1<<21,/* ignore internal document encoding hint */
    XML_PARSE_BIG_LINES = 1<<22 /* Store big lines numbers in text PSVI field */
} xmlParserOption;

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

xmlDocPtr xmlParseMemory(const char *buffer, int size);

void xmlFreeParserCtxt	(xmlParserCtxtPtr ctxt);
int xmlCtxtUseOptions	(xmlParserCtxtPtr ctxt, int options);
int xmlParseDocument	(xmlParserCtxtPtr ctxt);
]]
