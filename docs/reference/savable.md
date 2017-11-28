---
title: xmlua.Savable
---

# `xmlua.Savable` module

## Summary

It provides features that serialize to HTML and XML.

## Methods

### `to_html(options=nil) -> string`

It saves document or element as HTML.

`options`: Here are available options:

  * `encoding`: The output encoding as `string`.

    * Example: `"UTF-8'`

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>World</body>
</html>
]])

-- Serializes as HTML
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html>
--   <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
--     <title>Hello</title>
--   </head>
--   <body>World</body>
-- </html>
```

You can specify output encoding by `encoding` option.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>World</body>
</html>
]])

-- Serializes as EUC-JP encoded HTML
print(document:to_html({encoding = "EUC-JP"}))
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html>
--   <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
--     <title>Hello</title>
--   </head>
--   <body>World</body>
-- </html>
```

You can serialize an element as HTML.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>World</body>
</html>
]])

-- Serializes <body> element as HTML
print(document:search("/html/body")[1]:to_html())
-- <body>World</body>
```

You can serialize a node set as HTML.

```lua
local xmlua = require("xmlua")

local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>World</body>
</html>
]])

-- Serializes elements under <html> (<head> and <body>) as HTML
print(document:search("/html/*"):to_html())
-- <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
--    <title>Hello</title>
--  </head><body>World</body>
```

## See also

  * [`xmlua.HTML`][html]: The class for HTML document.

  * [`xmlua.XML`][xml]: The class for XML document.

  * [`xmlua.Element`][element]: The class for element node.

[html]:html.html

[xml]:xml.html

[element]:element.html
