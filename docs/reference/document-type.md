---
title: xmlua.DocumentType
---

# `xmlua.DocumentType` class

## Summary

It's a class for document type node.

Normaly, you can get document type object by [`xmlua.Document:create_document_type`][create-document-type].

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local document_type = -- -> xmlua.DocumentType
  document:create_document_type()
```

It has methods of the following modules:

  * [`xmlua.Node`][node]: Provides common methods of each nodes.

It means that you can use methods in the modules.

## Instance methods

### `name() -> string` {#name}

It returns name of the root element as `string`.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({})
local document_type =
  document:create_document_type("root",
                                "-//test//This is test//EN"
                                "//sample.dtd")
print(document_type:name())
-- root
```

### `external_id() -> string` {#external_id}

It returns public id of external subset as `string`.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({})
local document_type =
  document:create_document_type("root",
                                "-//test//This is test//EN"
                                "//sample.dtd")
print(document_type:external_id())
-- -//test//This is test//EN
```

### `system_id() -> string` {#system_id}

It returns of external file name as `string`.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({})
local document_type =
  document:create_document_type("root",
                                "-//test//This is test//EN"
                                "//sample.dtd")
print(document_type:system_id())
-- //sample.dtd
```

## See also

  * [`xmlua.Document`][document]: The class for HTML document and XML document.

  * [`xmlua.Node`][node]: Provides common methods of each nodes.


[create-document-type]:document.html#create-document-type

[document]:document.html

[node]:node.html
