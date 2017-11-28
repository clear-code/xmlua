---
title: xmlua.XML
---

# `xmlua.XML`モジュール

## 概要

このクラスはXMLドキュメントを処理します。

このクラスのオブジェクトは以下のモジュールのメソッドを使えます。

  * [`xmlua.Document`][document]: HTMLやXMLドキュメント関連のメソッドを提供します。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。

つまり、このクラスのオブジェクトで上述のモジュールのメソッドを使えます。

例：

```lua
-- xmlua.Document:rootメソッドを呼ぶ
local xmlua = require("xmlua")

local document = xmlua.HTML.parse("<root><sub/></root>")

document:root() -- -> ルート要素
```

## クラスメソッド

### `xmlua.XML.parse(xml) -> xmlua.XML` {#parse}

`xml`: パース対象のXML文字列

与えられたXMLをパースして、`xmlua.XML`オブジェクトを返します。

XMLのパースに失敗した場合は、エラーが発生します。発生するエラーは以下の構造になっています。


```lua
{
  message = "エラーの詳細",
}
```

XMLをパースする例です。

```lua
local xmlua = require("xmlua")

-- パース対象のXML
local xml = [[
<root>
  <sub/>
</root>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local xml = io.open("example.xml"):read("*all")


-- XMLをパース
local success, document = pcall(xmlua.XML.parse, xml)
if not success then
  local err = document
  print("Failed to parse XML: " .. err.message)
  os.exit(1)
end

-- ルート要素の取得
local root = document:root() -- --> <root> xmlua.Elementオブジェクトな要素

-- ルート要素の名前を出力
print(root:name()) -- -> root
```

## インスタンスメソッド

インスタンスメソッドはありません。

インクルードしたモジュールのメソッドを使います。

## 参照

  * [`xmlua.Document`][document]: HTMLやXMLドキュメント関連のメソッドを提供します。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html
