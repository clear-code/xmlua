---
title: xmlua.CDATASection
---

# `xmlua.CDATASection` クラス

## 概要

cdata sectionノード用のクラスです。通常、[`xmlua.Document:create_cdata_section`][create-cdata-section]を使用して取得できます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local cdata_section_node = -- -> xmlua.CDATASection
  document:create_cdata_section("This is <CDATA>")
```

このクラスのオブジェクトは以下のモジュールのメソッドを使えます。

  * [`xmlua.Node`][node]: それぞれのノードに共通のメソッドを提供します。

つまり、このクラスのオブジェクトで上述のモジュールのメソッドを使えます。

## インスタンスメソッド

このクラス特有のメソッドはありません。

## 参照

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。

  * [`xmlua.Node`][node]: それぞれのノードに共通のメソッドを提供します。


[create-cdata-section]:document.html#cdata-section.html

[document]:document.html

[node]:node.html
