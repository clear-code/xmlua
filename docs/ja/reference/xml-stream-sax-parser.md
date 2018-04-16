---
title: xmlua.XMLStreamSAXParser
---

# `xmlua.XMLStreamSAXParser` クラス

## 概要

このクラスは、SAX(Simple API for XML)を使ってXMLをパースするクラスです。

`XMLSAXParser`と異なるのは、`XMLStreamSAXParser`は、１つのファイルにに複数のルート要素があってもパースできることです。

`XMLSAXParser`と同じように、以下のイベント発生時に呼び出されるコールバックメソッドを登録できます。

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

`xmlua.XMLStreamSAXParser.parse`を使ってパースを開始した場合は、パース完了後にこのメソッドを呼ぶ必要があります。

このメソッドを呼ばないと、`EndDocument`のイベントは発生しません。
