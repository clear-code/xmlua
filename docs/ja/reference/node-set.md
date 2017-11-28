---
title: xmlua.NodeSet
---

# `xmlua.NodeSet`クラス

## 概要

複数ノードを管理するクラスです。通常、[`xmlua.Searchable:search`][searchable-search]で返却されるオブジェクトを使います。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root><sub/></root>")

document:search("/root") -- -> xmlua.NodeSet
```

今の所、要素ノード([`xmlua.Element`][element])のみを扱います。将来的にはテキストノードのように他のノードもサポートする予定です。

## インスタンスメソッド

It's based on normal table. It means that you can use normal table features such as `#node_set` (getting the number of nodes in the node set) and `node_set[1]` (getting the 1st node in the node set).

### `to_html(options=nil) -> string` {#to-html}

It serializes all nodes in the node set as HTML by [`xmlua.Serializable:to_html`][serializable-to-html] and concatenates serialized strings.

`options`: 利用可能なオプションは以下の通りです。

  * `encoding`: 出力のエンコーディングを`string`で指定します。

    * 例: `"UTF-8'`

シリアライズに失敗した場合は、エラーが発生します。

発生するエラーは以下の構造になっています。

```lua
{
  message = "エラーの詳細",
}
```

例：

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

`options`: 利用可能なオプションは以下の通りです。

  * `encoding`: 出力のエンコーディングを`string`で指定します。

    * 例: `"UTF-8'`

シリアライズに失敗した場合は、エラーが発生します。

発生するエラーは以下の構造になっています。

```lua
{
  message = "エラーの詳細",
}
```

例：

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

XPathを使ってノードを検索し[`xmlua.NodeSet`][node-set]オブジェクトを返します。

It calls [`xmlua.Searchable:search`][searchable-search] against each node in the node set, collects matched nodes into one `xmlua.NodeSet` and returns the `xmlua.NodeSet`.

例：

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

## 参照

  * [`xmlua.Element`][element]: 要素ノード用のクラスです。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[searchable-search]:searchable.html#search

[element]:element.html

[serializable-to-html]:serializable.html#to-html

[serializable-to-xml]:serializable.html#to-xml

[node-set]:node-set.html

[serializable]:serializable.html

[searchable]:searchable.html
