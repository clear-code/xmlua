---
title: xmlua.ProcessingInstruction
---

# `xmlua.ProcessingInstruction` クラス

## 概要

処理命令ノード用のクラスです。

通常、[`xmlua.Document:create_processing_instruction`][create-processing-instruction]を使用して取得します。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local document_type = -- -> xmlua.ProcessingInstruction
  document:create_processing_instruction()
```

このクラスのオブジェクトは以下のモジュールのメソッドを使えます。

  * [`xmlua.Node`][node]: それぞれのノードに共通のメソッドを提供します。

つまり、このクラスのオブジェクトで上述のモジュールのメソッドを使えます。

## インスタンスメソッド

### `target() -> string` {#prefix}

処理命令を `string` として返します。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local processing_instruction =
  document:create_processing_instruction("xml-stylesheet",
                                         "href=\"www.test.com/test-style.xsl\" type=\"text/xsl\"")
print(processing_instruction:target())
-- xml-stylesheet
```

## 参照

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。

  * [`xmlua.Node`][node]: それぞれのノードに共通のメソッドを提供します。


[create-processing-instruction]:document.html#create-processing-instruction

[document]:document.html

[node]:node.html
