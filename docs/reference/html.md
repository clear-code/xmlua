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

### `xmlua.HTML.build(document_tree={ELEMENT, {ATTRIBUTE1, ATTRIBUTE2, ...}, ...}[, uri][, public_id]) -> xmlua.Document` {#build}

If you give tabel as below, it returns document tree.

```lua
{ -- Support only element and attribute, text.
  "Element name", -- 1st element is element name.
  {        -- 2nd element is attribute. If this element has not attribute, this table is empty.
    ["Attribute name1"] = "Attribute value1",
    ["Attribute name2"] = "Attribute value2",
    ...,
    ["Attribute name n"] = "Attribute value n",
  },
  -- 3rd element is child node
  "Text node1", -- If this element is a string, this element is a text node.
  {                 -- If this element is a table, this element is an element node.
    "Child node name1",
    {
      ["Attribute name1"] = "Attribute value1",
      ["Attribute name2"] = "Attribute value2",
      ...,
      ["Attribute name n"] = "Attribute value n",
    },
  }
  "Text ndoe2",
  ...
}
```

This method makes new `xmlua.Document`.
If you give empty table, it returns empty `xmlua.Document`(This document have not root element).

Example:

```lua
local xmlua = require("xmlua")

local doc_tree = {
  "html",
  {
    ["class"] = "A",
    ["id"] = "1"
  },
  "This is text.",
  {
    "child",
    {
      ["class"] = "B",
      ["id"] = "2"
    }
  }
}
-- Make new document fro table.
local document = xmlua.HTML.build(doc_tree)
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html></html>
```

You can also specify the external subset of DTD with system id or public id as below.

Example:

```lua
-- Specify external subset with system id
local uri = "file:///usr/local/share/test.dtd"
tree = {"html"}
document = xmlua.HTML.build(tree, uri)
print(document:to_html())
-- <!DOCTYPE html SYSTEM "file:///usr/local/share/test.dtd">
-- <html></html>


-- Specify external subset with public id
local uri = "http://www.w3.org/TR/html4/strict.dtd"
local public_id = "-//W3C//DTD HTML 4.01//EN"
tree = {"html"}
document = xmlua.HTML.build(tree, uri, public_id)
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
-- <html></html>
```

If you don't specify the external subset of DTD, DTD use default as below.

Example:

```lua
-- Don't specify the external subset of DTD
tree = {"html"}
document = xmlua.HTML.build(tree)
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html></html>
```

## See also

  * [`xmlua.Document`][document]: The class for HTML document and XML document.


[document]:document.html

[document-errors]:document.html#errors
