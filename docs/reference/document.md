---
title: xmlua.Document
---

# `xmlua.Document` class

## Summary

It's a class for a document. Document is HTML document or XML document.

It has methods of the following modules:

  * [`xmlua.Serializable`][serializable]: Provides HTML and XML serialization related methods.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.

It means that you can use methods in the modules.

## Methods

### `root() -> xmlua.Element` {#root}

It returns the root element.

Example:

```lua
require xmlua = require("xmlua")

local xml = xmlua.XML.parse("<root><sub/></root>")
xml:root() -- -> "<root>" element as xmlua.Element object
```

### `parent() -> nil` {#parent}

It always returns `nil`. It's just for consistency with [`xmlua.Element:parent`][element-parent].

Example:

```lua
require xmlua = require("xmlua")

local document = xmlua.XML.parse("<root><sub/></root>")
document:parent() -- -> nil
```

## See also

  * [`xmlua.HTML`][html]: The class for parsing HTML.

  * [`xmlua.XML`][xml]: The class for parsing XML.

  * [`xmlua.Element`][element]: The class for element node.

  * [`xmlua.Serializable`][serializable]: Provides HTML and XML serialization related methods.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.


[element-parent]:element.html#parent

[html]:html.html

[xml]:xml.html

[element]:element.html

[serializable]:serializable.html

[searchable]:searchable.html
