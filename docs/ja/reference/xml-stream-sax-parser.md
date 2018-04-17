---
title: xmlua.XMLStreamSAXParser
---

# `xmlua.XMLStreamSAXParser` クラス

## 概要

このクラスは、SAX(Simple API for XML)を使ってXMLをパースするクラスです。

`XMLSAXParser`と異なるのは、`XMLStreamSAXParser`は、１つのファイルにに複数のルート要素があってもパースできることです。

`XMLSAXParser`と同じように、以下のイベント発生時に呼び出されるコールバックメソッドを登録できます。

コールバックイベント一覧：

  * [`start_document`][xml-sax-parser-start-document]

  * [`end_document`][xml-sax-parser-end-document]

  * [`element_declaration`][xml-sax-parser-element-declaration]

  * [`attribute_declaration`][xml-sax-parser-attribute-declaration]

  * [`notation_declaration`][xml-sax-parser-notation-declaration]

  * [`unparsed_entity_declaration`][xml-sax-parser-unparsed-entity-declaration]

  * [`entity_declaration`][xml-sax-parser-entity-declaration]

  * [`internal_subset`][xml-sax-parser-internal-subset]

  * [`external_subset`][xml-sax-parser-external-subset]

  * [`reference`][xml-sax-parser-reference]

  * [`processing_instruction`][xml-sax-parser-processing-instruction]

  * [`cdata_block`][xml-sax-parser-cdata-block]

  * [`ignorable_whitespace`][xml-sax-parser-ignorable-whitespace]

  * [`comment`][xml-sax-parser-comment]

  * [`start_element`][xml-sax-parser-start-element]

  * [`end_element`][xml-sax-parser-end-element]

  * [`text`][xml-sax-parser-text]

  * [`warning`][xml-sax-parser-warning]

  * [`error`][xml-sax-parser-error]

コールバックメソッドの登録方法は、以下のように`listener`(`listener`はLuaのテーブルです。)にコールバックメソッドを追加して、`XMLStreamSAXParser`の引数に与えます。

```lua
local listener = {}
function listener:start_element(local_name,
                                prefix,
                                uri,
                                namespaces,
  -- You want to execute code
end
local parser = xmlua.XMLStreamSAXParser.new(listener)
local parse_succeeded = parser:parse(xml)
```

## クラスメソッド

### `xmlua.XMLStreamSAXParser.new(listener) -> XMLStreamSAXParser` {#new}

`listener`: コールバックメソッドを登録したテーブル

`XMLStreamSAXParser`オブジェクトを作成します。

以下のように`xmlua.XMLStreamSAXParser`クラスのオブジェクトを作成できます。

例：

```lua
local xmlua = require("xmlua")

local listener = {
  elements = {},
  errors = {},
}
function listener:start_element(local_name, ...)
  -- 実行したいコード
end
function listener:error(error)
  -- 実行したいコード
end
local parser = xmlua.XMLStreamSAXParser.new(listener)
```

## インスタンスメソッド

### `parse(xml) -> boolean` {#parse}

`xml`: パース対象のXML文字列

与えられたXMLをパースします。XMLのパースが成功した場合は、このメソッドはtrueを返します。XMLのパースに失敗した場合は、falseを返します。

例：

```lua
local xmlua = require("xmlua")

-- XML to be parsed
  local xml = [[
<root/>
<root/>
<root/>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local xml = io.open("example.xml"):read("*all")

-- register your callback method
local listener = {
  elements = {},
  errors = {},
}
function listener:start_element(local_name, ...)
  table.insert(self.elements, local_name)
end
function listener:error(error)
  table.insert(self.errors, error.message)
end

-- SAXを使ってXMLをパースする。
local parser = xmlua.XMLStreamSAXParser.new(listener)
local parse_succeeded = parser:parse(xml)
f not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end
```

### `finish() -> boolean` {#finish}

SAXを使ったXMLのパースを終了します。

[`parse`][parse]を使ってパースを開始した場合は、パース完了後にこのメソッドを呼ぶ必要があります。

このメソッドを呼ばないと、最後のドキュメント用の[`end_document`][xml-sax-parser-end-document]イベントは発生しないかもしれません。

[xml-sax-parser-start-document]:xml-sax-parser.html#start-document
[xml-sax-parser-end-document]:xml-sax-parser.html#end-document
[xml-sax-parser-element-declaration]:xml-sax-parser.html#element-declaration
[xml-sax-parser-attribute-declaration]:xml-sax-parser.html#attribute-declaration
[xml-sax-parser-notation-declaration]:xml-sax-parser.html#notation-declaration
[xml-sax-parser-unparsed-entity-declaration]:xml-sax-parser.html#unparsed-entity-declaration
[xml-sax-parser-entity-declaration]:xml-sax-parser.html#entity-declaration
[xml-sax-parser-internal-subset]:xml-sax-parser.html#internal-subset
[xml-sax-parser-external-subset]:xml-sax-parser.html#external-subset
[xml-sax-parser-reference]:xml-sax-parser.html#reference
[xml-sax-parser-processing-instruction]:xml-sax-parser.html#processing-instruction
[xml-sax-parser-cdata-block]:xml-sax-parser.html#cdata-block
[xml-sax-parser-ignorable-whitespace]:xml-sax-parser.html#ignorable-whitespace
[xml-sax-parser-comment]:xml-sax-parser.html#comment
[xml-sax-parser-start-element]:xml-sax-parser.html#start-element
[xml-sax-parser-end-element]:xml-sax-parser.html#end-element
[xml-sax-parser-text]:xml-sax-parser.html#text
[xml-sax-parser-warning]:xml-sax-parser.html#warning
[xml-sax-parser-error]:xml-sax-parser.html#error

[parse]:#parse
