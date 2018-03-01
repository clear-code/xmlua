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

## Instance methods
### `xmlua.HTMLSAXParser.parse(html) -> boolean` {#parse}

`html`: HTML string to be parsed.

It parses the given HTML.
If HTML parsing is succeed, this method returns true. If HTML parsing is failed, this method returns false.

Example:

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html>
  <body>
    <p>Hello</p>
  </body>
</html>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local success = pcall(xmlua.HTMLSAXParser.parse, html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end
```
