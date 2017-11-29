---
title: Tutorial
---

# Tutorial

This document describes how to use XMLua step by step. If you don't install XMLua yet, [install][install] XMLua before you read this document.

## Parsing a document

You need to parse document at first to use XMLua. XMLua supports HTML document and XML document.

You can use [`xmlua.HTML.parse`][html-parse] to parse HTML.

Example:

```lua
-- Requires "xmlua" module
local xmlua = require("xmlua")

local html = [[
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>
    <p>World</p>
  </body>
</html>
]]

-- Parses HTML
local document = xmlua.HTML.parse(html)

-- Serializes to HTML
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html>
--   <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
--     <title>Hello</title>
--   </head>
--   <body>
--     <p>World</p>
--   </body>
-- </html>
```

You can use [`xmlua.XML.parse`][xml-parse] to parse XML.

Example:

```lua
-- Requires "xmlua" module
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]]

-- Parses XML
local document = xmlua.XML.parse(xml)

-- Serializes to XML
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub>text1</sub>
--   <sub>text2</sub>
--   <sub>text3</sub>
-- </root>
```

You must pass HTML or XML as `string`. If you want to parse HTML or XML in a file, you need to read it by yourself.

Example:

```lua
local xmlua = require("xmlua")

local xml_file = io.open("example.xml")
local xml = xml_file:read("*all")
xml_file:close()

local document = xmlua.XML.parse(xml)
```

`xmlua.HTML.parse` and `xmlua.XML.parse` may fail. For example, they fail with invalid document. If they fail, they raises an error.

Here is the error structure:

```lua
{
  message = "Error details",
}
```

If you need to assume that document may be invalid, you need to handle error with `pcall`.

Example:

```lua
local xmlua = require("xmlua")

local invalid_xml = "<root>"

-- Parses invalid XML
local success, document = pcall(xmlua.XML.parse, invalid_xml)

if success then
  print("Succeeded to parse XML")
else
  -- If pcall returns not success, the second return value is error
  -- object not document.
  local err = document
  print("Failed to parse XML: " .. err.message)
  -- Failed to parse XML: Premature end of data in tag root line 1
end
```

## Find elements

...

## Next step

Now, you knew all major XMLua features! If you want to understand each feature, see [reference manual][reference] for each feature.


[install]:../install/

[html-parse]:../reference/html.html#parse

[xml-parse]:../reference/xml.html#parse

[reference]:../reference/
