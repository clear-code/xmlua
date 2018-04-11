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
