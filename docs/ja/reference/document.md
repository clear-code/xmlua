---
title: xmlua.Document
---

# `xmlua.Document`クラス

## 概要

ドキュメント用のクラスです。ドキュメントはHTMLドキュメントかXMLドキュメントのどちらかです。

このクラスのオブジェクトは以下のモジュールのメソッドを使えます。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。

つまり、このクラスのオブジェクトで上述のモジュールのメソッドを使えます。

## メソッド

### `root() -> xmlua.Element` {#root}

ルート要素を返します。

例：

```lua
require xmlua = require("xmlua")

local xml = xmlua.XML.parse("<root><sub/></root>")
xml:root() -- -> xmlua.Elementオブジェクトな"<root>"要素
```

### `parent() -> nil` {#parent}

常に`nil`を返します。[`xmlua.Element:parent`][element-parent]との一貫性のためにあります。

例：

```lua
require xmlua = require("xmlua")

local document = xmlua.XML.parse("<root><sub/></root>")
document:parent() -- -> nil
```

## 参照

  * [`xmlua.HTML`][html]: HTMLをパースするクラスです。

  * [`xmlua.XML`][xml]: XMLをパースするクラスです。

  * [`xmlua.Element`][element]: 要素ノード用のクラスです。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[element-parent]:element.html#parent

[html]:html.html

[xml]:xml.html

[element]:element.html

[serializable]:serializable.html

[searchable]:searchable.html
