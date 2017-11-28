---
title: xmlua.Document
---

# `xmlua.Document` module

## Summary

It provides common features for HTML document and XML document.

## Methods

### `root() -> xmlua.Element` {#root}

It returns the root element.

Example:

```lua
require xmlua = require("xmlua")

local xml = xmlua.XML.parse("<root><sub/></root>")
xml:root() -- -> "<root>" element as xmlua.Element object
```

## See also

  * [`xmlua.HTML`][html]: The class for HTML document.

  * [`xmlua.XML`][xml]: The class for XML document.

  * [`xmlua.Element`][element]: The class for element node.

[html]:html.html

[xml]:xml.html

[element]:element.html
