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
  * ElementDeclaration
  * AttributeDeclaration
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

## クラスメソッド

### `xmlua.XMLSAXParser.new() -> XMLSAXParser` {#new}

XMLSAXParser オブジェクトを作成します。

以下の例のように、`xmlua.HTMLSAXParser`クラスのオブジェクトを作成できます。

例：

```lua
local xmlua = require("xmlua")

local parser = xmlua.XMLSAXParser.new()
```

## インスタンスメソッド

### `parse(xml) -> boolean` {#parse}

`xml`: パース対象のXML文字列

与えられたXMLをパースします。XMLのパースが成功した場合は、このメソッドはtrueを返します。XMLのパースに失敗した場合は、falseを返します。

例：

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

### `finish() -> boolean` {#finish}

SAXを使ったXMLのパースを終了します。

`xmlua.XMLSAXParser.parse`を使ってパースを開始した場合は、パース完了後にこのメソッドを呼ぶ必要があります。

このメソッドを呼ばないと、`EndDocument`のイベントは発生しません。

例：

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


parser:finish()
```

## プロパティ

### `start_document`

以下のようにコールバック関数を登録できます。

```lua
local parser = xmlua.XMLSAXParser.new()
parser.start_document = function()
  -- 実行したいコード
end
```

document要素のパースを開始したときに、登録した関数が呼び出されます。

以下の例だと、`<root>`をパースしたときに、登録した関数が呼び出されます。

例：

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

### `end_document`

以下のようにコールバック関数を登録できます。

```lua
local parser = xmlua.XMLSAXParser.new()
parser.end_document = function()
  -- 実行したいコード
end
```

`xmlua.HTMLSAXParser.parser.finish`が呼ばれたときに、登録したコールバック関数が呼び出されます。

以下の例では、`parser:finish()`を実行したときに登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<xml>Hello</xml>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- SAXを使ってXMLをパースする。
local parser = xmlua.XMLSAXParser.new()
parser.end_document = function()
  print("End document")
end
local success = parser:parse(html)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

上記の例の結果は以下のようになります。

```
End document
```

### `processing_instruction`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、Processing instruction要素の属性を取得することができます。Processing Instruction要素の属性は、以下の例では、`target`と`data_list`です。

```lua
local parser = xmlua.XMLSAXParser.new()
parser.processing_instruction = function(target, data_list)
  -- 実行したいコード
end
```

Processing Instruction要素が解析されたときに、登録したコールバック関数が呼び出されます。

以下の例では、`<?target This is PI>`をパースした際に登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<?xml-stylesheet href="www.test.com/test-style.xsl" type="text/xsl" ?>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- SAXを使ってXMLをパースする。
local parser = xmlua.XMLSAXParser.new()
parser.processing_instruction = function(target, data_list)
  print("Processing instruction target: "..target)
  print("Processing instruction data: "..data_list)
end
local success = parser:parse(html)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

上記の例の結果は以下のようになります。

```
Processing instruction target: target
Processing instruction data: This is PI
```

