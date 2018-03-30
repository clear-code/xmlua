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

## Properties

### `errors -> {ERROR1, ERROR2, ...}` {#errors}

It contains errors occurred while parsing document.

Each error has the following structure:

```lua
{
  domain = ERROR_DOMAIN_AS_NUMBER,
  code = ERROR_CODE_AS_NUMBER,
  message = "ERROR_MESSAGE",
  level = ERROR_LEVEL_AS_NUMBER,
  file = nil,
  line = ERROR_LINE_AS_NUMBER,
}
```

`domain` and `code` use internal libxml2's error domain (`xmlErrorDomain`) and error code (`xmlParserError`) directly for now. So you can't use them.

`message` is the error message. It's the most important information.

`level` also uses internal libxml2's error level (`xmlErrorLevel`) but there are few levels. So you can use it. Here are all error levels:

  * `1` (`XML_ERR_WARNING`): A warning.

  * `2` (`XML_ERR_ERROR`): A recoverable error.

  * `3` (`XML_ERR_FATAL`): A fatal error.

`file` is always `nil` for now. Because XMLua only supports parsing HTML and XML in memory.

`line` is the nth line where the error is occurred.

## Instance methods

### `build(document_tree={ELEMENT, {ATTRIBUTE1, ATTRIBUTE2, ...}, ...}) -> xmlua.Document`

If you give tabel as below, it returns document tree.

```lua
{ -- Support only element and attribute, text.
  "Element name", -- 1st element is element name.
  {        -- 2nd element is attribute. If this element has not attribute, this table is empty.
    ["Attribute name1"] = "Attribute value1",
    ["Attribute name2"] = "Attribute value2",
    ...,
    ["Attribute name n"] = "Attribute value n",
  },
  -- 3rd element is child node
  "Text node1", -- If this element is a string, this element is a text node.
  {                 -- If this element is a table, this element is an element node.
    "Child node name1",
    {
      ["Attribute name1"] = "Attribute value1",
      ["Attribute name2"] = "Attribute value2",
      ...,
      ["Attribute name n"] = "Attribute value n",
    },
  }
  "Text ndoe2",
  ...
}
```

This method makes new `xmlua.Document`.
If you give empty table, it returns empty `xmlua.Document`(This document have not root element).

Example:

```lua
local xmlua = require("xmlua")
local Document = require("xmlua.document")

local doc_tree = {
  "root",
  {
    ["class"] = "A",
    ["id"] = "1"
  },
  "This is text.",
  {
    "child",
    {
      ["class"] = "B",
      ["id"] = "2"
    }
  }
}
-- Make new document fro table.
local document = Document.build(doc_tree)
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root id="1" class="A">This is text.<child class="B" id="2"/></root>
```

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
