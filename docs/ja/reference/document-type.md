---
title: xmlua.DocumentType
---

# `xmlua.DocumentType` クラス

## 概要

ドキュメントタイプノード用のクラスです。

通常、[`xmlua.Document:create_document_type`][create-document-type]を使って取得します。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local document_type = -- -> xmlua.DocumentType
  document:create_document_type()
```

このクラスのオブジェクトは以下のモジュールのメソッドを使えます。

  * [`xmlua.Node`][node]: それぞれのノードに共通のメソッドを提供します。

つまり、このクラスのオブジェクトで上述のモジュールのメソッドを使えます。

## インスタンスメソッド

### `name() -> string` {#name}

ルート要素名を `string` として返します。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({})
local document_type =
  document:create_document_type("root",
                                "-//test//This is test//EN"
                                "//sample.dtd")
print(document_type:name())
-- root
```

### `external_id() -> string` {#external_id}

外部サブセットの公開識別子を返します。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({})
local document_type =
  document:create_document_type("root",
                                "-//test//This is test//EN"
                                "//sample.dtd")
print(document_type:external_id())
-- -//test//This is test//EN
```

### `system_id() -> string` {#system_id}

外部ファイル名を `string` として返します。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({})
local document_type =
  document:create_document_type("root",
                                "-//test//This is test//EN"
                                "//sample.dtd")
print(document_type:system_id())
-- //sample.dtd
```

## 参照

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。

  * [`xmlua.Node`][node]: それぞれのノードに共通のメソッドを提供します。


[create-document-type]:document.html#create-document-type

[document]:document.html

[node]:node.html
