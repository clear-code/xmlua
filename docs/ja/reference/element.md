---
title: xmlua.Element
---

# `xmlua.Element`クラス

## 概要

要素ノードのためのクラスです。[`xmlua.Document:root`][document-root]と[`xmlua.NodeSet`][node-set]の`[]`を使って、要素オブジェクトを取得することができます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root><sub/></root>")

document:root() -- -> xmlua.Element
document:search("/root")[1] -- -> xmlua.Element
```

このクラスのオブジェクトは以下のモジュールのメソッドを使えます。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。

つまり、このクラスのオブジェクトで上述のモジュールのメソッドを使えます。

## インスタンスメソッド

### `name() -> string` {#name}

It returns name of the element as `string`.

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root/>")
local root = document:root()

-- <root>'s name is "root"
print(root:name()) -- -> root
```

### `get_attribute(name) -> string` {#get-attribute}

It gets attribute value of the given attribute name. If the attribute name doesn't exist, it returns `nil`.

Normally, you can use `element.attribute_name` or `element["attribute-name"]` form. They are easy to use than `element:get_attribute("attribute-name")` because they are shorter.

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root class='A'/>")
local root = document:root()

-- Uses dot syntax to get attribute value
print(root.class)
-- -> A

-- Uses [] syntax to get attribute value
print(root["class"])
-- -> A

-- Uses get_attribute method to get attribute value
print(root:get_attribute("class"))
-- -> A
```

You can use namespace by specifying attribute name with namespace prefix. If you specify nonexistent namespace prefix, whole name is processed as attribute name.

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

-- With namespace prefix
print(root["example:attribute"])
-- -> value-example

-- Without namespace prefix
print(root["attribute"])
-- -> value

-- With nonexistent namespace prefix
print(root["nonexistent-namespace:attribute"])
-- -> value-nonexistent-namespace
```

### `previous() -> xmlua.Element` {#previous}

It returns the previous sibling element as `xmlua.Element`. If there is no previous sibling element, it returns `nil`.

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local sub2 = document:search("/root/sub2")[1]

-- Gets the previous sibling element of <sub2>
print(sub2:previous():to_xml())
-- <sub1/>

local sub1 = sub2:previous()

-- Gets the previous sibling element of <sub1>
print(sub1:previous())
-- nil
```

### `next() -> xmlua.Element` {#next}

It returns the next sibling element as `xmlua.Element`. If there is no next sibling element, it returns `nil`.

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local sub2 = document:search("/root/sub2")[1]

-- Gets the next sibling element of <sub2>
print(sub2:next():to_xml())
-- <sub3/>

local sub3 = sub2:next()

-- Gets the next sibling element of <sub3>
print(sub3:next())
-- nil
```

### `parent() -> xmlua.Element` {#parent}

It returns the parent element as `xmlua.Element`. If the element is root element, it returns [`xmlua.Document`][document].

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local sub2 = document:search("/root/sub2")[1]

-- Gets the parent element of <sub2>
print(sub2:parent():to_xml())
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3/>
-- </root>

local root = sub2:parent()

-- Gets the parent element of <root>: xmlua.Document
print(root:parent():to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3/>
-- </root>

local document = root:parent()

-- Gets the parent of document
print(document:parent())
-- nil
```

### `children() -> [xmlua.Element]` {#children}

It returns the child elements as an array of `xmlua.Element`.

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()

-- Gets all child elements of <root> (<sub1>, <sub2> and <sub3>)
local subs = root:children()

print(#subs)
-- 3
print(subs[1]:to_xml())
-- <sub1/>
print(subs[2]:to_xml())
-- <sub2/>
print(subs[3]:to_xml())
-- <sub3/>
```

## 参照

  * [`xmlua.HTML`][html]: HTMLをパースするクラスです。

  * [`xmlua.XML`][xml]: XMLをパースするクラスです。

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。

  * [`xmlua.NodeSet`][node-set]: 複数ノードを扱うためのクラスです。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。


[document-root]:document.html#root

[node-set]:node-set.html

[html]:html.html

[xml]:xml.html

[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html
