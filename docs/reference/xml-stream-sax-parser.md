---
title: xmlua.XMLStreamSAXParser
---

# `xmlua.XMLStreamSAXParser` class

## Summary

It's a class for parsing a XML with SAX(Simple API for XML).

`XMLStreamSAXParser` is different from `XMLSAXParser`, `XMLStreamSAXParser` can parse even if there are a number of root elements in the same file.

You can register your callback method which call when occured events below as with `XMLSAXParser`.

Call back event list:

  * [`start_document`][xml-sax-parser-start-document]

  * [`end_document`][xml-sax-parser-end-document]

  * [`element_declaration`][xml-sax-parser-element-declaration]

  * [`attribute_declaration`][xml-sax-parser-attribute-declaration]

  * [`notation_declaration`][xml-sax-parser-notation-declaration]

  * [`unparsed_entity_declaration`][xml-sax-parser-unparsed-entity-declaration]

  * [`entity_declaration`][xml-sax-parser-entity-declaration]

  * [`internal_subset`][xml-sax-parser-internal-subset]

  * [`external_subset`][xml-sax-parser-external-subset]

  * [`reference`][xml-sax-parser-reference]

  * [`processing_instruction`][xml-sax-parser-processing-instruction]

  * [`cdata_block`][xml-sax-parser-cdata-block]

  * [`ignorable_whitespace`][xml-sax-parser-ignorable-whitespace]

  * [`comment`][xml-sax-parser-comment]

  * [`start_element`][xml-sax-parser-start-element]

  * [`end_element`][xml-sax-parser-end-element]

  * [`text`][xml-sax-parser-text]

  * [`warning`][xml-sax-parser-warning]

  * [`error`][xml-sax-parser-error]

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

If you started parse with [`parse`][parse], you should call this method.

If you don't call this method, [`end_document`][xml-sax-parser-end-document] event may not be occurred for the last document.

[xml-sax-parser-start-document]:xml-sax-parser.html#start-document
[xml-sax-parser-end-document]:xml-sax-parser.html#end-document
[xml-sax-parser-element-declaration]:xml-sax-parser.html#element-declaration
[xml-sax-parser-attribute-declaration]:xml-sax-parser.html#attribute-declaration
[xml-sax-parser-notation-declaration]:xml-sax-parser.html#notation-declaration
[xml-sax-parser-unparsed-entity-declaration]:xml-sax-parser.html#unparsed-entity-declaration
[xml-sax-parser-entity-declaration]:xml-sax-parser.html#entity-declaration
[xml-sax-parser-internal-subset]:xml-sax-parser.html#internal-subset
[xml-sax-parser-external-subset]:xml-sax-parser.html#external-subset
[xml-sax-parser-reference]:xml-sax-parser.html#reference
[xml-sax-parser-processing-instruction]:xml-sax-parser.html#processing-instruction
[xml-sax-parser-cdata-block]:xml-sax-parser.html#cdata-block
[xml-sax-parser-ignorable-whitespace]:xml-sax-parser.html#ignorable-whitespace
[xml-sax-parser-comment]:xml-sax-parser.html#comment
[xml-sax-parser-start-element]:xml-sax-parser.html#start-element
[xml-sax-parser-end-element]:xml-sax-parser.html#end-element
[xml-sax-parser-text]:xml-sax-parser.html#text
[xml-sax-parser-warning]:xml-sax-parser.html#warning
[xml-sax-parser-error]:xml-sax-parser.html#error

[parse]:#parse
