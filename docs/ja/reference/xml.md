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

### `xmlua.XML.build(document_tree={ELEMENT, {ATTRIBUTE1, ATTRIBUTE2, ...}, ...}) -> xmlua.Document` {#build}

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
  "root",
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
-- テーブルから新規にドキュメントを作成
local document = xmlua.XML.build(doc_tree)
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root id="1" class="A">This is text.<child class="B" id="2"/></root>
```

## 参照

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html
