---
title: xmlua.Namespace
---

# `xmlua.Namespace` class

## Summary

It's a class for namespace node.

Normaly, you can get document type object by [`xmlua.Document:create_namespace`][create-namespace].

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local document_type = -- -> xmlua.Namespace
  document:create_namespace()
```

It has methods of the following modules:

  * [`xmlua.Node`][node]: Provides common methods of each nodes.

It means that you can use methods in the modules.

## Instance methods

### `prefix() -> string` {#prefix}

It returns prefix of the namespace as `string`.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local namespace =
  document:create_namespace("http://www.w3.org/1999/xhtml",
                            "xhtml")

print(namespace:prefix())
-- xhtml
```

### `href() -> string` {#external_id}

It returns namespace of uri as `string`.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local namespace =
  document:create_namespace("http://www.w3.org/1999/xhtml",
                            "xhtml")

print(namespace:prefix())
-- http://www.w3.org/1999/xhtml
```

## See also

  * [`xmlua.Document`][document]: The class for HTML document and XML document.

  * [`xmlua.Node`][node]: Provides common methods of each nodes.


[create-namespace]:document.html#create-namespace

[document]:document.html

[node]:node.html
