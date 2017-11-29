---
title: xmlua.XML
---

# `xmlua.XML` class

## Summary

It's a class for parsing a XML.

The parsed document is returned as [`xmlua.Document`][document] object.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root><sub/></root>")

-- Call xmlua.Document:root method
document:root() -- -> Root element
```

## Class methods

### `xmlua.XML.parse(xml) -> xmlua.Document` {#parse}

`xml`: XML string to be parsed.

It parses the given XML and returns `xmlua.Document` object.

If XML parsing is failed, it raises an error.

Here is an example to parse XML:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<root>
  <sub/>
</root>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")


-- Parses XML
local success, document = pcall(xmlua.XML.parse, xml)
if not success then
  local message = document
  print("Failed to parse XML: " .. message)
  os.exit(1)
end

-- Gets the root element
local root = document:root() -- --> <root> element as xmlua.Element

-- Prints the root element name
print(root:name()) -- -> root
```

## See also

  * [`xmlua.Document`][document]: The class for HTML document and XML document.

  * [`xmlua.Serializable`][serializable]: Provides HTML and XML serialization related methods.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.


[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html
