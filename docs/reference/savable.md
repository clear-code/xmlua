---
title: xmlua.Savable
---

# `xmlua.Savable` module

## Summary

It provides features that serialize to HTML and XML.

## Methods

### `to_html(options=nil) -> string` {#to-html}

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

You can serialize an element.

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

You can serialize a node set. All nodes are serialized and serialized strings are concatenated.

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

### `to_xml(options=nil) -> string` {#to-xml}

It saves document or element as XML.

`options`: Here are available options:

  * `encoding`: The output encoding as `string`.

    * Example: `"UTF-8'`

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]])

-- Serializes as XML
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub1>text1</sub1>
--   <sub2>text2</sub2>
--   <sub3>text3</sub3>
-- </root>
```

You can specify output encoding by `encoding` option.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]])

-- Serializes as EUC-JP encoded XML
print(document:to_xml({encoding = "EUC-JP"}))
-- <?xml version="1.0" encoding="EUC-JP"?>
-- <root>
--   <sub1>text1</sub1>
--   <sub2>text2</sub2>
--   <sub3>text3</sub3>
-- </root>
```

You can serialize an element.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]])

-- Serializes <body> element as XML
print(document:search("/root/sub1")[1]:to_xml())
-- <sub1>text1</sub1>
```

You can serialize a node set. All nodes are serialized and serialized strings are concatenated.

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]])

-- Serializes elements under <root> (<sub1>, <sub2> and <sub3>) as XML
print(document:search("/root/*"):to_xml())
-- <sub1>text1</sub1><sub2>text2</sub2><sub3>text3</sub3>
```

## See also

  * [`xmlua.HTML`][html]: The class for HTML document.

  * [`xmlua.XML`][xml]: The class for XML document.

  * [`xmlua.Element`][element]: The class for element node.

  * [`xmlua.NodeSet`][node-set]: The class for multiple nodes.

[html]:html.html

[xml]:xml.html

[element]:element.html

[node-set]:node-set.html
