---
title: xmlua.HTML
---

# `xmlua.HTML`モジュール

## 概要

HTML文書を処理するクラスです。

このクラスのオブジェクトは以下のモジュールのメソッドを使えます。

  * [`xmlua.Document`][document]: HTMLやXMLドキュメント関連のメソッドを提供します。

  * [`xmlua.Savable`][savable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。

つまり、このクラスのオブジェクトで上述のモジュールのメソッドを使えます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.HTML.parse("<html><body></body></html>")

```lua
-- xmlua.Document:rootメソッドを呼ぶ
document:root() -- -> ルート要素
```

## クラスメソッド

### `xmlua.HTML.parse(html) -> xmlua.HTML`

`html`: パース対象のHTML文字列。

与えられたHTMLをパースして、`xmlua.HTML`オブジェクトを返します。

HTMLのエンコーディングは推測します。

HTMLのパースに失敗した場合はエラーが発生します。発生するエラーは以下の構造になっています。

```lua
{
  message = "エラーの詳細",
}
```

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
  local err = document
  print("Failed to parse HTML: " .. err.message)
  os.exit(1)
end

-- ルート要素の取得
local root = document:root() -- --> xmlua.Elementオブジェクトな<html>要素。

-- ルート要素の名前を出力
print(root:name()) -- -> html
```

## インスタンスメソッド

`xmlua.HTML`にはインスタンスメソッドはありません。

インクルードしたモジュールのメソッドを使います。

## 参照

  * [`xmlua.Document`][document]: HTMLやXMLドキュメント関連のメソッドを提供します。

  * [`xmlua.Savable`][savable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[document]:document.html

[savable]:savable.html

[searchable]:searchable.html
