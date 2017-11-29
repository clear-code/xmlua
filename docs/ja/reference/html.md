---
title: xmlua.HTML
---

# `xmlua.HTML`クラス

## 概要

HTMLドキュメントをパースするクラスです。

パースしたドキュメントは[`xmlua.Document`][document]オブジェクトになります。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.HTML.parse("<html><body></body></html>")

```lua
-- xmlua.Document:rootメソッドを呼ぶ
document:root() -- -> ルート要素
```

## クラスメソッド

### `xmlua.HTML.parse(html) -> xmlua.Document` {#parse}

`html`: パース対象のHTML文字列。

与えられたHTMLをパースして、`xmlua.Document`オブジェクトを返します。

HTMLのエンコーディングは推測します。

HTMLのパースに失敗した場合はエラーが発生します。

HTMLをパースする例です。

```lua
local xmlua = require("xmlua")

-- パース対象のHTML
local html = [[
<html>
  <body>
    <p>Hello</p>
  </body>
</html>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- HTMLをパース
local success, document = pcall(xmlua.HTML.parse, html)
if not success then
  local message = document
  print("Failed to parse HTML: " .. message)
  os.exit(1)
end

-- ルート要素の取得
local root = document:root() -- --> xmlua.Elementオブジェクトな<html>要素。

-- ルート要素の名前を出力
print(root:name()) -- -> html
```

## 参照

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html
