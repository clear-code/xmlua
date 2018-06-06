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

### `content() -> string` {#content}

It returns content of the element as `string`.

The content is all texts under the element.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  text1
  <child1>child1 text</child1>
  text2
  <child2>child2 text</child2>
  text3
</root>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()

-- The <root>'s content. Spaces are also the <root>'s content.
print(root:content())
--
--  text1
--  child1 text
--  text2
--  child2 text
--  text3
--
```

### `text() -> string` {#text}

It's an alias of [`content`](#content).

### `path() -> string` {#path}

It returns XPath of the element as `string`.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <child1>child1 text</child1>
  <child2>child2 text</child2>
</root>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()
-- Gets all child elements of <root> (<child1> and <child2>)
local children = root:children()

-- Returns XPath of <root>'s all child elements.
for i = 1, #children do
  print(children[i]:path())
  --/root/child1
  --/root/child2
end
```

### `append_element(name, attributes=nil) -> xmlua.Element` {#append-element}

Make an element with the specified name and append it the last child element of `xmlua.Element` of the receiver.
If you specify attributes, it set the attribute to the appended element.
It returns appended element.
If `name` is `namespace_prefix:local_name`, it set the namespace to the append element.

Example:

```lua
local xmlua = require("xmlua")

--append node.
local document = xmlua.XML.parse("<root/>")
local root = document:root()
local child = root:append_element("child")
print(child:to_xml())
-- <child/>
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <child/>
-- </root>


-- appned node with attirbute
local document = xmlua.XML.parse("<root/>")
local root = document:root()
local child = root:append_element("child", {id="1", class="A"})

print(child:to_xml())
-- <child class="A" id="1"/>
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <child class="A" id="1"/>
-- </root>


-- appned node with namespace
local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml"/>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()
local child = root:append_element("xhtml:child", {id="1", class="A"})
print(child:to_xml())
-- <xhtml:child class="A" id="1"/>
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">
--   <xhtml:child class="A" id="1"/>
-- </xhtml:html>
```

### `insert_element(position, name, attributes=nil) -> xmlua.Element` {#insert-element}

Make an element with the specified name and append it the `position`th child element of `xmlua.Element` of the receiver.
`position` is 1 origin.
If you specify attributes, it set the attribute to the appended element.
It returns appended element.
If `name` is `namespace_prefix:local_name`, it set the namespace to the append element.

Example:

```lua
local xmlua = require("xmlua")

-- insert element
local document = xmlua.XML.parse([[<root><child1/><child2/></root>]])
local root = document:root()
local child = root:insert_element(2, "new-child")
print(child)
-- <new-child/>
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <child1/>
--   <new-child/>
--   <child2/>
-- </root>


-- Insert element with attribute
local document = xmlua.XML.parse([[<root><child1/><child2/></root>]])
local root = document:root()
local child = root:insert_element(2, "new-child", {id="1", class="A"})
print(child)
-- <new-child class="A" id="1"/>
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <child1/>
--   <new-child class="A" id="1"/>
--   <child2/>
-- </root>


-- Insert element with namespace
local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <xhtml:child1/>
  <xhtml:child2/>
</xhtml:html>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()
local child = root:insert_element(2,
                                  "xhtml:new-child",
                                  {id="1", class="A"})
print(child)
-- <xhtml:new-child class="A" id="1"/>
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">
--   <xhtml:child1/>
--   <xhtml:new-child class="A" id="1"/><xhtml:child2/>
-- </xhtml:html>
```

### `append_text(text_content) -> xmlua.Text` {#append-text}

Make an text element with the specified text content and append it the last child element of `xmlua.Element` of the receiver.
It returns appended text element.

Example:

```lua
local xmlua = require("xmlua")
--append text node.
local document = xmlua.XML.parse("<root/>")
local root = document:root()
local child = root:append_text("This is Text element.")
print(child:text())
-- This is Text element.
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>This is Text element.</root>
```

### `add_child(child_node) -> void` {#add_child}

Add a new node to receiver, at the end of child.
If new node is attribute node, it is added into propertoes instead of children.

Example:

```lua
local xmlua = require("xmlua")
--append CDATASection node.
local document = xmlua.XML.build({"root"})
local cdata_section_node =
  document:create_cdata_section("This is <CDATA>")
local root = document:root()
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root><![CDATA[This is <CDATA>]]></root>
```

### `add_previous_sibling(node) -> void` {#add_previous_sibling}

Add a new node as the previous sibling receiver.
If the new node was already inserted in a document it is first unlinked from its existing context.
If the new node is ATTRIBUTE, it is added into properties instead of sibling.

Example:

```lua
local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child/>
</root>
]])

--append comment node.
local root = document:root()
local comment_node =
  document:create_comment("This is comment!")
local child = root:children()[1]
child:add_previous_sibling(comment_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <!--This is comment!--><child/>
--</root>
```

### `append_sibling(node) -> void` {#append_sibling}

Add a new node to a receiver as the end of a sibling.
If the new node was already inserted in a document it is first unlinked from its existing context.

Example:

```lua
local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child/>
</root>
]])
local root = document:root()
local comment_node =
  document:create_comment("This is comment!")
local child = root:children()[1]
child:append_sibling(comment_node)
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<root>
--  <child/>
--<!--This is comment!--></root>
```

### `unlink() -> xmlua.Element` {#unlink}

It remove receiver from document tree.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse([[<root><child/></root>]])
local child = document:css_select("child")[1]
-- unlink element from document tree
local unlinked_node = child:unlink()

print(unlinked_node:to_xml())
-- <child/>
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root/>
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

### `set_attribute(name, value) -> void` {#set-attribute}

It set specify attribute to element.
If attribute already exist, it overrides attribute.
If attribute not exist, it makes attribute.
If `name` is `namespace_prefix:local_name`, it set the namespace to the attribute.
You can write not only `element:set_attribute(name, value)` but also `element.name = value`.

Example:

```lua
local xmlua = require("xmlua")

-- set attribute
local document = xmlua.XML.parse("<root/>")
local root = document:root()
root:set_attribute("class", "A")
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root class="A"/>


-- set attribute another way write
local document = xmlua.XML.parse("<root/>")
local root = document:root()
root.class = "A"
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root class="A"/>


-- set attribute update
local document = xmlua.XML.parse("<root value='1'/>")
local root = document:root()
root.value = "2"
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root value="2"/>


-- set attribute with namespace
local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml"/>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()
root:set_attribute("xhtml:class", "top-level")
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml" xhtml:class="top-level"/>


-- set attribute update with namespace
local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xhtml:class="top-level"/>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()
root:set_attribute("xhtml:class", "top-level-updated")
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml" xhtml:class="top-level-updated"/>
```

### `remove_attribute(name) -> void` {#remove-attribute}

It removes attribute wiht specified name.
If `name` is `xmlns:local_name`, it remove the namespace.

Example:

```lua
local xmlua = require("xmlua")

-- Remove attribute
local document = xmlua.XML.parse("<root class=\"A\"/>")
local node_set = document:search("/root")
node_set[1]:remove_attribute("class")
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root/>


--Remove attribute with namespace
local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xhtml:class="xhtml-top-level"
  xmlns:example="http://example.com/"
  example:class="example-top-level"/>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()
root:remove_attribute("xhtml:class")
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:example="http://example.com/" example:class="example-top-level"/>


-- Remove attribute with default namespace
local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<html
  xmlns="http://www.w3.org/1999/xhtml"
  class="top-level"/>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()
root:remove_attribute("class")
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <html xmlns="http://www.w3.org/1999/xhtml"/>


-- Remove namespace
local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<root xmlns:example="http://example.com/"/>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()
root:remove_attribute("xmlns:example")
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root/>

-- Remove default namespace
local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<root xmlns="http://example.com/"/>
]]
local document = xmlua.XML.parse(xml)
local root = document:root()
root:remove_attribute("xmlns")
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root/>
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
