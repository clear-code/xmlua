title: xmlua.HTML
"

# `xmlua.HTML`モジュール

## サマリー

`xmlua.HTML`は、以下のモジュールのメソッドを持っています。

  * [`xmlua.Document`][document]: HTMLやXMLドキュメント関連のメソッドを提供します。

  * [`xmlua.Savable`][savable]: HTMLとXMLのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。

つまり、`xmlua.HTML`内で上記のメソッドを使うことができます。例：

```lua
-- Call `xmlua.Document:root` method
html:root() -- -> Root element
```

Classメソッド

### `xmlua.HTML.parse(html) -> xmlua.HTML`

`html`: パース対象のHTML文字列。

与えられたHTMLをパースして、`xmlua.HTML`オブジェクトを返します。

HTMLのエンコーディングは推測されます。

HTMLのパースに失敗した場合はエラーが発生します。発生するエラーは以下の構造を持っています。

```lua
{
  message = "Error details",
}
```

HTMLのパースの例です。

```lua
local xmlua = require("xmlua")

-- HTMLのパース
-- ファイル内のHTMLを使いたい場合は、
-- HTMLの中身をファイルから読み込む必要があります。
local html = [[
<html>
  <body>
    <p>Hello</p>
  </body>
</html>
]]

-- Parses HTML
local success, document = pcall(xmlua.HTML.parse, html)
if not success then
  local err = document
  print("Failed to parse HTML: " .. err.message)
  os.exit(1)
end

-- root要素の取得
local root = document:root() -- --> <html> element as xmlua.Element

-- root要素の名前を出力
print(root:name()) -- -> html
```

## インスタンスメソッド

`xmlua.HTML`はインスタンスメソッドを持っていません。

インクルードしたモジュールのメソッドは使えます。

## 参照

  * [`xmlua.Document`][document]: HTMLやXMLドキュメント関連のメソッドを提供します。

  * [`xmlua.Savable`][savable]: HTMLとXMLのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[document]:document.html

[savable]:savable.html

[searchable]:searchable.html
