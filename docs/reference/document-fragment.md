---
title: xmlua.DocumentFragment
---

# `xmlua.DocumentFragment` class

## Summary

It's a class for document fragment node.

Normaly, you can get document fragment object by [`xmlua.Document:create_document_fragment`][create-document-fragment].

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local document_fragment_node = -- -> xmlua.DocumentFragment
  document:create_document_fragment()
```

It has methods of the following modules:

  * [`xmlua.Node`][node]: Provides common methods of each nodes.

  * [`xmlua.Element`][element]: The class for element node.

It means that you can use methods in the modules.

## Instance methods

There are no methods specific to this class.

## See also

  * [`xmlua.Document`][document]: The class for HTML document and XML document.

  * [`xmlua.Node`][node]: Provides common methods of each nodes.

  * [`xmlua.Element`][element]: The class for element node.


[create-document-fragment]:document.html#document-fragment.html

[document]:document.html

[node]:node.html

[element]:element.html
