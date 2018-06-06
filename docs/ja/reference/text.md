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

既存のノードの最後に引数で指定した内容を連結します。連結の成否をブーリアンとして返します。`true` は連結の成功を表します。 `false` は連結の失敗を表します。

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

### `merge(content) -> boolean` {#concat}

レシーバーのノードと引数の内容を１つのテキストノードにマージします。マージの成否をブーリアンとして返します。`true` はマージの成功を表します。 `false` はマージの失敗を表します。

例：

```lua
local document = xmlua.XML.parse([[
<root>
  Text:
  <child>This is child</child>
</root>
]])
local text1 = document:search("/root/text()")
local text2 = document:search("/root/child/text()")

text1[1]:merge(text2[1])
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  Text:
--  This is child<child/>
--</root>
```

## 参照

  * [`xmlua.NodeSet`][node-set]: 複数ノードを扱うためのクラスです。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[node-set]:node-set.html

[searchable-search]:searchable.html#search

[searchable]:searchable.html
