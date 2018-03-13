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

このクラスは、通常のテーブルに基づいています。つまり、`#node_set`(ノードセットが持つノードの数を取得する)や`node_set[1]`(ノードセットの最初のノードを取得する)のような通常のテーブルの機能が使えます。

### `to_html(options=nil) -> string` {#to-html}

ノードセット内の全てのノードを[`xmlua.Serializable:to_html`][serializable-to-html]を使ってHTMLへシリアライズし、シリアライズした文字列を結合します。

`options`: 利用可能なオプションは以下の通りです。

  * `encoding`: 出力のエンコーディングを`string`で指定します。

    * 例: `"UTF-8'`

シリアライズに失敗した場合は、エラーが発生します。

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

-- <html>配下の全ての要素 (<head> and <body>)
local node_set = document:search("/html/*")

-- 全ての要素をHTMLへシリアライズし、シリアライズしたHTMLを結合します。
print(node_set:to_html())
-- <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
--    <title>Hello</title>
--  </head><body>World</body>

-- 参考: <head>要素のシリアライズ
print(node_set[1]:to_html())
-- <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
--    <title>Hello</title>
--  </head>

-- 参考: <body>要素のシリアライズ
print(node_set[2]:to_html())
-- <body>World</body>
```

### `to_xml(options=nil) -> string` {#to-xml}

ノードセット内の全てのノードを[`xmlua.Serializable:to_xml`][serializable-to-xml]を使ってXMLへシリアライズし、シリアライズした文字列を結合します。

`options`: 利用可能なオプションは以下の通りです。

  * `encoding`: 出力のエンコーディングを`string`で指定します。

    * 例: `"UTF-8'`

シリアライズに失敗した場合は、エラーが発生します。

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

-- <root>配下の全ての要素 (<sub1>, <sub2> and <sub3>)
local node_set = document:search("/root/*")

-- 全ての要素をXMLへシリアライズし、シリアライズしたXMLを結合します。
print(node_set:to_xml())
-- <sub1>text1</sub1><sub2>text2</sub2><sub3>text3</sub3>

-- 参考: <sub1>要素のシリアライズ
print(node_set[1]:to_xml())
-- <sub1>text1</sub1>

-- 参考: <sub2>要素のシリアライズ
print(node_set[2]:to_xml())
-- <sub2>text2</sub2>

-- 参考: <sub3>要素のシリアライズ
print(node_set[3]:to_xml())
-- <sub3>text3</sub3>
```

### `search(xpath) -> xmlua.NodeSet` {#search}

XPathを使ってノードを検索し[`xmlua.NodeSet`][node-set]オブジェクトを返します。

ノードセット内のそれぞれのノードに対して、[`xmlua.Searchable:search`][searchable-search]を実行し、`xmlua.NodeSet`内でマッチしたノードを収集し、`xmlua.NodeSet`を返します。

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

-- 全ての<sub class="A">要素を検索
local class_a_subs = document:search("//sub[@class='A']")

-- <sub class="a">配下の全ての要素を検索
local subsubs_in_class_a = class_a_subs:search("*")

print(#subsubs_in_class_a) -- -> 2

-- /root/sub[@class="A"]/subsub1
print(subsubs_in_class_a[1]:to_xml())
-- <subsub1/>

-- /root/sub[@class="A"]/subsub3
print(subsubs_in_class_a[2]:to_xml())
-- <subsub3/>
```

### `content() -> string` {#content}

このノードセット内のすべてのノードの内容を取得してそれらを連結します。

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

-- <root>配下の全ての要素 (<sub1>, <sub2> and <sub3>)
local node_set = document:search("/root/*")

-- すべての内容を取得して連結
print(node_set:content())
-- text1text2text3
```

### `text() -> string` {#text}

[`content`](#content)のエイリアス。

### `paths() -> {path1, path2, ...}` {#paths}

このノードセット内の全てのノードのXPathを返します。

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

-- <root>配下の全ての要素 (<sub1>, <sub2> and <sub3>)
local node_set = document:search("/root/*")
-- <root>配下の全ての要素 (<sub1>, <sub2> and <sub3>)のXPathを返します。
for _, path in ipairs(node_set:paths()) do
  print(path)
  --/root/sub1
  --/root/sub2
  --/root/sub3
end
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
