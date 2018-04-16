---
title: xmlua.XMLStreamSAXParser
---

# `xmlua.XMLStreamSAXParser` class

## Summary

It's a class for parsing a XML with SAX(Simple API for XML).

`XMLStreamSAXParser` is different from `XMLSAXParser`, `XMLStreamSAXParser` can parse even if there are a number of root elements in the same file.

You can register your callback method which call when occured events below as with `XMLSAXParser`.

Call back event list:
  * StartDocument
  * ElementDeclaration
  * AttributeDeclaration
  * UnparsedEntityDeclaration
  * NotationDeclaration
  * EntityDeclaration
  * InternalSubset
  * ExternalSubset
  * CdataBlock
  * Comment
  * ProcessingInstruction
  * IgnorableWhitespace
  * Text
  * Reference
  * StartElement
  * EndElement
  * Warning
  * Error
  * EndDocument

How to register your callback methods are after add your callback methods to `listener`(`listener` is Lua's table), you give `listener` to `XMLStreamSAXParser` as below.

```lua
local listener = {}
function listener:start_element(local_name,
                                prefix,
                                uri,
                                namespaces,
  -- You want to execute code
end
local parser = xmlua.XMLStreamSAXParser.new(listener)
local parse_succeeded = parser:parse(xml)
```

## Class methods

### `xmlua.XMLStreamSAXParser.new(listener) -> XMLStreamSAXParser` {#new}

`listener`: The table that registered callback methods.

It makes `XMLStreamSAXParser` object.

You can make object of `xmlua.XMLStreamSAXParser` class as below example.

Example:

```lua
local xmlua = require("xmlua")

local listener = {
  elements = {},
  errors = {},
}
function listener:start_element(local_name, ...)
  -- You want to execute code
end
function listener:error(error)
  -- You want to execute code
end
local parser = xmlua.XMLStreamSAXParser.new(listener)
```

## Instance methods

### `parse(xml) -> boolean` {#parse}

`xml`: XML string to be parsed.

It parses the given XML.
If XML parsing is succeed, this method returns true. If XML parsing is failed, this method returns false.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
  local xml = [[
<root/>
<root/>
<root/>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")

-- register your callback method
local listener = {
  elements = {},
  errors = {},
}
function listener:start_element(local_name, ...)
  table.insert(self.elements, local_name)
end
function listener:error(error)
  table.insert(self.errors, error.message)
end

-- Parses XML with SAX
local parser = xmlua.XMLStreamSAXParser.new(listener)
local parse_succeeded = parser:parse(xml)
f not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end
```

### `finish() -> boolean` {#finish}

It finishes parse XML with SAX.

If you started parse with `xmlua.XMLStreamSAXParser.parse`, you should call this method.

If you don't call this method, `EndDocument` event isn't occure.
