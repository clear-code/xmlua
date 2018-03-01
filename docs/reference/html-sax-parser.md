---
title: xmlua.HTMLSAXParser
---

# `xmlua.HTMLSAXParser` class

## Summary

It's a class for parsing a HTML with SAX(Simple API for XML).

SAX is different from DOM, processing parse documents line by line.
DOM processing parse after read all documents into memory.
So, SAX can parse documents with much less memory and fast.

You can register your callback method which call when occured events below.

Call back event list:
  * StartDocument
  * ProcessingInstruction
  * CdataBlock
  * IgnorableWhitespace
  * Comment
  * StartElement
  * EndElement
  * Text
  * EndDocument
  * Error

You can make object of `xmllua.HTMLSAXParser` class as below example.

Example:

```lua
local xmlua = require("xmlua")

local parser = xmlua.HTMLSAXParser.new()
```
