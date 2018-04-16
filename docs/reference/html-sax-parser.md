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

## Class methods

### `xmlua.HTMLSAXParser.new() -> HTMLSAXParser` {#new}

It makes HTMLSAXParser object.

You can make object of `xmlua.HTMLSAXParser` class as below example.

Example:

```lua
local xmlua = require("xmlua")

local parser = xmlua.HTMLSAXParser.new()
```

## Instance methods

### `parse(html) -> boolean` {#parse}

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

### `finish() -> boolean` {#finish}

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

### `start_document`

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

### `end_document`

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

### `processing_instruction`

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

### `cdata_block`

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

### `ignorable_whitespace`

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

### `comment`

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

### `start_element`

It registers user call back function as below.

You can get name and attributes of elements as argument of your call back.

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.start_element = function(local_name, attributes)
  -- You want to execute code
end
```

Registered function is called, when parse element.

Example:

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html id="top" class="top-level">
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
parser.start_element = function(local_name, attributes)
  print("Start element: " .. local_name)
  if #attributes > 0 then
    print("  Attributes:")
    for i, attribute in pairs(attributes) do
      local name
      if attribute.prefix then
        name = attribute.prefix .. ":" .. attribute.local_name
      else
        name = attribute.name
      end
      if attribute.uri then
        name = name .. "{" .. attribute.uri .. "}"
      end
      print("    " .. name .. ": " .. attribute.value)
    end
  end
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
Start element: html
  Attributes:
    id: top
    class: top-level
Start element: body
Start element: p
```

### `end_element`

It registers user call back function as below.

You can get name of elements as argument of your call back.

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.end_element = function(name)
  -- You want to execute code
end
```

Registered function is called, when parse end element.

Example:

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html id="top" class="top-level">
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
parser.end_element = function(name)
  print("End element: " .. name)
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
End element: p
End element: body
End element: html
```

### `text`

It registers user call back function as below.

You can get text of text element as argument of your call back.

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.text = function(text)
  -- You want to execute code
end
```

Registered function is called, when parse text element.

Example:

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html><body><p>Hello</p></body></html>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.text = function(text)
  print("Text: " .. text)
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
Text: Hello
```

### `error`

It registers user call back function as below.

You can get error information of parse HTML with SAX as argument of your call back.

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.error = function(error)
  -- You want to execute code
end
```

Registered function is called, when parse failed.
Error information structure as below.

```
{
  domain
  code
  message
  level
  line
}
```

`domain` has values as specific as below.
[`Error domain list`][error-domain-list]

`code` has values as specific as below.
[`Error code list`][error-code-list]

`level` has values as specific as below.
[`Error level list`][error-level-list]

Example:

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.error = function(error)
  print("Error domain : " .. error.domain)
  print("Error code   : " .. error.code)
  print("Error message: " .. error.message)
  print("Error level  : " .. error.level)
  print("Error line   : " .. error.line)
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
Error domain : 5
Error code   : 68
Error message: htmlParseStartTag: invalid element name

Error level  : 2
Error line   : 1
Failed to parse HTML with SAX
```

[error-domain-list]:error-domain-list.html
[error-code-list]:error-code-list.html
[error-level-list]:error-level-list.html

