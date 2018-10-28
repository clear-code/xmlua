local ffi = require("ffi")

ffi.cdef[[
typedef enum {
    XML_CHAR_ENCODING_ERROR=   -1, /* No char encoding detected */
    XML_CHAR_ENCODING_NONE=	0, /* No char encoding detected */
    XML_CHAR_ENCODING_UTF8=	1, /* UTF-8 */
    XML_CHAR_ENCODING_UTF16LE=	2, /* UTF-16 little endian */
    XML_CHAR_ENCODING_UTF16BE=	3, /* UTF-16 big endian */
    XML_CHAR_ENCODING_UCS4LE=	4, /* UCS-4 little endian */
    XML_CHAR_ENCODING_UCS4BE=	5, /* UCS-4 big endian */
    XML_CHAR_ENCODING_EBCDIC=	6, /* EBCDIC uh! */
    XML_CHAR_ENCODING_UCS4_2143=7, /* UCS-4 unusual ordering */
    XML_CHAR_ENCODING_UCS4_3412=8, /* UCS-4 unusual ordering */
    XML_CHAR_ENCODING_UCS2=	9, /* UCS-2 */
    XML_CHAR_ENCODING_8859_1=	10,/* ISO-8859-1 ISO Latin 1 */
    XML_CHAR_ENCODING_8859_2=	11,/* ISO-8859-2 ISO Latin 2 */
    XML_CHAR_ENCODING_8859_3=	12,/* ISO-8859-3 */
    XML_CHAR_ENCODING_8859_4=	13,/* ISO-8859-4 */
    XML_CHAR_ENCODING_8859_5=	14,/* ISO-8859-5 */
    XML_CHAR_ENCODING_8859_6=	15,/* ISO-8859-6 */
    XML_CHAR_ENCODING_8859_7=	16,/* ISO-8859-7 */
    XML_CHAR_ENCODING_8859_8=	17,/* ISO-8859-8 */
    XML_CHAR_ENCODING_8859_9=	18,/* ISO-8859-9 */
    XML_CHAR_ENCODING_2022_JP=  19,/* ISO-2022-JP */
    XML_CHAR_ENCODING_SHIFT_JIS=20,/* Shift_JIS */
    XML_CHAR_ENCODING_EUC_JP=   21,/* EUC-JP */
    XML_CHAR_ENCODING_ASCII=    22 /* pure ASCII */
} xmlCharEncoding;

typedef int (* xmlCharEncodingOutputFunc)(unsigned char *out, int *outlen,
                                          const unsigned char *in, int *inlen);
]]
