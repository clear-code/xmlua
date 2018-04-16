---
title: xmlua.HTMLSAXParser
---

# `xmlua.HTMLSAXParser` クラス

## 概要

このクラスは、SAX(Simple API for XML)を使ってHTMLをパースするクラスです。

SAXは、DOMと異なりドキュメントを一行ずつパースし、DOMはすべてのドキュメントをメモリに読み込んだあとにパースを行います。そのため、SAXはDOMと比べて少ないメモリで高速に動作します。

このクラスを使って、以下のイベントが起こった際に呼ばれるコールバックメソッドを登録できます。

コールバックイベント一覧:
  * StartDocument
  * ProcessingInstruction
  * CdataBlock
  * IgnorableWhitespace
  * Comment
  * StartElement
  * EndElement
  * Text
  * EndDocument
  * Error

## クラスメソッド

### `xmlua.HTMLSAXParser.new() -> HTMLSAXParser` {#new}

HTMLSAXParser オブジェクトを作成します。

以下の例のように、`xmlua.HTMLSAXParser`クラスのオブジェクトを作成できます。

例：

```lua
local xmlua = require("xmlua")

local parser = xmlua.HTMLSAXParser.new()
```

## インスタンスメソッド

### `parse(html) -> boolean` {#parse}

`html`: パース対象のHTML文字列。

与えられたHTMLをパースします。HTMLのパースが成功した場合は、このメソッドはtrueを返します。HTMLのパースに失敗した場合は、falseを返します。

例：

```lua
local xmlua = require("xmlua")

-- パース対象のHTML
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

-- SAXを使ってHTMLをパースする。
local parser = xmlua.HTMLSAXParser.new()
local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end
```

### `finish() -> boolean` {#finish}

SAXを使ったHTMLのパースを終了します。

`xmlua.HTMLSAXParser.parse`を使ってパースを開始した場合は、パース完了後にこのメソッドを呼ぶ必要があります。

このメソッドを呼ばないと、`EndDocument`のイベントは発生しません。

例：

```lua
local xmlua = require("xmlua")

-- パース対象のHTML
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

-- SAXを使ってHTMLをパースする。
local parser = xmlua.HTMLSAXParser.new()
local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end

parser:finish()
```

## プロパティ

### `start_document`

以下のようにコールバック関数を登録できます。

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.start_document = function()
  -- 実行したいコード
end
```

document要素のパースを開始したときに、登録した関数が呼び出されます。

以下の例だと、`<html>`をパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- パース対象のHTML
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

-- SAXを使ってHTMLをパースする。
local parser = xmlua.HTMLSAXParser.new()
parser.start_document = function()
  print("Start document")
end
local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
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
local parser = xmlua.HTMLSAXParser.new()
parser.end_document = function()
  -- You want to execute code
end
```

`xmlua.HTMLSAXParser.parser.finish`が呼ばれたときに、登録したコールバック関数が呼び出されます。

以下の例では、`parser:finish()`を実行したときに登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- パース対象のHTML
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

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.end_document = function()
  print("End document")
end
local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
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
local parser = xmlua.HTMLSAXParser.new()
parser.processing_instruction = function(target, data_list)
  -- You want to execute code
end
```

Processing Instruction要素が解析されたときに、登録したコールバック関数が呼び出されます。

以下の例では、`<?target This is PI>`をパースした際に登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html>
  <?target This is PI>
  <body>
    <p>Hello</p>
  </body>
</html>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.processing_instruction = function(target, data_list)
  print("Processing instruction target: "..target)
  print("Processing instruction data: "..data_list)
end
local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
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

コールバック関数の引数として、`script`要素の属性を取得できます。以下の例では、`script`要素の属性は、`cdata_block`です。

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.cdata_block = function(cdata_block)
  -- You want to execute code
end
```

script要素をパースしたときに、登録した関数が呼び出されます。

以下の例では、`<script>alert(\"Hello world!\")</script>`をパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html>
  <body>
    <p>Hello</p>
  </body>
  <script>alert(\"Hello world!\")</script>
</html>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.cdata_block = function(cdata_block)
  print("CDATA block: "..cdata_block)
end
local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end

parser:finish()
```

上記の例の結果は以下のようになります。

```
CDATA block: alert(\"Hello world!\")
```

### `ignorable_whitespace`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、HTML内の無視できる空白を取得することができます。以下の例では、無視できる空白は、`ignorable_whitespace`です。

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.ignorable_whitespace = function(ignorable_whitespace)
  -- You want to execute code
end
```

無視できる空白をパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html> <body><p>Hello</p></body> </html>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.ignorable_whitespace = function(ignorable_whitespace)
  print("Ignorable whitespace: ".."\""..ignorable_whitespace.."\"")
end
local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end

parser:finish()
```

上記の例の結果は以下のようになります。

```
Ignorable whitespace: " "
Ignorable whitespace: " "
Ignorable whitespace: "
"
```

### `comment`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、HTML内のコメントを取得できます。以下の例では、`comment`がHTML内のコメントです。

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.comment = function(comment)
  -- You want to execute code
end
```

HTMLのコメントをパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html>
<!--This is comment.-->
  <body>
    <p>Hello</p>
  </body>
</html>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.comment = function(comment)
  print("Comment: "..comment)
end
local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
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
local parser = xmlua.HTMLSAXParser.new()
parser.start_element = function(local_name, attributes)
  -- You want to execute code
end
```

要素をパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html id="top" class="top-level">
  <body>
    <p>Hello</p>
  </body>
</html>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.start_element = function(local_name, attributes)
  print("Start element: " .. local_name)
  if #attributes > 0 then
    print("  Attributes:")
    for i, attribute in pairs(attributes) do
      local name
      if attribute.prefix then
        name = attribute.prefix .. ":" .. attribute.local_name
      else
        name = attribute.name
      end
      if attribute.uri then
        name = name .. "{" .. attribute.uri .. "}"
      end
      print("    " .. name .. ": " .. attribute.value)
    end
  end
end

local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end

parser:finish()
```

上記の例の結果は以下のようになります。

```
Start element: html
  Attributes:
    id: top
    class: top-level
Start element: body
Start element: p
```

### `end_element`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、要素の名前を取得できます。

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.end_element = function(name)
  -- You want to execute code
end
```

要素の終わりをパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html id="top" class="top-level">
  <body>
    <p>Hello</p>
  </body>
</html>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.end_element = function(name)
  print("End element: " .. name)
end

local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end

parser:finish()
```

上記の例の結果は以下のようになります。

```
End element: p
End element: body
End element: html
```

### `text`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、`text`要素の値を取得できます。

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.text = function(text)
  -- You want to execute code
end
```

`text`要素をパースしたときに、登録した関数が呼び出されます。

例：

```lua
local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html><body><p>Hello</p></body></html>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.text = function(text)
  print("Text: " .. text)
end

local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end

parser:finish()
```

上記の例の結果は以下のようになります。

```
Text: Hello
```

### `error`

以下のようにコールバック関数を登録できます。

コールバック関数の引数として、エラー情報を取得できます。

```lua
local parser = xmlua.HTMLSAXParser.new()
parser.error = function(error)
  -- You want to execute code
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

-- HTML to be parsed
local html = [[
<>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

-- Parses HTML with SAX
local parser = xmlua.HTMLSAXParser.new()
parser.error = function(error)
  print("Error domain : " .. error.domain)
  print("Error code   : " .. error.code)
  print("Error message: " .. error.message)
  print("Error level  : " .. error.level)
  print("Error line   : " .. error.line)
end

local success = parser:parse(html)
if not success then
  print("Failed to parse HTML with SAX")
  os.exit(1)
end

parser:finish()
```

上記の例の結果は以下のようになります。

```
Error domain : 5
Error code   : 68
Error message: htmlParseStartTag: invalid element name

Error level  : 2
Error line   : 1
Failed to parse HTML with SAX
```

[error-domain-list]:error-domain-list.html
[error-code-list]:error-code-list.html
[error-level-list]:error-level-list.html

