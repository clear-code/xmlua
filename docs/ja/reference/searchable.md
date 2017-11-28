---
title: xmlua.Searchable
---

# `xmlua.Searchable`モジュール

## 概要

[XPath][xpath]を使ってノードを検索する機能を提供します。

## メソッド

### `search(xpath) -> xmlua.NodeSet` {#search}

It searches nodes by XPath and returns as [`xmlua.NodeSet`][node-set] object.

If the receiver is a document ([`xmlua.HTML`][html] or [`xmlua.XTML`][xtml]), the context node in XPath is the root node.

If the receiver is an element ([`xmlua.Element`][element]), the context node in XPath is the element. It means that "`.`" XPath is the receiver element.

`xpath`: XPath to search nodes as `string`.

If XPath searching is failed, it raises an error.

発生するエラーは以下の構造になっています。

```lua
{
  message = "エラーの詳細",
}
```

例：

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

-- Searches all sub elements under the <root> element
local all_subs = document:search("/root/*")

-- You can use "#" for getting the number of matched nodes
print(#all_subs) -- -> 3

-- You can access the N-th node by "[]".
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

You can search from an element.

例：

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

-- Root element
local root = document:root()

-- Searches all sub elements under the <root> element
local all_subs = root:search("*")

-- You can use "#" for getting the number of matched nodes
print(#all_subs) -- -> 3

-- You can access the N-th node by "[]".
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
