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

### `cdata_block`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、CDATAセクション内の文字列を取得できます。以下の例では、CDATAセクション内の文字列は、`cdata_block`です。

```lua
local parser = xmlua.XMLSAXParser.new()
parser.cdata_block = function(cdata_block)
  -- 実行したいコード
end
```

CDATAセクションをパースしたときに、登録した関数が呼び出されます。

以下の例だと、`<![CDATA[<p>Hello world!</p>]]>`をパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- パースするXML
local xml = [=[
<?xml version="1.0" encoding="UTF-8" ?>
<xml>
<![CDATA[<p>Hello world!</p>]]>
</xml>
]=]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- SAXを使ってXMLをパースする。
local parser = xmlua.XMLSAXParser.new()
parser.cdata_block = function(cdata_block)
  print("CDATA block: "..cdata_block)
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
CDATA block: <p>Hello world!</p>
```

### `ignorable_whitespace`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、XML内の無視できる空白を取得することができます。以下の例では、無視できる空白は、`ignorable_whitespace`です。

```lua
local parser = xmlua.XMLSAXParser.new()
parser.ignorable_whitespace = function(ignorable_whitespace)
  -- 実行したいコード
end
```

無視できる空白をパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- パースするXML
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xml>
  <test></test>
</xml>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- SAXを使ってXMLをパースする。
local parser = xmlua.XMLSAXParser.new()
parser.ignorable_whitespace = function(ignorable_whitespace)
  print("Ignorable whitespace: ".."\""..ignorable_whitespace.."\"")
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
Ignorable whitespace: "
  "
Ignorable whitespace: "
"
```

### `comment`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、XML内のコメントを取得できます。以下の例では、`comment`がXML内のコメントです。

```lua
local parser = xmlua.XMLSAXParser.new()
parser.comment = function(comment)
  -- 実行したいコード
end
```

XMLのコメントをパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- パースするXML
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xml><!--This is comment--></xml>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- SAXを使ってXMLをパースする。
local parser = xmlua.XMLSAXParser.new()
parser.comment = function(comment)
  print("Comment: "..comment)
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
Comment:  This is comment.
```

### `start_element`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、要素の名前と属性を取得できます。

```lua
local parser = xmlua.XMLSAXParser.new()
parser.start_element = function(local_name,
                                prefix,
                                uri,
                                namespaces,
                                attributes)
  -- You want to execute code
end
```

要素をパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml"
  id="top"
  xhtml:class="top-level">
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.start_element = function(local_name,
                                prefix,
                                uri,
                                namespaces,
                                attributes)
  print("Start element: " .. local_name)
  if prefix then
    print("  prefix: " .. prefix)
  end
  if uri then
    print("  URI: " .. uri)
  end
  for namespace_prefix, namespace_uri in pairs(namespaces) do
    if namespace_prefix  == "" then
      print("  Default namespace: " .. namespace_uri)
    else
      print("  Namespace: " .. namespace_prefix .. ": " .. namespace_uri)
    end
  end
  if attributes then
    if #attributes > 0 then
      print("  Attributes:")
      for i, attribute in pairs(attributes) do
        local name
        if attribute.prefix then
          name = attribute.prefix .. ":" .. attribute.local_name
        else
          name = attribute.local_name
        end
        if attribute.uri then
          name = name .. "{" .. attribute.uri .. "}"
        end
        print("    " .. name .. ": " .. attribute.value)
      end
    end
  end
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
Start element: html
  prefix: xhtml
  URI: http://www.w3.org/1999/xhtml
  Namespace: xhtml: http://www.w3.org/1999/xhtml
  Attributes:
    id: top
    xhtml:class{http://www.w3.org/1999/xhtml}: top-level
```

### `end_element`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、要素の名前を取得できます。

```lua
local parser = xmlua.XMLSAXParser.new()
parser.end_element = function(local_name,
                              prefix,
                              uri)
  -- You want to execute code
end
```

要素の終わりをパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">
</xhtml:html>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local xml = io.open("example.xml"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.end_element = function(name)
  print("End element: " .. local_name)
  if prefix then
    print("  prefix: " .. prefix)
  end
  if uri then
    print("  URI: " .. uri)
  end
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
End element: html
  prefix: xhtml
  URI: http://www.w3.org/1999/xhtml
```

### `text`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、`text`要素の値を取得できます。

```lua
local parser = xmlua.XMLSAXParser.new()
parser.text = function(text)
  -- 実行したいコード
end
```

`text`要素をパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- パースするXML
local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<book>
  <title>Hello World</title>
</book>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.text = function(text)
  print("Text: " .. text)
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
Text:   
Text: Hello World
```

### `error`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、エラー情報を取得できます。

```lua
local parser = xmlua.XMLSAXParser.new()
parser.error = function(error)
  -- 実行したいコード
end
```

パースが失敗したときに、登録した関数が呼び出されます。エラー情報の構造は以下の通りです。

```
{
  domain
  code
  message
  level
  line
}
```

`domain`の値は、[`Error domain 一覧`][error-domain-list]に定義されています。

`code`の値は、[`Error code 一覧`][error-code-list]に定義されています。

`level`の値は、[`Error level 一覧`][error-level-list]に定義されています。

例：

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local html = [[
<>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.error = function(error)
  print("Error domain : " .. error.domain)
  print("Error code   : " .. error.code)
  print("Error message: " .. error.message)
  print("Error level  : " .. error.level)
  print("Error line   : " .. error.line)
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
Error domain :	1
Error code :	5
Error message :Extra content at the end of the document

Error level :	3
Error line :	1
Failed to parse XML with SAX
```

[error-domain-list]:error-domain-list.html
[error-code-list]:error-code-list.html
[error-level-list]:error-level-list.html