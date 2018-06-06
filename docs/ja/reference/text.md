---
title: xmlua.Text
---

# `xmlua.Text` クラス

## 概要

テキストノードのためのクラスです。[`xmlua.Searchable:search`][searchable-search] と [`xmlua.NodeSet`][node-set] の `[]` を使ってテキストノードを取得できます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root>This is text</root>")

document:search("/root/text()")[1] -- -> xmlua.Text
```

## インスタンスメソッド

### `concat(content) -> boolean` {#concat}

既存のノードの最後に引数で指定した内容を連結します。

例：

```lua
local document =
  xmlua.XML.build({"root", {}, "Text1"})
local text_nodes = document:search("/root/text()")
text_nodes[1]:concat("Text2")
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>Text1Text2</root>
end
```

## 参照

  * [`xmlua.NodeSet`][node-set]: 複数ノードを扱うためのクラスです。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[node-set]:node-set.html

[searchable-search]:searchable.html#search

[searchable]:searchable.html
