---
title: xmlua.Serializable
---

# `xmlua.Serializable`モジュール

## 概要

HTML、XMLへのシリアライズ機能を提供します。

## メソッド

### `to_html(options=nil) -> string` {#to-html}

ドキュメントまたは、要素をHTMLへシリアライズします。

`options`: 利用可能なオプションは以下の通りです。

  * `encoding`: 出力のエンコーディングを`string`で指定します。

    * 例: `"UTF-8'`

シリアライズに失敗した場合は、エラーが発生します。

発生するエラーは以下の構造になっています。

```lua
{
  message = "エラーの詳細",
}
```

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>World</body>
</html>
]])

-- HTMLへのシリアライズ
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html>
--   <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
--     <title>Hello</title>
--   </head>
--   <body>World</body>
-- </html>
```

出力のエンコーディングを`encoding`オプションで指定できます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>World</body>
</html>
]])

-- EUC-JPエンコードされたHTMLへシリアライズ
print(document:to_html({encoding = "EUC-JP"}))
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html>
--   <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
--     <title>Hello</title>
--   </head>
--   <body>World</body>
-- </html>
```

要素をシリアライズすることもできます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>World</body>
</html>
]])

-- <body>要素をHTMLへシリアライズ
print(document:search("/html/body")[1]:to_html())
-- <body>World</body>
```

### `to_xml(options=nil) -> string` {#to-xml}

ドキュメントまたは、要素をXMLへシリアライズします。

`options`: 利用可能なオプションは以下の通りです。

  * `encoding`: 出力のエンコーディングを`string`で指定します。

    * 例: `"UTF-8'`

シリアライズに失敗した場合は、エラーが発生します。

発生するエラーは以下の構造になっています。

```lua
{
  message = "エラーの詳細",
}
```

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]])

-- XMLへシリアライズ
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub1>text1</sub1>
--   <sub2>text2</sub2>
--   <sub3>text3</sub3>
-- </root>
```

出力のエンコーディングを`encoding`オプションで指定できます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]])

-- EUC-JPエンコードされたXMLへシリアライズ
print(document:to_xml({encoding = "EUC-JP"}))
-- <?xml version="1.0" encoding="EUC-JP"?>
-- <root>
--   <sub1>text1</sub1>
--   <sub2>text2</sub2>
--   <sub3>text3</sub3>
-- </root>
```

要素をシリアライズすることもできます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse([[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]])

-- <body>要素をXMLへシリアライズ
print(document:search("/root/sub1")[1]:to_xml())
-- <sub1>text1</sub1>
```

## 参照

  * [`xmlua.HTML`][html]: HTMLドキュメント用のクラスです。

  * [`xmlua.XML`][xml]: XMLドキュメント用のクラスです。

  * [`xmlua.Element`][element]: 要素ノード用のクラスです。

  * [`xmlua.NodeSet`][node-set]: 複数ノード用のクラスです。

[html]:html.html

[xml]:xml.html

[element]:element.html

[node-set]:node-set.html
