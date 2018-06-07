---
title: xmlua.Comment
---

# `xmlua.Comment` class

## Summary

It's a class for comment node. Normaly, you can get comment object by [`xmlua.Document:create_comment`][create-comment].

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local comment_node = -- -> xmlua.Comment
  document:create_comment("This is <CDATA>")
```

## Instance methods

### `content() -> string` {#content}

It returns content of the comment as `string`.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local comment_node =
  document:create_comment("This is comment")
print(comment_node:content())
--This is comment
```

### `set_content(countent) -> void` {#set-content}

You can set content of comment with this method.

Example:

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

You can replace receiver node to specify node.

Example:

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

It's returns `nil`.
Beacuse text node don't have child node.

### `path() -> string` {#path}

It returns XPath of the comment node as `string`.

Example:

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

It remove receiver from document tree.

Example:

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
