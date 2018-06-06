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
It returns the success or failure of the concatenation as a boolean.
`true` is a success of concatenating. `false` is faile of concatenating.

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

### `merge(content) -> boolean` {#concat}

Merge receiver and content of argument into one text node.
It returns the success or failure of the merge as a boolean.
`true` is a success of merge. `false` is merge failure.

Example:

```lua
local document = xmlua.XML.parse([[
<root>
  Text:
  <child>This is child</child>
</root>
]])
local text1 = document:search("/root/text()")
local text2 = document:search("/root/child/text()")

text1[1]:merge(text2[1])
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  Text:
--  This is child<child/>
--</root>
```

## See also

  * [`xmlua.NodeSet`][node-set]: The class for multiple nodes.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.


[node-set]:node-set.html

[searchable-search]:searchable.html#search

[searchable]:searchable.html
