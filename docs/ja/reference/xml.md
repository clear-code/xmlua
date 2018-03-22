---
title: xmlua.XML
---

# `xmlua.XML`クラス

## 概要

XMLをパースするクラスです。

パースしたドキュメントは[`xmlua.Document`][document]オブジェクトになります。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root><sub/></root>")

-- xmlua.Document:rootメソッドを呼ぶ
document:root() -- -> ルート要素
```

## クラスメソッド

### `xmlua.XML.parse(xml) -> xmlua.Document` {#parse}

`xml`: パース対象のXML文字列

与えられたXMLをパースして、`xmlua.Document`オブジェクトを返します。

XMLのパースに失敗した場合はエラーが発生します。

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
  local message = document
  print("Failed to parse XML: " .. message)
  os.exit(1)
end

-- ルート要素の取得
local root = document:root() -- --> <root> xmlua.Elementオブジェクトな要素

-- ルート要素の名前を出力
print(root:name()) -- -> root
```

## 参照

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html
