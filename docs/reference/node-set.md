---
title: xmlua.NodeSet
---

# `xmlua.NodeSet` class

## Summary

It's a class to manage multiple nodes. Normally, it's used as return object for [`xmlua.Searchable:search`][searchable-search].

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root><sub/></root>")

document:search("/root") -- -> xmlua.NodeSet
```

For now, it contains only element node ([`xmlua.Element`][element]). We will support other node such as text node in the future.

## Instance methods

It's based on normal table. It means that you can use normal table features such as `#node_set` (getting the number of nodes in the node set) and `node_set[1]` (getting the 1st node in the node set).

### `to_html(options=nil) -> string` {#to-html}

It serializes all nodes in the node set as HTML by [`xmlua.Serializable:to_html`][serializable-to-html] and concatenates serialized strings.

`options`: Here are available options:

  * `encoding`: The output encoding as `string`.

    * Example: `"UTF-8'`

If serialization is failed, it raises an error.

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

-- All elements under <html> (<head> and <body>)
local node_set = document:search("/html/*")

-- Serializes all elements as HTML and concatenates serialized HTML
print(node_set:to_html())
-- <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
--    <title>Hello</title>
--  </head><body>World</body>

-- FYI: <head> serialization
print(node_set[1]:to_html())
-- <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
--    <title>Hello</title>
--  </head>

-- FYI: <body> serialization
print(node_set[2]:to_html())
-- <body>World</body>
```

### `to_xml(options=nil) -> string` {#to-xml}

It serializes all nodes in the node set as XML by [`xmlua.Serializable:to_xml`][serializable-to-xml] and concatenates serialized strings.

`options`: Here are available options:

  * `encoding`: The output encoding as `string`.

    * Example: `"UTF-8'`

If serialization is failed, it raises an error.

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

-- All elements under <root> (<sub1>, <sub2> and <sub3>)
local node_set = document:search("/root/*")

-- Serializes all elements as XML and concatenates serialized XML
print(node_set:to_xml())
-- <sub1>text1</sub1><sub2>text2</sub2><sub3>text3</sub3>

-- FYI: <sub1> serialization
print(node_set[1]:to_xml())
-- <sub1>text1</sub1>

-- FYI: <sub2> serialization
print(node_set[2]:to_xml())
-- <sub2>text2</sub2>

-- FYI: <sub3> serialization
print(node_set[3]:to_xml())
-- <sub3>text3</sub3>
```

### `search(xpath) -> xmlua.NodeSet` {#search}

It searches nodes by XPath and returns as [`xmlua.NodeSet`][node-set] object.

It calls [`xmlua.Searchable:search`][searchable-search] against each node in the node set, collects matched nodes into one `xmlua.NodeSet` and returns the `xmlua.NodeSet`.

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

### `content() -> string` {#content}

It gets contents of all nodes in the node set and concatenates them.

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

-- All elements under <root> (<sub1>, <sub2> and <sub3>)
local node_set = document:search("/root/*")

-- Gets all contents and concatenates them
print(node_set:content())
-- text1text2text3
```

### `text() -> string` {#text}

It's an alias of [`content`](#content).

### `paths() -> {path1, path2, ...}` {#paths}

It returns XPath of all nodes in the node set.

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

-- All elements under <root> (<sub1>, <sub2> and <sub3>)
local node_set = document:search("/root/*")
-- Returns XPath of all elements under <root> (<sub1>, <sub2> and <sub3>)
for _, path in ipairs(node_set:paths()) do
  print(path)
  --/root/sub1
  --/root/sub2
  --/root/sub3
end
```

### `insert([position,] node) -> void` {#insert}

It inserts `Node` to [`xmlua.NodeSet`][node-set]. However,it does not insert to document tree.
If you insert the same node, it's ignored.
You can insert not only [`xmlua.Element`][element] but also anything for `Node`.

If you want to specify insert position, you specify the position in the first argument of this method.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<xml>
  <header>
    <title>This is test</title>
  </header>
  <contents>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </contents>
</xml>
]])

--Insert node
local inserted_node_set = document:search("//title")
-- <title>This is test</title>
local insert_node = document:search("//xml/contents/sub1")[1]
-- <sub1>sub1</sub1>
inserted_node_set:insert(insert_node)

print(inserted_node_set:to_xml())
-- <title>This is test</title><sub1>sub1</sub1>

-- Insert node with position
local inserted_node_set = document:search("//xml/contents/*")
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>
local insert_node = document:search("//title")[1]
-- <title>This is test</title>
inserted_node_set:insert(1, insert_node)

print(inserted_node_set:to_xml())
-- <title>This is test</title>
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>
```

### `remove(node_or_position) -> xmlua.Node` {#remove}

It remove `Node` in [`xmlua.NodeSet`][node-set]. However,it does not remove from document tree.
It returns removed node. If it fail remove, it returns nil.

If you want to specify remove position, you specify the position in the first argument of this method.
If you want to specify the node to be removed, you specify the `Node` in the first argument of this method.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<xml>
  <header>
    <title>This is test</title>
  </header>
  <contents>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </contents>
</xml>
]])

-- Remove node
local removed_node_set = document:search("//xml/contents/*")
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>
local remove_node = removed_node_set:remove(removed_node_set[1])
print(remove_node:to_xml())
-- <sub1>sub1</sub1>
print(removed_node_set:to_xml())
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>

-- Remove node with position
local removed_node_set = document:search("//xml/contents/*")
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>
local remove_node = removed_node_set:remove(1)
print(remove_node:to_xml())
-- <sub1>sub1</sub1>
print(removed_node_set:to_xml())
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>
```

### `merge(node_set) -> xmlua.NodeSet` {#merge}

It returns new "node set" which merged receiver's node and argument's node.
You can write not only `node_set1:merge(node_set2) but also `node_set1 + node_set2`.
Remove duplicate node.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<xml>
  <header>
    <title>This is test</title>
  </header>
  <contents>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </contents>
</xml>
]])
-- Merge nodes
local node_set1 = document:search("//title")
-- <title>This is test</title>
local node_set2 = document:search("//xml/contents/*")
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>
local merged_node_set = node_set1:merge(node_set2)
print(merged_node_set:to_xml())
-- <title>This is test</title>
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>

-- Merge nodes another way write.
local merged_node_set = node_set1 + node_set2
print(merged_node_set:to_xml())
-- <title>This is test</title>
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>
```

### `unlink() -> void` {#unlink}

It remove all node in node set from document tree.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<xml>
  <header>
    <title>This is test</title>
  </header>
  <contents>
    <sub1>sub1</sub1>
    <sub2>sub2</sub2>
    <sub3>sub3</sub3>
  </contents>
</xml>
]])

-- remove all nodes in node set
local node_set = document:search("//xml/contents/*")
-- <sub1>sub1</sub1>
-- <sub2>sub2</sub2>
-- <sub3>sub3</sub3>
node_set:unlink()
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<xml>
--  <header>
--    <title>This is test</title>
--  </header>
--  <contents>
--
--
--
--  </contents>
--</xml>
```

## See also

  * [`xmlua.Element`][element]: The class for element node.

  * [`xmlua.Serializable`][serializable]: Provides HTML and XML serialization related methods.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.


[searchable-search]:searchable.html#search

[element]:element.html

[serializable-to-html]:serializable.html#to-html

[serializable-to-xml]:serializable.html#to-xml

[node-set]:node-set.html

[serializable]:serializable.html

[searchable]:searchable.html
