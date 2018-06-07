---
title: xmlua.Node
---

# `xmlua.Node` クラス

## 概要

各ノード共通のメソッドを提供するためのクラスです。

通常、このオブジェクトは取得できません。

## クラスメソッド

### `content() -> string` {#content}

各ノードの内容を `string` として返します。

例えば、コメントノードの場合は以下のようになります。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local comment_node =
  document:create_comment("This is comment")
print(comment_node:content())
--This is comment
```

### `set_content(countent) -> void` {#set-content}

各ノードの内容を設定します。

例えば、コメントノードの場合は以下のようになります。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local comment_node =
  document:create_comment("This is comment")
print(comment_node:content())
--This is comment
comment_node:set_content("Seted comment")
print(comment_node:content())
--Seted comment
```

### `replace(replace_node) -> void` {#replace}

レシーバのノードを指定したノードに置き換えます。

例：

```lua
local document = xmlua.XML.build({"root"})

local comment_node =
  document:create_comment("This is comment")
local replace_node =
  document:create_cdata_section("This is <CDATASetion>")
root = document:root()
root:add_child(comment_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <!--This is Comment-->
--</root>
comment_node:replace(replace_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root><!--[CDATA[This is <CDATA>]]></root>
```

### `text() -> nil` {#text}

`nil` を返します。このメソッドは、子要素を持たないノードのためのメソッドです。

### `path() -> string` {#path}

各ノードのXPathを `string` として返します。

例えば、コメントノードの場合は以下のようになります。

例：

```lua
local document = xmlua.XML.build({"root"})

local comment_node =
  document:create_comment("This is comment")
root = document:root()
root:add_child(comment_node)
print(comment_node:path())
--/root/comment()
```

### `unlink() -> xmlua.Element` {#unlink}

レシーバーをドキュメントツリーから削除します。

例：

```lua
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
comment_node:unlink()
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root/>
```
