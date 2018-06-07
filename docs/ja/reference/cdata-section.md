---
title: xmlua.CDATASection
---

# `xmlua.CDATASection` クラス

## 概要

cdata sectionノード用のクラスです。通常、[`xmlua.Document:create_cdata_section`][create-cdata-section]を使用して取得できます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local cdata_section_node = -- -> xmlua.CDATASection
  document:create_cdata_section("This is <CDATA>")
```

## インスタンスメソッド

### `content() -> string` {#content}

cdata sectionの内容を `string` として返します。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local cdata_section_node =
  document:create_cdata_section("This is <CDATA>")
print(cdata_section_node:content())
--This is <CDATA>
```

### `set_content(countent) -> void` {#set-content}

このメソッドは、cdata sectionの内容を設定できます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local cdata_section_node =
  document:create_cdata_section("This is <CDATA>")
print(cdata_section_node:content())
--This is <CDATA>
cdata_section_node:set_content("Seted cdata <CONTENT>")
print(cdata_section_node:content())
--Seted cdata <CONTENT>
```

### `replace(replace_node) -> void` {#replace}

レシーバのノードを指定したノードに置き換えます。

例：

```lua
local document = xmlua.XML.build({"root"})

local cdata_section_node =
  document:create_cdata_section("This is <CDATA>")
local replace_node =
  document:create_comment("This is Comment")
root = document:root()
root:add_child(cdata_section_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root><![CDATA[This is <CDATA>]]></root>
cdata_section_node:replace(replace_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <!--This is Comment-->
--</root>
```

### `text() -> string` {#text}

[`content`](#content)のエイリアス。

### `path() -> string` {#path}

cdata section node のXPathを `string` として返します。

例：

```lua
local document = xmlua.XML.build({"root"})

local cdata_section_node =
  document:create_cdata_section("This is <CDATA>")
root = document:root()
root:add_child(cdata_section_node)
print(cdata_section_node:path())
--/root/text()
```

### `unlink() -> xmlua.Element` {#unlink}

レシーバーをドキュメントツリーから削除します。

例：

```lua
local document = xmlua.XML.build({"root"})

local cdata_section_node =
  document:create_cdata_section("This is <CDATA>")
root = document:root()
root:add_child(cdata_section_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root><![CDATA[This is <CDATA>]]></root>
cdata_section_node:unlink()
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root/>
```
