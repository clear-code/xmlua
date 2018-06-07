---
title: xmlua.Namespace
---

# `xmlua.Namespace` クラス

## 概要

名前空間用のクラスです。

通常、[`xmlua.Document:create_namespace`][create-namespace]を使用して取得します。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local document_type = -- -> xmlua.Namespace
  document:create_namespace()
```

このクラスのオブジェクトは以下のモジュールのメソッドを使えます。

  * [`xmlua.Node`][node]: それぞれのノードに共通のメソッドを提供します。

つまり、このクラスのオブジェクトで上述のモジュールのメソッドを使えます。

## インスタンスメソッド

### `prefix() -> string` {#prefix}

名前空間のプレフィックスを `string` として返します。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local namespace =
  document:create_namespace("http://www.w3.org/1999/xhtml",
                            "xhtml")

print(namespace:prefix())
-- xhtml
```

### `href() -> string` {#external_id}

名前空間のURIを `string` で返します。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local namespace =
  document:create_namespace("http://www.w3.org/1999/xhtml",
                            "xhtml")

print(namespace:prefix())
-- http://www.w3.org/1999/xhtml
```

## 参照

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。

  * [`xmlua.Node`][node]: それぞれのノードに共通のメソッドを提供します。


[create-namespace]:document.html#create-namespace

[document]:document.html

[node]:node.html
