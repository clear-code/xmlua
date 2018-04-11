local ffi = require("ffi")

ffi.cdef[[
/*
 * The different valid entity types.
 */
typedef enum {
    XML_INTERNAL_GENERAL_ENTITY = 1,
    XML_EXTERNAL_GENERAL_PARSED_ENTITY = 2,
    XML_EXTERNAL_GENERAL_UNPARSED_ENTITY = 3,
    XML_INTERNAL_PARAMETER_ENTITY = 4,
    XML_EXTERNAL_PARAMETER_ENTITY = 5,
    XML_INTERNAL_PREDEFINED_ENTITY = 6
} xmlEntityType;

struct _xmlEntity {
    void           *_private;	        /* application data */
    xmlElementType          type;       /* XML_ENTITY_DECL, must be second ! */
    const xmlChar          *name;	/* Entity name */
    struct _xmlNode    *children;	/* First child link */
    struct _xmlNode        *last;	/* Last child link */
    struct _xmlDtd       *parent;	/* -> DTD */
    struct _xmlNode        *next;	/* next sibling link  */
    struct _xmlNode        *prev;	/* previous sibling link  */
    struct _xmlDoc          *doc;       /* the containing document */

    xmlChar                *orig;	/* content without ref substitution */
    xmlChar             *content;	/* content or ndata if unparsed */
    int                   length;	/* the content length */
    xmlEntityType          etype;	/* The entity type */
    const xmlChar    *ExternalID;	/* External identifier for PUBLIC */
    const xmlChar      *SystemID;	/* URI for a SYSTEM or PUBLIC Entity */

    struct _xmlEntity     *nexte;	/* unused */
    const xmlChar           *URI;	/* the full URI as computed */
    int                    owner;	/* does the entity own the childrens */
    int			 checked;	/* was the entity content checked */
					/* this is also used to count entities
					 * references done from that entity
					 * and if it contains '<' */
};


xmlEntityPtr xmlAddDocEntity(xmlDocPtr doc,
			     const xmlChar *name,
			     int type,
			     const xmlChar *ExternalID,
			     const xmlChar *SystemID,
			     const xmlChar *content);
xmlEntityPtr xmlAddDtdEntity(xmlDocPtr doc,
			     const xmlChar *name,
			     int type,
			     const xmlChar *ExternalID,
			     const xmlChar *SystemID,
			     const xmlChar *content);
xmlEntityPtr xmlGetDocEntity(const xmlDoc *doc,
			     const xmlChar *name);
xmlEntityPtr xmlGetDtdEntity(xmlDocPtr doc,
			     const xmlChar *name);
]]
