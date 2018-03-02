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

## Instance methods

### `xmlua.HTMLSAXParser.new() -> HTMLSAXParser` {#new}

It makes HTMLSAXParser object.

You can make object of `xmllua.HTMLSAXParser` class as below example.

Example:

```lua
local xmlua = require("xmlua")

local parser = xmlua.HTMLSAXParser.new()
```

## Methods

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
local parser = xmlua.HTMLSAXParser.new()
local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end
```

### `xmlua.HTMLSAXParser.finish() -> boolean` {#finish}

It finishes parse HTML with SAX.

If you started parse with `xmlua.HTMLSAXParser.parse`, you should call this method.

If you don't call this method, `EndDocument` event isn't occure.

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
local parser = xmlua.HTMLSAXParser.new()
local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end

parser:finish()
```

## Property

### `xmlua.HTMLSAXParser.start_document`

It registers user call back function as below.

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.start_document = function()
  -- You want to execute code
end
```

Registered function is called, when parse start document element.

Registered function is called, when parse `<html>` in below example.

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
local parser = xmlua.HTMLSAXParser.new()
parser.start_document = function()
  print("Start document")
end
local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Start document
```

### `xmlua.HTMLSAXParser.end_document`

It registers user call back function as below.

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.end_document = function()
  -- You want to execute code
end
```

Registered function is called, when call `xmlua.HTMLSAXParser.parser.finish`.

Registered function is called, when parse `parser:finish()` in below example.

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
local parser = xmlua.HTMLSAXParser.new()
parser.end_document = function()
  print("End document")
end
local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
End document
```
