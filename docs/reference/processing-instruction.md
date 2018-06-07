---
title: xmlua.ProcessingInstruction
---

# `xmlua.ProcessingInstruction` class

## Summary

It's a class for processing instruction node.

Normaly, you can get processing instruction object by [`xmlua.Document:create_processing_instruction`][create-processing-instruction].

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local document_type = -- -> xmlua.ProcessingInstruction
  document:create_processing_instruction()
```

It has methods of the following modules:

  * [`xmlua.Node`][node]: Provides common methods of each nodes.

It means that you can use methods in the modules.

## Instance methods

### `target() -> string` {#prefix}

It returns processing instruction as `string`.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.build({"root"})
local processing_instruction =
  document:create_processing_instruction("xml-stylesheet",
                                         "href=\"www.test.com/test-style.xsl\" type=\"text/xsl\"")
print(processing_instruction:target())
-- xml-stylesheet
```

## See also

  * [`xmlua.Document`][document]: The class for HTML document and XML document.

  * [`xmlua.Node`][node]: Provides common methods of each nodes.


[create-processing-instruction]:document.html#create-processing-instruction

[document]:document.html

[node]:node.html
