---
title: xmlua.XMLSAXParser
---

# `xmlua.XMLSAXParser` class

## Summary

It's a class for parsing a XML with SAX(Simple API for XML).

SAX is different from DOM, processing parse documents line by line.
DOM processing parse after read all documents into memory.
So, SAX can parse documents with much less memory and fast.

You can register your callback method which call when occured events below.

Call back event list:
  * StartDocument
  * UnparsedEntityDeclaration
  * NotationDeclaration
  * EntityDeclaration
  * InternalSubset
  * ExternalSubset
  * CdataBlock
  * Comment
  * ProcessingInstruction
  * IgnorableWhitespace
  * Text
  * Reference
  * StartElement
  * EndElement
  * Warning
  * Error
  * EndDocument
