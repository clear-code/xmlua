---
title: xmlua.Document
---

# `xmlua.Document`クラス

## 概要

ドキュメント用のクラスです。ドキュメントはHTMLドキュメントかXMLドキュメントのどちらかです。

このクラスのオブジェクトは以下のモジュールのメソッドを使えます。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。

つまり、このクラスのオブジェクトで上述のモジュールのメソッドを使えます。

## プロパティー

### `errors -> {ERROR1, ERROR2, ...}` {#errors}

ドキュメントをパースしているときに発生したエラーをすべて記録しています。

各エラーは以下の構造になっています。

```lua
{
  domain = ERROR_DOMAIN_AS_NUMBER,
  code = ERROR_CODE_AS_NUMBER,
  message = "ERROR_MESSAGE",
  level = ERROR_LEVEL_AS_NUMBER,
  file = nil,
  line = ERROR_LINE_AS_NUMBER,
}
```

今のところ、`domain`と`code`は内部で使用しているlibxml2のエラードメイン（`xmlErrorDomain`）とエラーコード（`xmlParserError`）を直接使用しています。そのためこれらを活用することはできません。

`message`はエラーメッセージです。これがもっとも重要な情報です。

`level`も内部で使用しているlibxml2のエラーレベル（`xmlErrorLevel`）をそのまま使っています。しかし、エラーレベルは少ししかないのでこの値を活用できます。以下がすべてのエラーレベルです。

  * `1` (`XML_ERR_WARNING`)：警告。

  * `2` (`XML_ERR_ERROR`)：復旧可能なエラー。

  * `3` (`XML_ERR_FATAL`)：復旧不可能なエラー。

今のところ、`file`は常に`nil`です。なぜなら、XMLuaはメモリー上のHTML・XMLのパースしかサポートしていないからです。

`line`はこのエラーが発生した行番号です。

## メソッド

### `root() -> xmlua.Element` {#root}

ルート要素を返します。

例：

```lua
require xmlua = require("xmlua")

local xml = xmlua.XML.parse("<root><sub/></root>")
xml:root() -- -> xmlua.Elementオブジェクトな"<root>"要素
```

### `parent() -> nil` {#parent}

常に`nil`を返します。[`xmlua.Element:parent`][element-parent]との一貫性のためにあります。

例：

```lua
require xmlua = require("xmlua")

local document = xmlua.XML.parse("<root><sub/></root>")
document:parent() -- -> nil
```

### `add_entity(entity) -> {name, original, content, entity_type, external_id, system_id, uri, owner, checked}` {#add_entity}

ドキュメントに追加したエンティティを返します。`add_entity`の引数は以下のようなLuaのテーブルです。名前、エンティティタイプ、公開識別子、外部ファイル名、エンティティの内容を指定できます。

```lua
local entity_info = {
  name = "Sample",
  entity_type = "INTERNAL_ENTITY",
  external_id = "-//W3C//DTD XHTML 1.0 Transitional//EN",
  system_id = "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
  content = "This is test."
}
```

以下の例のように、XML解析前にエンティティを登録することができます。これにより、既にあるエンティティを置き換える事ができます。

例：

```lua
local xmlua = require("xmlua")

-- パースするXML
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE root [
]>
<root>
  &Sample;
<root/>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

local parser = xmlua.XMLSAXParser.new()
local is_root = true
parser.start_element = function()
  if not is_root then
    return
  end

  local document = parser.document
  -- Setting information for add a entity
  local entity = {
    name = "Sample",
    -- Entity type list
    --   INTERNAL_ENTITY
    --   EXTERNAL_PARSED_ENTITY
    --   EXTERNAL_UNPARSED_ENTITY
    --   INTERNAL_PARAMETER_ENTITY
    --   EXTERNAL_PARAMETER_ENTITY
    --   INTERNAL_PREDEFINED_ENTITY
    entity_type = "INTERNAL_ENTITY",
    content = "This is test."
  }
  document:add_entity(entity)
  is_root = false
end
parser.text = function(text)
  print(text) -- This is test.
end

parser:parse(xml)
parser:finish()
```

上記の例の結果は以下のようになります。

```
This is test.
```

### `add_dtd_entity(entity) -> {name, original, content, entity_type, external_id, system_id, uri, owner, checked}` {#add_dtd_entity}

ドキュメントの外部サブセットに追加したエンティティを返します。`add_dtd_entity`の引数は以下のようなLuaのテーブルです。名前、エンティティタイプ、公開識別子、外部ファイル名、エンティティの内容を指定できます。

```lua
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE root SYSTEM "./sample/sample.dtd">
<root>
  &Sample;
</root>
]]
```

以下の例のように、XML解析前にエンティティを登録することができます。これにより、既にあるエンティティを置き換える事やエンティティを追加することができます。また、外部サブセットへエンティティを登録するためには、以下のように`XMLSAXParser`にオプションを指定する必要があります。

```lua
local options = {load_dtd = true}
local parser = xmlua.XMLSAXParser.new(options)
```

例：

```lua
local xmlua = require("xmlua")

-- パースするXML
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE root [
]>
<root>
  &Sample;
<root/>
]]

-- ファイル内のテキストをパースしたい場合は
-- 自分でファイルの内容を読み込む必要があります。

-- local html = io.open("example.html"):read("*all")

local options = {load_dtd = true}
local parser = xmlua.XMLSAXParser.new(options)
local is_root = true
parser.start_element = function()
  if not is_root then
    return
  end

  local document = parser.document
  -- Setting information for add entity
  local entity = {
    name = "Sample",
    -- Entity type list
    --   INTERNAL_ENTITY
    --   EXTERNAL_PARSED_ENTITY
    --   EXTERNAL_UNPARSED_ENTITY
    --   INTERNAL_PARAMETER_ENTITY
    --   EXTERNAL_PARAMETER_ENTITY
    --   INTERNAL_PREDEFINED_ENTITY
    entity_type = "INTERNAL_ENTITY",
    content = "This is test."
  }
  document:add_dtd_entity(entity)
  is_root = false
end
parser.text = function(text)
  print(text) -- This is test.
end
parser:parse(xml)
parser:finish()
```

上記の例の結果は以下のようになります。

```
This is test.
```

### `create_cdata_section(content) -> [xmlua.CDATADection]` {#create_cdata_section}

新しいcdataセクションノードを作成することができます。引数はcdataセクションノードの内容です。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local cdata_section_node =
  document:create_cdata_section("This is <CDATA>")
root = document:root()
root:add_child(cdata_section_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root><![CDATA[This is <CDATA>]]></root>
end
```

### `create_comment(content) -> [xmlua.Comment]` {#create_comment}

新しいコメントノードを作成することができます。引数はコメントノードの内容です。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local comment_node =
  document:create_comment("This is comment")
root = document:root()
root:add_child(comment_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <!--This is comment-->
--</root>
end
```

### `create_document_fragment() -> [xmlua.DocumentFragment]` {#create_document_fragment}

新しくドキュメントフラグメントノードを作成できます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local document_fragment = document:create_document_fragment()
local comment_node =
  document:create_comment("This is comment")
document_fragment:add_child(comment_node)

root = document:root()
root:add_child(comment_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <!--This is comment-->
--
--</root>
end
```

### `create_document_type(name, public_id, system_id) -> [xmlua.DocumentType]` {#create_document_type}

新しいドキュメントタイプノードを作成できます。
外部サブセットの場所は、SystemIDまたはPublicIDで指定できます。PublicIDで外部サブセットの場所を指定する場合は、 `public_id` と` system_id` を設定します。

例：

```lua
local xmlua = require("xmlua")

--PublicIDによる指定
local document = xmlua.XML.build({})
local document_type =
  document:create_document_type("TestDocumentDecl",
                                "-//Test/Sample/EN",
                                "//test.dtd")
print(document:to_xml()
--<?xml version="1.0" encoding="UTF-8"?>
--<!DOCTYPE TestDocumentDecl PUBLIC "-//Test/Sample/EN" "//system.dtd">
```

```lua
local xmlua = require("xmlua")

--SystemIDによる指定
local document = xmlua.XML.build({})
local document_type =
  document:create_document_type("TestDocumentDecl",
                                nil,
                                "//test.dtd")
print(document:to_xml()
--<?xml version="1.0" encoding="UTF-8"?>
--<!DOCTYPE TestDocumentDecl SYSTEM "//system.dtd">
```

### `create_namespace(href, prefix) -> [xmlua.Namespace]` {#create_namespace}

新しく名前空間ノードを作成できます。このメソッドは、このノードに存在する既存の接頭辞と同じ接頭辞を持つ名前空間を作成することはできません。デフォルトの名前空間を作成する場合は、 `nil`を` prefix`に設定します。

例：

```lua
local xmlua = require("xmlua")
--新しい名前空間の作成
local document = xmlua.XML.build({"root"})
local namespace =
  document:create_namespace("http://www.w3.org/1999/xhtml",
                            "xhtml")
local root = document:root()
root:set_namespace(namespace)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<xhtml:root/>
```

```lua
local xmlua = require("xmlua")
--デフォルト名前空間の作成
local document = xmlua.XML.build({"root"})
local namespace =
  document:create_namespace("http://www.w3.org/1999/xhtml",
                            nil)
local root = document:root()
root:set_namespace(namespace)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root/>
```

### `create_processing_instruction(name, content) -> [xmlua.ProcessingInstruction]` {#create_processing_instruction}

新しく処理命令ノードを作成できます。処理命令を `name`、処理命令の引数を` content`として指定することができます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local processing_instruction =
  document:create_processing_instruction("xml-stylesheet",
                                         "href=\"www.test.com/test-style.xsl\" type=\"text/xsl\"")
local root = document:root()
root:add_child(processing_instruction)
print(document:to_xml())
<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <?xml-stylesheet href="www.test.com/test-style.xsl" type="text/xsl"?>
--</root>
```

## 参照

  * [`xmlua.HTML`][html]: HTMLをパースするクラスです。

  * [`xmlua.XML`][xml]: XMLをパースするクラスです。

  * [`xmlua.Element`][element]: 要素ノード用のクラスです。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[element-parent]:element.html#parent

[html]:html.html

[xml]:xml.html

[element]:element.html

[serializable]:serializable.html

[searchable]:searchable.html
