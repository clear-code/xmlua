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
