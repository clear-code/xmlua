local ffi = require("ffi")

ffi.cdef[[
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
]]
