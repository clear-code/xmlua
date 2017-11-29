---
title: Tutorial
---

# チュートリアル

このドキュメントは、XMLuaの使い方を段階的に説明しています。まだ、XMLuaをインストールしていない場合は、このドキュメントを読む前にXMLuaを[インストール][install]してください。

## ドキュメントのパース

XMLuaを使うために最初にドキュメントのパースをします。XMLuaはHTMLドキュメントとXMLドキュメントをサポートしています。

HTMLをパースするには、[`xmlua.HTML.parse`][html-parse]を使います。

例：

```lua
-- "xmlua"モジュールの読み込み
local xmlua = require("xmlua")

local html = [[
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>
    <p>World</p>
  </body>
</html>
]]

-- HTMLをパース
local document = xmlua.HTML.parse(html)

-- HTMLへのシリアライズ
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html>
--   <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
--     <title>Hello</title>
--   </head>
--   <body>
--     <p>World</p>
--   </body>
-- </html>
```

XMLをパースするには、[`xmlua.XML.parse`][xml-parse]を使います。

例：

```lua
-- "xmlua"モジュールの読み込み
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]]

-- XMLをパース
local document = xmlua.XML.parse(xml)

-- XMLへのシリアライズ
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub>text1</sub>
--   <sub>text2</sub>
--   <sub>text3</sub>
-- </root>
```

パースするHTMLまたは、XMLは`string`でなければなりません。ファイル内のHTMLやXMLをパースしたい場合は、自分でファイルの内容を読み込む必要があります。

例：

```lua
local xmlua = require("xmlua")

local xml_file = io.open("example.xml")
local xml = xml_file:read("*all")
xml_file:close()

local document = xmlua.XML.parse(xml)
```

`xmlua.HTML.parse`や`xmlua.XML.parse`は、失敗することがあります。例えば、無効なドキュメントを使った場合に失敗します。`xmlua.HTML.parse`や`xmlua.XML.parse`が失敗した場合は、エラーが発生します。

発生するエラーは以下の構造になっています。

```lua
{
  message = "エラーの詳細",
}
```

ドキュメントが無効である可能性がある場合は、`pcall`を使ってエラーを処理する必要があります。

例：

```lua
local xmlua = require("xmlua")

local invalid_xml = "<root>"

-- 無効なXMLをパース
local success, document = pcall(xmlua.XML.parse, invalid_xml)

if success then
  print("Succeeded to parse XML")
else
  -- pcallが成功を返さない場合、戻り値はエラーとなります
  -- パース対象のオブジェクトがドキュメントでない
  local err = document
  print("Failed to parse XML: " .. err.message)
  -- -> Failed to parse XML: Premature end of data in tag root line 1
end
```

パースしたHTML、パースしたXMLともにXMLuaの[`xmlua.Document`][document]オブジェクトとなり、同じ方法で操作できます。

## Search elements

You can use [XPath][xpath] to search elements. You can use [`xmlua.Searchable:search`][searchable-search] method for it.

[`xmlua.Document`][document] can use the method.

The method returns a [`xmlua.NodeSet`][node-set] object. It's a normal array with convenience methods. You can use normal array features such as `#` and `[]`.

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Searches all <sub> elements under the <root> element
local all_subs = document:search("/root/sub")

-- "#"を使ってマッチしたノードの数を出力できます。
print(#all_subs) -- -> 3

-- "[]"を使って、N番目のノードにアクセスできます。
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

[`xmlua.NodeSet`][node-set] object can also use `search` method. It means that you can search against searched result.

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub class="A"><subsub1/></sub>
  <sub class="B"><subsub2/></sub>
  <sub class="A"><subsub3/></sub>
</root>
]]

local document = xmlua.XML.parse(xml)

-- 全ての<sub class="A">要素を検索
local class_a_subs = document:search("//sub[@class='A']")

-- <sub class="a">配下の全ての要素を検索
local subsubs_in_class_a = class_a_subs:search("*")

print(#subsubs_in_class_a) -- -> 2

-- /root/sub[@class="A"]/subsub1
print(subsubs_in_class_a[1]:to_xml())
-- <subsub1/>

-- /root/sub[@class="A"]/subsub3
print(subsubs_in_class_a[2]:to_xml())
-- <subsub3/>
```

The `search` method is [`xmlua.NodeSet:search`][node-set-search]. It's not [`xmlua.Searchable:search`][searchable-search] method.

You can also use [`xmlua.Searchable:search`][searchable-search] method against element.

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Searches the <root> element
local roots = document:search("/root")
local root = roots[1]

-- Searches all <sub> elements under the <root> element
local all_subs = root:search("sub")

-- "#"を使ってマッチしたノードの数を出力できます。
print(#all_subs) -- -> 3

-- "[]"を使って、N番目のノードにアクセスできます。
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

`search` may fail. For example. it fails with invalid XPath. If it fails, it raises an error.

発生するエラーは以下の構造になっています。

```lua
{
  message = "エラーの詳細",
}
```

If you need to assume that XPath may be invalid, you need to handle error with `pcall`.

例：

```lua
local xmlua = require("xmlua")

local xml = "<root/>"

local document = xmlua.XML.parse(xml)

local invalid_xpath = "..."
local success, node_set = pcall(function()
  return document:search(invalid_xpath)
end)

if success then
  print("Succeeded to search by XPath")
else
  -- If pcall returns not success, the second return value is error
  -- object not node set.
  local err = node_set
  print("Failed to search by XPath: " .. err.message)
  -- -> Failed to search by XPath: Invalid expression
end
```

## Get attribute value

You need to get [`xmlua.Element`][element] object to get attribute value in element.

Normally, you can get `xmlua.Element` by [`xmlua.Document:root`][document-root] or [`xmlua.Searchable:search`][searchable-search].

`xmlua.Document:root` returns the root element of the document.

`xmlua.Searchable:search` returns elements as [`xmlua.NodeSet`][node-set]. You can get the first element by `node_set[1]`.

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root class='A'/>")

-- Gets the root element: <root>
local root = document:root()

-- Gets the root element: <root>
local root = document:search("/root")[1]
```

You can get attribute value by one of the followings:

  * `element.attribute_name`: Dot syntax.

  * `element["attribute_name"]`: `[]` syntax.

  * `element:get_attribute("attribute_name")`: Method syntax.

Normally, dot syntax and `[]` syntax are recommended.

If attribute name is valid Lua identifier such as "`class`", dot syntax is recommended.

If attribute name isn't valid Lua identifier such as "`xml:lang`", `[]` syntax is recommended.

If attribute name conflicts with method names available in `xmlua.Element` such as `search` and `parent`, method syntax is recommended.

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root class='A'/>")
local root = document:root()

-- ドットを使った属性値の取得
print(root.class)
-- -> A

-- []を使った属性値の取得
print(root["class"])
-- -> A

-- get_attributeメソッドを使った属性値の取得
print(root:get_attribute("class"))
-- -> A
```

If the specified attribute doesn't exist, `nil` is returned.

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root class='A'/>")
local root = document:root()

-- Returns nil for nonexistent attribute name
print(root.nonexistent)
-- -> nil
```

If the attribute what you find has namespace, you can use `"namespace-prefix:local-name"` syntax attribute name such as `"xml:lang"`. In this case, you can't use dot syntax because `":"` is included in attribute name.

If the specified namespace prefix doesn't exist, the whole specified attribute name is treated as attribute name instead of namespace URI and local name.

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root xmlns:example="http://example.com/"
      example:attribute="value-example"
      attribute="value"
      nonexistent-namespace:attribute="value-nonexistent-namespace"/>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()

-- 名前空間プレフィックスつき
print(root["example:attribute"])
-- -> value-example

-- 名前空間プレフィックスなし
print(root["attribute"])
-- -> value

-- 存在しない名前空間プレフィックスつき
print(root["nonexistent-namespace:attribute"])
-- -> value-nonexistent-namespace
```

## Get elements

...

## Next step

Now, you knew all major XMLua features! If you want to understand each feature, see [reference manual][reference] for each feature.


[install]:../install/

[html-parse]:../reference/html.html#parse

[xml-parse]:../reference/xml.html#parse

[document]:../reference/document.html

[xpath]:https://www.w3.org/TR/xpath/

[searchable-search]:../reference/searchable.html#search

[node-set]:../reference/node-set.html

[node-set-search]:../reference/node-set.html#search

[element]:../reference/element.html

[document-root]:../reference/document.html#root

[reference]:../reference/
