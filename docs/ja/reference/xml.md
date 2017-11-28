---
title: xmlua.XML
---

# `xmlua.XML` module

## 概要

It's a class for processing a XML document.

このクラスのオブジェクトは以下のモジュールのメソッドを使えます。

  * [`xmlua.Document`][document]: HTMLやXMLドキュメント関連のメソッドを提供します。

  * [`xmlua.Savable`][savable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。

つまり、このクラスのオブジェクトで上述のモジュールのメソッドを使えます。

例：

```lua
-- Call xmlua.Document:root method
local xmlua = require("xmlua")

local document = xmlua.HTML.parse("<root><sub/></root>")

document:root() -- -> Root element
```

## クラスメソッド

### `xmlua.XML.parse(xml) -> xmlua.XML`

`xml`: XML string to be parsed.

It parses the given XML and returns `xmlua.XML` object.

If XML parsing is failed, it raises an error. The error has the
following structure:

```lua
{
  message = "エラーの詳細",
}
```

Here is an example to parse XML:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<root>
  <sub/>
</root>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local xml = io.open("example.xml"):read("*all")


-- Parses XML
local success, document = pcall(xmlua.XML.parse, xml)
if not success then
  local err = document
  print("Failed to parse XML: " .. err.message)
  os.exit(1)
end

-- Gets the root element
local root = document:root() -- --> <root> element as xmlua.Element

-- Prints the root element name
print(root:name()) -- -> root
```

## インスタンスメソッド

インスタンスメソッドはありません。

インクルードしたモジュールのメソッドを使います。

## 参照

  * [`xmlua.Document`][document]: HTMLやXMLドキュメント関連のメソッドを提供します。

  * [`xmlua.Savable`][savable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[document]:document.html

[savable]:savable.html

[searchable]:searchable.html
