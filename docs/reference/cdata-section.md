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

It has methods of the following modules:

  * [`xmlua.Node`][node]: Provides common methods of each nodes.

It means that you can use methods in the modules.

## Instance methods

There are no methods specific to this class.

## See also

  * [`xmlua.Document`][document]: The class for HTML document and XML document.

  * [`xmlua.Node`][node]: Provides common methods of each nodes.


[create-cdata-section]:document.html#cdata-section.html

[document]:document.html

[node]:node.html
