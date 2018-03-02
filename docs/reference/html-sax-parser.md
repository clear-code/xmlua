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

### `xmlua.HTMLSAXParser.processing_instruction`

It registers user call back function as below.

You can get attributes of processing instruction as argument of your call back. Attributes of processing instruction are `target` and `data_list` in below exsample.

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.processing_instruction = function(target, data_list)
  -- You want to execute code
end
```

Registered function is called, when parse processing instruction element.

Registered function is called, when parse `<?target This is PI>` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html>
  <?target This is PI>
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
parser.processing_instruction = function(target, data_list)
  print("Processing instruction target: "..target)
  print("Processing instruction data: "..data_list)
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
Processing instruction target: target
Processing instruction data: This is PI
```

### `xmlua.HTMLSAXParser.cdata_block`

It registers user call back function as below.

You can get attributes of script element as argument of your call back. Attributes of script element is `cdata_block`.

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.cdata_block = function(cdata_block)
  -- You want to execute code
end
```

Registered function is called, when parse script element.

Registered function is called, when parse `<script>alert(\"Hello world!\")</script>` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html>
  <body>
    <p>Hello</p>
  </body>
  <script>alert(\"Hello world!\")</script>
</html>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.cdata_block = function(cdata_block)
  print("CDATA block: "..cdata_block)
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
CDATA block: alert(\"Hello world!\")
```

### `xmlua.HTMLSAXParser.ignorable_whitespace`

It registers user call back function as below.

You can get ignorable whitespace in HTML as argument of your call back. ignorable whitespace in HTML is `ignorable_whitespace` in below example.

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.ignorable_whitespace = function(ignorable_whitespace)
  -- You want to execute code
end
```

Registered function is called, when parse ignorable whitespace

Example:

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html> <body><p>Hello</p></body> </html>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.ignorable_whitespace = function(ignorable_whitespace)
  print("Ignorable whitespace: ".."\""..ignorable_whitespace.."\"")
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
Ignorable whitespace: " "
Ignorable whitespace: " "
Ignorable whitespace: "
"
```

### `xmlua.HTMLSAXParser.comment`

It registers user call back function as below.

You can get comment of HTML as argument of your call back. comment in HTML is `comment` in below example.

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.comment = function(comment)
  -- You want to execute code
end
```

Registered function is called, when parse HTML's comment.

Example:

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html>
<!--This is comment.-->
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
parser.comment = function(comment)
  print("Comment: "..comment)
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
Comment:  This is comment.
```
