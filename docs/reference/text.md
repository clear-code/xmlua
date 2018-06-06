---
title: xmlua.Text
---

# `xmlua.Text` class

## Summary

It's a class for text node. You can get text object by [`xmlua.Searchable:search`][searchable-search] and [`xmlua.NodeSet`][node-set]'s `[]`.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root>This is text</root>")

document:search("/root/text()")[1] -- -> xmlua.Text
```

## Instance methods

### `concat(content) -> boolean` {#concat}

Concat the given content of argument at the end of the existing node.

Example:

```lua
local document =
  xmlua.XML.build({"root", {}, "Text1"})
local text_nodes = document:search("/root/text()")
text_nodes[1]:concat("Text2")
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>Text1Text2</root>
end
```

## See also

  * [`xmlua.NodeSet`][node-set]: The class for multiple nodes.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.


[node-set]:node-set.html

[searchable-search]:searchable.html#search

[searchable]:searchable.html
