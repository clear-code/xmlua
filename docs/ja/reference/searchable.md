---
title: xmlua.Searchable
---

# `xmlua.Searchable`モジュール

## 概要

[XPath][xpath]を使ってノードを検索する機能を提供します。

## メソッド

### `search(xpath) -> xmlua.NodeSet` {#search}

XPathを使ってノードを検索し[`xmlua.NodeSet`][node-set]オブジェクトを返します。

レシーバーがドキュメント([`xmlua.HTML`][html] or [`xmlua.XTML`][xml])場合、XPathのコンテキストノードはルートノードとなります。

レシーバーが要素([`xmlua.Element`][element])の場合、XPathのコンテキストノードはレシーバーの要素になります。つまり、レシーバーの要素がXPathの"`.`"となります。

`xpath`: ノードを検索するためのXPath文字列です。

XPathでの検索に失敗した場合は、エラーが発生します。

エラーの構造を示します。

```lua
{
  message = "エラーの詳細",
}
```

例

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]]

local document = xmlua.XML.parse(xml)

-- <root>要素配下の要素を全て検索します。
local all_subs = document:search("/root/*")

-- "#"を使ってマッチしたノードの数を出力できます。
print(#all_subs) -- -> 3

-- "[]"を使って、N番目のノードにアクセスできます。
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

ルート要素からでも検索できます。

例

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]]

local document = xmlua.XML.parse(xml)

-- ルート要素
local root = document:root()

-- <root>要素配下の要素を全て検索します。
local all_subs = root:search("*")

-- "#"を使ってマッチしたノードの数を出力できます。
print(#all_subs) -- -> 3

-- "[]"を使って、N番目のノードにアクセスできます。
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

## 参照

  * [XPath][xpath]: The XPath specification.

  * [`xmlua.HTML`][html]: HTMLドキュメント用のクラスです。

  * [`xmlua.XML`][xml]: XMLドキュメント用のクラスです。

  * [`xmlua.Element`][element]: 要素ノード用のクラスです。

  * [`xmlua.NodeSet`][node-set]: The class for multiple nodes.

[xpath]:https://www.w3.org/TR/xpath/

[html]:html.html

[xml]:xml.html

[element]:element.html

[node-set]:node-set.html
