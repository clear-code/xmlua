---
title: xmlua.Document
---

# `xmlua.Document`モジュール

## 概要

HTMLドキュメントとXMLドキュメントに共通の機能を提供します。

## メソッド

### `root() -> xmlua.Element` {#root}

ルート要素を返します。

例

```lua
require xmlua = require("xmlua")

local xml = xmlua.XML.parse("<root><sub/></root>")
xml:root() -- -> xmlua.Elementオブジェクトな"<root>"要素
```

## 参照

  * [`xmlua.HTML`][html]: The class for HTML document.

  * [`xmlua.XML`][xml]: The class for XML document.

  * [`xmlua.Element`][element]: The class for element node.

[html]:html.html

[xml]:xml.html

[element]:element.html
