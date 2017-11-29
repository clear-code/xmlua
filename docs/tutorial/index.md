---
title: Tutorial
---

# Tutorial

This document describes how to use XMLua step by step. If you don't install XMLua yet, [install][install] XMLua before you read this document.

## Parse a document

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
  -- -> Failed to parse XML: Premature end of data in tag root line 1
end
```

Both parsed HTML and parsed XML are [`xmlua.Document`][document] object in XMLua. You can handle both of them in the same way.

## Search elements

You can use [XPath][xpath] to search elements. You can use [`xmlua.Searchable:search`][searchable-search] method for it.

[`xmlua.Document`][document] can use the method.

The method returns a [`xmlua.NodeSet`][node-set] object. It's a normal array with convenience methods. You can use normal array features such as `#` and `[]`.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Searches all <sub> elements under the <root> element
local all_subs = document:search("/root/sub")

-- You can use "#" for getting the number of matched nodes
print(#all_subs) -- -> 3

-- You can access the N-th node by "[]".
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

[`xmlua.NodeSet`][node-set] object can also use `search` method. It means that you can search against searched result.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub class="A"><subsub1/></sub>
  <sub class="B"><subsub2/></sub>
  <sub class="A"><subsub3/></sub>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Searches all <sub class="A"> elements
local class_a_subs = document:search("//sub[@class='A']")

-- Searches all elements under <sub class="A"> elements
local subsubs_in_class_a = class_a_subs:search("*")

print(#subsubs_in_class_a) -- -> 2

-- It's /root/sub[@class="A"]/subsub1
print(subsubs_in_class_a[1]:to_xml())
-- <subsub1/>

-- It's /root/sub[@class="A"]/subsub3
print(subsubs_in_class_a[2]:to_xml())
-- <subsub3/>
```

The `search` method is [`xmlua.NodeSet:search`][node-set-search]. It's not [`xmlua.Searchable:search`][searchable-search] method.

You can also use [`xmlua.Searchable:search`][searchable-search] method against element.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Searches the <root> element
local roots = document:search("/root")
local root = roots[1]

-- Searches all <sub> elements under the <root> element
local all_subs = root:search("sub")

-- You can use "#" for getting the number of matched nodes
print(#all_subs) -- -> 3

-- You can access the N-th node by "[]".
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

`search` may fail. For example. it fails with invalid XPath. If it fails, it raises an error.

Here is the error structure:

```lua
{
  message = "Error details",
}
```

If you need to assume that XPath may be invalid, you need to handle error with `pcall`.

Example:

```lua
local xmlua = require("xmlua")

local xml = "<root/>"

local document = xmlua.XML.parse(xml)

local invalid_xpath = "..."
local success, node_set = pcall(function()
  return document:search(invalid_xpath)
end)

if success then
  print("Succeeded to search by XPath")
else
  -- If pcall returns not success, the second return value is error
  -- object not node set.
  local err = node_set
  print("Failed to search by XPath: " .. err.message)
  -- -> Failed to search by XPath: Invalid expression
end
```

## Get attribute

...

## Next step

Now, you knew all major XMLua features! If you want to understand each feature, see [reference manual][reference] for each feature.


[install]:../install/

[html-parse]:../reference/html.html#parse

[xml-parse]:../reference/xml.html#parse

[document]:../reference/document.html

[xpath]:https://www.w3.org/TR/xpath/

[searchable-search]:../reference/searchable.html#search

[node-set]:../reference/node-set.html

[node-set-search]:../reference/node-set.html#search

[reference]:../reference/
