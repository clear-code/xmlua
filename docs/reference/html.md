---
title: xmlua.HTML
---

# `xmlua.HTML` class

## Summary

It's a class for parsing a HTML.

The parsed document is returned as [`xmlua.Document`][document] object.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.HTML.parse("<html><body></body></html>")

-- Call xmlua.Document:root method
document:root() -- -> Root element
```

## Class methods

### `xmlua.HTML.parse(html, options=nil) -> xmlua.Document` {#parse}

`html`: HTML string to be parsed.

`options`: Parse options as a `table`.

Here are available options:

  * `url`: The base URL of the HTML. The default is `nil`. It means that no base URL isn't specified.

  * `encoding`: The encoding of the HTML. The default is `nil`. It means that encoding is detected automatically.

  * `prefer_meta_charset`: Whether is `<meta charset="ENCODING">` HTML 5 tag used for detecting encoding. The default is `true` when `encoding` is `nil`, `false` when `encoding` is not `nil`.

It parses the given HTML and returns `xmlua.Document` object.

If HTML parsing is failed, it raises an error only when the error is a critical error. Otherwise, [`xmlua.Document.errors`][document-errors] contain all errors.

Normally, you don't need to specify any options.

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

-- Parses HTML
local success, document = pcall(xmlua.HTML.parse, html)
if not success then
  local message = document
  print("Failed to parse HTML: " .. message)
  os.exit(1)
end

-- Gets the root element
local root = document:root() -- --> <html> element as xmlua.Element

-- Prints the root element name
print(root:name()) -- -> html
```

If you know right encoding, you can specify `encoding` option.

Example:

```lua
local xmlua = require("xmlua")

local html = [[
<html>
  <body><p>Hello</p></body>
</html>
]]

-- Parses HTML with the specified encoding
local document = xmlua.HTML.parse(html, {encoding = "UTF-8"})

-- Prints the <body> element content
print(document:search("//body"):text())
-- Hello
```

You can get error details from [`xmlua.Document.errors`][document-errors].

Example:

```lua
local xmlua = require("xmlua")

-- Invalid HTML. "&" is invalid.
local html = [[
<html>
  <body><p>&</p></body>
</html>
]]

-- Parses HTML loosely
local document = xmlua.HTML.parse(html)

-- "&" is parsed as "&amp;"
print(document:search("//body"):to_html())
-- <body><p>&amp;<p/></body>

for i, err in ipairs(document.errors) do
  print("Error" .. i .. ":")
  print("Line=" .. err.line .. ": " .. err.message)
  -- Line=2: htmlParseEntityRef: no name
end
```

## See also

  * [`xmlua.Document`][document]: The class for HTML document and XML document.


[document]:document.html

[document-errors]:document.html#errors
