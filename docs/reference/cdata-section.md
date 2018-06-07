---
title: xmlua.CDATASection
---

# `xmlua.CDATASection` class

## Summary

It's a class for cdata section node. Normaly, you can get cdata section object by [`xmlua.Document:create_cdata_section`][create-cdata-section].

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local cdata_section_node = -- -> xmlua.CDATASection
  document:create_cdata_section("This is <CDATA>")
```

## Instance methods

### `content() -> string` {#content}

It returns content of the cdata section as `string`.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local cdata_section_node =
  document:create_cdata_section("This is <CDATA>")
print(cdata_section_node:content())
--This is <CDATA>
```

### `set_content(countent) -> void` {#set-content}

You can set content of cdata section with this method.

Example:

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

You can replace receiver node to specify node.

Example:

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

It's an alias of [`content`](#content).

### `path() -> string` {#path}

It returns XPath of the cdata section node as `string`.

Example:

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

It remove receiver from document tree.

Example:

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
