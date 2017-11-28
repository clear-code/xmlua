---
title: xmlua.Element
---

# `xmlua.Element` class

## Summary

It's a class for element node. You can get element object by [`xmlua.Document:root`][document-root] and [`xmlua.NodeSet`][node-set]'s `[]`.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root><sub/></root>")

document:root() -- -> xmlua.Element
document:search("/root")[1] -- -> xmlua.Element
```

It has methods of the following modules:

  * [`xmlua.Serializable`][serializable]: Provides HTML and XML serialization related methods.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.

It means that you can use methods in the modules.

## Instance methods

### `name() -> string` {#name}

It returns name of the element as `string`.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root/>")
local root = document:root()

-- <root>'s name is "root"
print(root:name()) -- -> root
```

### `get_attribute(name) -> string` {#get-attribute}

It gets attribute value of the given attribute name. If the attribute name doesn't exist, it returns `nil`.

Normally, you can use `element.attribute_name` or `element["attribute-name"]` form. They are easy to use than `element:get_attribute("attribute-name")` because they are shorter.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root class='A'/>")
local root = document:root()

-- Uses dot syntax to get attribute value
print(root.class)
-- -> A

-- Uses [] syntax to get attribute value
print(root["class"])
-- -> A

-- Uses get_attribute method to get attribute value
print(root:get_attribute("class"))
-- -> A
```

You can use namespace by specifying attribute name with namespace prefix. If you specify nonexistent namespace prefix, whole name is processed as attribute name.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root xmlns:example="http://example.com/"
      example:attribute="value-example"
      attribute="value"
      nonexistent-namespace:attribute="value-nonexistent-namespace"/>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()

-- With namespace prefix
print(root["example:attribute"])
-- -> value-example

-- Without namespace prefix
print(root["attribute"])
-- -> value

-- With nonexistent namespace prefix
print(root["nonexistent-namespace:attribute"])
-- -> value-nonexistent-namespace
```

### `previous() -> xmlua.Element` {#previous}

It returns the previous sibling element as `xmlua.Element`. If there is no previous sibling element, it returns `nil`.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local sub2 = document:search("/root/sub2")[1]

-- Gets the previous sibling element of <sub2>
print(sub2:previous():to_xml())
-- <sub1/>

local sub1 = sub2:previous()

-- Gets the previous sibling element of <sub1>
print(sub1:previous())
-- nil
```

### `next() -> xmlua.Element` {#next}

It returns the next sibling element as `xmlua.Element`. If there is no next sibling element, it returns `nil`.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local sub2 = document:search("/root/sub2")[1]

-- Gets the next sibling element of <sub2>
print(sub2:next():to_xml())
-- <sub3/>

local sub3 = sub2:next()

-- Gets the next sibling element of <sub3>
print(sub3:next())
-- nil
```

### `parent() -> xmlua.Element` {#parent}

It returns the parent element as `xmlua.Element`. If the element is root element, it returns [`xmlua.Document`][document].

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local sub2 = document:search("/root/sub2")[1]

-- Gets the parent element of <sub2>
print(sub2:parent():to_xml())
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3/>
-- </root>

local root = sub2:parent()

-- Gets the parent element of <root>: xmlua.Document
print(root:parent():to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3/>
-- </root>

local document = root:parent()

-- Gets the parent of document
print(document:parent())
-- nil
```

### `children() -> [xmlua.Element]` {#children}

It returns the child elements as an array of `xmlua.Element`.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()

-- Gets all child elements of <root> (<sub1>, <sub2> and <sub3>)
local subs = root:children()

print(#subs)
-- 3
print(subs[1]:to_xml())
-- <sub1/>
print(subs[2]:to_xml())
-- <sub2/>
print(subs[3]:to_xml())
-- <sub3/>
```

## See also

  * [`xmlua.HTML`][html]: The class for parsing HTML.

  * [`xmlua.XML`][xml]: The class for parsing XML.

  * [`xmlua.Document`][document]: The class for HTML document and XML document.

  * [`xmlua.NodeSet`][node-set]: The class for multiple nodes.

  * [`xmlua.Serializable`][serializable]: Provides HTML and XML serialization related methods.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.


[document-root]:document.html#root

[node-set]:node-set.html

[html]:html.html

[xml]:xml.html

[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html
