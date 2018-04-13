---
title: xmlua.XMLSAXParser
---

# `xmlua.XMLSAXParser` class

## Summary

It's a class for parsing a XML with SAX(Simple API for XML).

SAX is different from DOM, processing parse documents line by line.
DOM processing parse after read all documents into memory.
So, SAX can parse documents with much less memory and fast.

You can register your callback method which call when occured events below.

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

## Class methods

### `xmlua.XMLSAXParser.new() -> XMLSAXParser` {#new}

It makes XMLSAXParser object.

You can make object of `xmlua.XMLSAXParser` class as below example.

Example:

```lua
local xmlua = require("xmlua")

local parser = xmlua.XMLSAXParser.new()
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
<?xml version="1.0" encoding="UTF-8" ?>
<root>Hello </root>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end
```

### `finish() -> boolean` {#finish}

It finishes parse XML with SAX.

If you started parse with `xmlua.XMLSAXParser.parse`, you should call this method.

If you don't call this method, `EndDocument` event isn't occure.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<root>Hello </root>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

## Property

### `start_document`

It registers user call back function as below.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.start_document = function()
  -- You want to execute code
end
```

Registered function is called, when parse start document element.

Registered function is called, when parse `<root>` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<xml>Hello</xml>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.start_document = function()
  print("Start document")
end
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Start document
```

### `end_document`

It registers user call back function as below.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.end_document = function()
  -- You want to execute code
end
```

Registered function is called, when call `xmlua.XMLSAXParser.parser.finish`.

Registered function is called, when parse `parser:finish()` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<xml>Hello</xml>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.end_document = function()
  print("End document")
end
local success = parser:parse(html)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
End document
```

### `element_declaration`

It registers user call back function as below.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.element_declaration = function(name, type, content)
  -- You want to execute code
end
```

Registered function is called, when parse element declaration in DTD.

Registered function is called, when parse `<!ELEMENT test (A,B*,C+)>` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE example [
  <!ELEMENT test (A,B*,C+)>
]>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.element_declaration = function(name,
                                      element_type,
                                      content)
  print("Element name: " .. name)
  print("Element type: " .. element_type)
  if element_type == "EMPTY" then
    return
  end
  print("Content:")
  print_element_content(content, "  ")
end
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Element name: test
Element type: ELEMENT
Content:
  type: SEQUENCE
  occur: ONCE
  child[1]:
    type: ELEMENT
    occur: ONCE
    prefix: 
    name: A
  child[2]:
    type: ELEMENT
    occur: MULTIPLE
    prefix: 
    name: B
  child[3]:
    type: ELEMENT
    occur: PLUS
    prefix: 
    name: C
```

### `attribute_declaration`

It registers user call back function as below.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.attribute_declaration = function(name,
                                        attribute_name,
                                        attribute_type,
                                        default_value_type,
                                        default_value,
                                        enumerated_values)
  -- You want to execute code
end
```

Registered function is called, when parse attribute declaration in DTD.

Registered function is called, when parse `<!ATTLIST A B (yes|no) "no">` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE example [
  <!ATTLIST A B (yes|no) "no">
]>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.attribute_declaration = function(name,
                                        attribute_name,
                                        attribute_type,
                                        default_value_type,
                                        default_value,
                                        enumerated_values)
  print("Element name: " .. name)
  print("Attribute name: " .. attribute_name)
  print("Attribute type: " .. attribute_type)
  if default_value then
    print("Default value type: " .. default_value_type)
    print("Default value: " .. default_value)
  end
  for _, v in pairs(enumerated_values) do
    print("Enumrated value: " .. v)
  end
end
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Attribute name: B
Attribute type: 9
Default value type: 1
Default value: no
Enumrated value: yes
Enumrated value: no
```

### `notation_declaration`

It registers user call back function as below.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.notation_declaration = function(name,
                                       public_id,
                                       system_id)
  -- You want to execute code
end
```

Registered function is called, when parse notation declaration in DTD.

Registered function is called, when parse `<!NOTATION test SYSTEM "Test">` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE example [
  <!NOTATION test SYSTEM "Test">
]>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.notation_declaration = function(name,
                                       public_id,
                                       system_id)
  print("Notation name: " .. name)
  if public_id ~= nil then
    print("Notation public id: " .. public_id)
  end
  if system_id ~= nil then
    print("Notation system id: " .. system_id)
  end
end
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Notation name: test
Notation system id: Test
```

### `unparsed_entity_declaration`

It registers user call back function as below.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.unparsed_entity_declaration = function(name,
                                              public_id,
                                              system_id,
                                              notation_name)
  -- You want to execute code
end
```

Registered function is called, when parse unparsed external entity declaration in DTD.

Registered function is called, when parse `<!ENTITY test SYSTEM "file:///usr/local/share/test.gif" NDATA gif>` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE example [
  <!ENTITY test SYSTEM "file:///usr/local/share/test.gif" NDATA gif>
]>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.unparsed_entity_declaration = function(name,
                                              public_id,
                                              system_id,
                                              notation_name)
  print("Unparserd entity name: " .. name)
  if public_id ~= nil then
    print("Unparserd entity public id: " .. public_id)
  end
  if system_id ~= nil then
    print("Unparserd entity system id: " .. system_id)
  end
  print("Unparserd entity notation_name: " .. notation_name)
end
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Unparserd entity name: test
Unparserd entity system id: file:///usr/local/share/test.gif
Unparserd entity notation_name: gif
```

### `entity_declaration`

It registers user call back function as below.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.entity_declaration = function(name,
                                     entity_type,
                                     public_id,
                                     system_id,
                                     content)
  -- You want to execute code
end
```

Registered function is called, when parse entity declaration in DTD.

Registered function is called, when parse `<!ENTITY test "This is test.">` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE example [
  <!ENTITY test "This is test.">
]>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.entity_declaration = function(name,
                                     entity_type,
                                     public_id,
                                     system_id,
                                     content)
  print("Entity name: " .. name)
  print("Entity type: " .. entity_type)
  if public_id ~= nil then
    print("Entity public id: " .. public_id)
  end
  if system_id ~= nil then
    print("Entity system id: " .. system_id)
  end
  print("Entity content: " .. content)
end
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Entity name: test
Entity type: 1
Entity content: This is test.
```

### `internal_subset`

It registers user call back function as below.

```lua
local listener = {}
function listener:internal_subset(name, external_id, system_id)
  -- You want to execute code
end
local parser = xmlua.XMLStreamSAXParser.new(listener)
```

Registered function is called, when parse internal subset.

Registered function is called, when parse `<!DOCTYPE example[...]>` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE example [
  <!ENTITY test "This is test.">
]>
<example/>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")

-- Parses XML with SAX
local listener = {}
function listener:internal_subset(name, external_id, system_id)
  print("Internal subset name: " .. name)
  if external_id ~= nil then
    print("Internal subset external id: " .. external_id)
  end
  if system_id ~= nil then
    print("Internal subset system id: " .. system_id)
  end
end

local parser = xmlua.XMLStreamSAXParser.new(listener)
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Internal subset name: example
```

### `external_subset`

It registers user call back function as below.

```lua
local listener = {}
function listener:external_subset(name, external_id, system_id)
  -- You want to execute code
end
local parser = xmlua.XMLStreamSAXParser.new(listener)
```

Registered function is called, when parse external subset.

Registered function is called, when parse `<!DOCTYPE example[...]>` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html></html>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")

-- Parses XML with SAX
local listener = {}
function listener:external_subset(name, external_id, system_id)
  print("External subset name: " .. name)
  if external_id ~= nil then
    print("External subset external id: " .. external_id)
  end
  if system_id ~= nil then
    print("External subset system id: " .. system_id)
  end
end

local parser = xmlua.XMLStreamSAXParser.new(listener)
local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
External subset name: html
External subset external id: -//W3C//DTD XHTML 1.0 Transitional//EN
External subset system id: http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd
```

### `processing_instruction`

It registers user call back function as below.

You can get attributes of processing instruction as argument of your call back. Attributes of processing instruction are `target` and `data_list` in below example.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.processing_instruction = function(target, data_list)
  -- You want to execute code
end
```

Registered function is called, when parse processing instruction element.

Registered function is called, when parse `<?target This is PI>` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<?xml-stylesheet href="www.test.com/test-style.xsl" type="text/xsl" ?>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.processing_instruction = function(target, data_list)
  print("Processing instruction target: "..target)
  print("Processing instruction data: "..data_list)
end
local success = parser:parse(html)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Processing instruction target: target
Processing instruction data: This is PI
```

### `cdata_block`

It registers user call back function as below.

You can get string in CDATA section as argument of your call back. String in CDATA section is `cdata_block`.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.cdata_block = function(cdata_block)
  -- You want to execute code
end
```

Registered function is called, when parse CDATA section.

Registered function is called, when parse `<![CDATA[<p>Hello world!</p>]]>` in below example.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [=[
<?xml version="1.0" encoding="UTF-8" ?>
<xml>
<![CDATA[<p>Hello world!</p>]]>
</xml>
]=]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.cdata_block = function(cdata_block)
  print("CDATA block: "..cdata_block)
end
local success = parser:parse(html)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
CDATA block: <p>Hello world!</p>
```

### `ignorable_whitespace`

It registers user call back function as below.

You can get ignorable whitespace in XML as argument of your call back. ignorable whitespace in XML is `ignorable_whitespace` in below example.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.ignorable_whitespace = function(ignorable_whitespace)
  -- You want to execute code
end
```

Registered function is called, when parse ignorable whitespace

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xml>
  <test></test>
</xml>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.ignorable_whitespace = function(ignorable_whitespace)
  print("Ignorable whitespace: ".."\""..ignorable_whitespace.."\"")
end
local success = parser:parse(html)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Ignorable whitespace: "
  "
Ignorable whitespace: "
"
```

### `comment`

It registers user call back function as below.

You can get comment of XML as argument of your call back. comment in XML is `comment` in below example.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.comment = function(comment)
  -- You want to execute code
end
```

Registered function is called, when parse XML's comment.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xml><!--This is comment--></xml>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.comment = function(comment)
  print("Comment: "..comment)
end
local success = parser:parse(html)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Comment:  This is comment.
```

### `start_element`

It registers user call back function as below.

You can get name and attributes of elements as argument of your call back.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.start_element = function(local_name,
                                prefix,
                                uri,
                                namespaces,
                                attributes)
  -- You want to execute code
end
```

Registered function is called, when parse element.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml"
  id="top"
  xhtml:class="top-level">
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.start_element = function(local_name,
                                prefix,
                                uri,
                                namespaces,
                                attributes)
  print("Start element: " .. local_name)
  if prefix then
    print("  prefix: " .. prefix)
  end
  if uri then
    print("  URI: " .. uri)
  end
  for namespace_prefix, namespace_uri in pairs(namespaces) do
    if namespace_prefix  == "" then
      print("  Default namespace: " .. namespace_uri)
    else
      print("  Namespace: " .. namespace_prefix .. ": " .. namespace_uri)
    end
  end
  if attributes then
    if #attributes > 0 then
      print("  Attributes:")
      for i, attribute in pairs(attributes) do
        local name
        if attribute.prefix then
          name = attribute.prefix .. ":" .. attribute.local_name
        else
          name = attribute.local_name
        end
        if attribute.uri then
          name = name .. "{" .. attribute.uri .. "}"
        end
        print("    " .. name .. ": " .. attribute.value)
      end
    end
  end
end

local success = parser:parse(html)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Start element: html
  prefix: xhtml
  URI: http://www.w3.org/1999/xhtml
  Namespace: xhtml: http://www.w3.org/1999/xhtml
  Attributes:
    id: top
    xhtml:class{http://www.w3.org/1999/xhtml}: top-level
```

### `end_element`

It registers user call back function as below.

You can get name of elements as argument of your call back.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.end_element = function(local_name,
                              prefix,
                              uri)
  -- You want to execute code
end
```

Registered function is called, when parse end element.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">
</xhtml:html>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.end_element = function(name)
  print("End element: " .. local_name)
  if prefix then
    print("  prefix: " .. prefix)
  end
  if uri then
    print("  URI: " .. uri)
  end
end

local success = parser:parse(xml)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
End element: html
  prefix: xhtml
  URI: http://www.w3.org/1999/xhtml
```

### `text`

It registers user call back function as below.

You can get text of text element as argument of your call back.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.text = function(text)
  -- You want to execute code
end
```

Registered function is called, when parse text element.

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local html = [[
<?xml version="1.0" encoding="UTF-8"?>
<book>
  <title>Hello World</title>
</book>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.text = function(text)
  print("Text: " .. text)
end

local success = parser:parse(html)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Text:   
Text: Hello World
```

### `error`

It registers user call back function as below.

You can get error information of parse XML with SAX as argument of your call back.

```lua
local parser = xmlua.XMLSAXParser.new()
parser.error = function(error)
  -- You want to execute code
end
```

Registered function is called, when parse failed.
Error information structure as below.

```
{
  domain
  code
  message
  level
  line
}
```

`domain` has values as specific as below.
[`Error domain list`][error-domain-list]

`code` has values as specific as below.
[`Error code list`][error-code-list]

`level` has values as specific as below.
[`Error level list`][error-level-list]

Example:

```lua
local xmlua = require("xmlua")

-- XML to be parsed
local html = [[
<>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

-- Parses XML with SAX
local parser = xmlua.XMLSAXParser.new()
parser.error = function(error)
  print("Error domain : " .. error.domain)
  print("Error code   : " .. error.code)
  print("Error message: " .. error.message)
  print("Error level  : " .. error.level)
  print("Error line   : " .. error.line)
end

local success = parser:parse(html)
if not success then
  print("Failed to parse XML with SAX")
  os.exit(1)
end

parser:finish()
```

Result of avobe example as blow.

```
Error domain :	1
Error code :	5
Error message :Extra content at the end of the document

Error level :	3
Error line :	1
Failed to parse XML with SAX
```

[error-domain-list]:error-domain-list.html
[error-code-list]:error-code-list.html
[error-level-list]:error-level-list.html
