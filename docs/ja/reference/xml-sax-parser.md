---
title: xmlua.XMLSAXParser
---

# `xmlua.XMLSAXParser` クラス

## 概要

このクラスは、SAX(Simple API for XML)を使ってXMLをパースするクラスです。

SAXは、DOMと異なりドキュメントを一行ずつパースし、DOMはすべてのドキュメントをメモリに読み込んだあとにパースを行います。そのため、SAXはDOMと比べて少ないメモリで高速に動作します。

このクラスを使って、以下のイベントが起こった際に呼ばれるコールバックメソッドを登録できます。

コールバックイベント一覧:
  * StartDocument
  * UnparsedEntityDeclaration
  * NotationDeclaration
  * EntityDeclaration
  * InternalSubset
  * ExternalSubset
  * CdataBlock
  * Comment
  * ProcessingInstruction
  * IgnorableWhitespace
  * Text
  * Reference
  * StartElement
  * EndElement
  * Warning
  * Error
  * EndDocument

## インスタンスメソッド

### `xmlua.XMLSAXParser.new() -> XMLSAXParser` {#new}

XMLSAXParser オブジェクトを作成します。

以下の例のように、`xmlua.HTMLSAXParser`クラスのオブジェクトを作成できます。

例:

```lua
local xmlua = require("xmlua")

local parser = xmlua.XMLSAXParser.new()
```

## メソッド

### `xmlua.XMLSAXParser.parse(xml) -> boolean` {#parse}

`xml`: パース対象のXML文字列

与えられたXMLをパースします。XMLのパースが成功した場合は、このメソッドはtrueを返します。XMLのパースに失敗した場合は、falseを返します。

例:

```lua
local xmlua = require("xmlua")

-- パースするXML
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<root>Hello </root>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local xml = io.open("example.xml"):read("*all")

-- SAXを使ってXMLをパースする。
local parser = xmlua.XMLSAXParser.new()
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end
```

### `xmlua.XMLSAXParser.finish() -> boolean` {#finish}

SAXを使ったXMLのパースを終了します。

`xmlua.XMLSAXParser.parse`を使ってパースを開始した場合は、パース完了後にこのメソッドを呼ぶ必要があります。

このメソッドを呼ばないと、`EndDocument`のイベントは発生しません。

例:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
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

-- SAXを使ってXMLをパースする。
local parser = xmlua.XMLSAXParser.new()
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end


parser:finish()
```

## プロパティ

### `xmlua.XMLSAXParser.start_document`

以下のようにコールバック関数を登録できます。

```lua
local parser = xmlua.XMLSAXParser.new()
parser.start_document = function()
  -- 実行したいコード
end
```

document要素のパースを開始したときに、登録した関数が呼び出されます。

以下の例だと、`<root>`をパースしたときに、登録した関数が呼び出されます。

例:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<xml>Hello</xml>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local xml = io.open("example.xml"):read("*all")

-- SAXを使ってXMLをパースする。
local parser = xmlua.XMLSAXParser.new()
parser.start_document = function()
  print("Start document")
end
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

上記の例の結果は以下のようになります。

```
Start document
```
