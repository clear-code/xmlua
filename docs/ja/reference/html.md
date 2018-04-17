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

-- xmlua.Document:rootメソッドを呼ぶ
document:root() -- -> ルート要素
```

## クラスメソッド

### `xmlua.HTML.parse(html, options=nil) -> xmlua.Document` {#parse}

`html`: パース対象のHTML文字列。

`options`: パースオプション。`table`で指定。

指定可能なオプションは次の通りです。

  * `url`: このHTMLのベースURL。デフォルトは`nil`です。これはベースURLを指定しないということです。

  * `encoding`: このHTMLのエンコーディング。デフォルトは`nil`です。これはエンコーディングを自動で推測するということです。

  * `prefer_meta_charset`: エンコーディングの推測時にHTML 5の`<meta charset="ENCODING">`タグを使うかどうか。デフォルトは、`encoding`が`nil`なら`true`でそうでなければ`false`です。

与えられたHTMLをパースして、`xmlua.Document`オブジェクトを返します。

HTMLのパースが失敗した場合、クリティカルなエラーの場合だけエラーを発生させます。その他の場合は[`xmlua.Document.errors`][document-errors]にすべてのエラーを格納します。

通常、オプションを指定する必要はありません。

例：

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

正しいエンコーディングを知っている場合は`encoding`オプションを指定します。

例：

```lua
local xmlua = require("xmlua")

local html = [[
<html>
  <body><p>Hello</p></body>
</html>
]]

-- 指定したエンコーディングでHTMLをパース
local document = xmlua.HTML.parse(html, {encoding = "UTF-8"})

-- <body>要素内の内容を表示
print(document:search("//body"):text())
-- Hello
```

[`xmlua.Document.errors`][document-errors]からエラーの詳細を取得できます。

例：

```lua
local xmlua = require("xmlua")

-- 不正なHTML。「&」が不正。
local html = [[
<html>
  <body><p>&</p></body>
</html>
]]

-- HTMLをゆるくパース
local document = xmlua.HTML.parse(html)

-- 「&」は「&amp;」としてパース
print(document:search("//body"):to_html())
-- <body><p>&amp;<p/></body>

for i, err in ipairs(document.errors) do
  print("Error" .. i .. ":")
  print("Line=" .. err.line .. ": " .. err.message)
  -- Line=2: htmlParseEntityRef: no name
end
```

### `xmlua.HTML.build(document_tree={ELEMENT, {ATTRIBUTE1, ATTRIBUTE2, ...}, ...}[, uri][, public_id]) -> xmlua.Document` {#build}

以下のようなテーブルを与えると、ドキュメントツリーを返します。

```lua
{ -- 要素と属性とテキストのみをサポートします。
  "要素名", -- 1番目の要素は要素名です。
  {        -- 2番目の要素は属性です。属性を持たない場合は、空のテーブルにします。
    ["属性名1"] = "属性値1",
    ["属性名2"] = "属性値2",
    ...,
    ["属性名n"] = "属性値n",
  },
  -- 3番目の要素は子要素です。
  "テキストノード1", -- 文字列の場合は、テキストノードとなります。
  {                 -- テーブルの場合は、要素ノードとなります。
    "子要素名1",
    {
      ["属性名1"] = "属性値1",
      ["属性名2"] = "属性値2",
      ...,
      ["属性名n"] = "属性値n",
    },
  }
  "テキストノード2",
  ...
}
```

このメソッドは、新しく`xmlua.Document`を作成します。
空のテーブルを与えると、ルート要素を持たない空の`xmlua.Document`を返します。

例：

```lua
local xmlua = require("xmlua")

local doc_tree = {
  "html",
  {
    ["class"] = "A",
    ["id"] = "1"
  },
  "This is text.",
  {
    "child",
    {
      ["class"] = "B",
      ["id"] = "2"
    }
  }
}
-- テーブルから新規にドキュメントを作成。
local document = xmlua.HTML.build(doc_tree)
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html></html>
```

以下のように、システム識別子や公開識別子を使って、DTDの外部サブセットを指定することもできます。

例：

```lua
-- システム識別子を使ったDTDの外部サブセットの指定
local uri = "file:///usr/local/share/test.dtd"
tree = {"html"}
document = xmlua.HTML.build(tree, uri)
print(document:to_html())
-- <!DOCTYPE html SYSTEM "file:///usr/local/share/test.dtd">
-- <html></html>


-- 公開識別子を使ったDTDの外部サブセットの指定
local uri = "http://www.w3.org/TR/html4/strict.dtd"
local public_id = "-//W3C//DTD HTML 4.01//EN"
tree = {"html"}
document = xmlua.HTML.build(tree, uri, public_id)
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
-- <html></html>
```

DTDの外部サブセットを指定しない場合は、DTDは以下のようにデフォルトのDTDを使用します。

例：

```lua
-- DTDの外部サブセットを指定しない。
tree = {"html"}
document = xmlua.HTML.build(tree)
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html></html>
```

## 参照

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。


[document]:document.html

[document-errors]:document.html#errors
