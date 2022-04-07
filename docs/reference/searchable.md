---
title: xmlua.Searchable
---

# `xmlua.Searchable` module

## Summary

It provides features that search nodes by [XPath][xpath].

## Methods

### `search(xpath[, namespace]) -> xmlua.NodeSet` {#search}

It searches nodes by XPath and returns as [`xmlua.NodeSet`][node-set] object.

If the receiver is a [`xmlua.Document`][document], the context node in XPath is the root node.

If the receiver is a [`xmlua.Element`][element], the context node in XPath is the element. It means that "`.`" XPath is the receiver element.

`xpath`: XPath to search nodes as `string`.
`namespace`: Customized namespace. If you use the default namespace, you must omit this argument.

If XPath searching is failed, it raises an error.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Searches all sub elements under the <root> element
local all_subs = document:search("/root/*")

-- You can use "#" for getting the number of matched nodes
print(#all_subs) -- -> 3

-- You can access the N-th node by "[]".
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

You can search from an element.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Root element
local root = document:root()

-- Searches all sub elements under the <root> element
local all_subs = root:search("*")

-- You can use "#" for getting the number of matched nodes
print(#all_subs) -- -> 3

-- You can access the N-th node by "[]".
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

You can also search document with namespace.
If you want to use the default namespace, you must specify the namespace explicitly as below.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<example:root xmlns:example="http://example.com/">
  <example:sub>text</example:sub>
</example:root>
]]

local document = xmlua.XML.parse(xml)

local example_sub = document:search("/example:root/example:sub")
print(example_sub[1]:to_xml()) -- -> <example:sub>text</example:sub>
```

You can also use customize the namespace as below.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<example:root xmlns:example="http://example.com/">
  <example:sub>text</example:sub>
</example:root>
]]

local namespaces = {
  {
    prefix = "e",
    href = "http://example.com/",
  }
}

local document = xmlua.XML.parse(xml)

local example_sub = document:search("/e:root/e:sub", namespace)
print(example_sub[1]:to_xml()) -- -> <example:sub>text</example:sub>
```

### `xpath_search(xpath) -> xmlua.NodeSet` {#xpath-search}

It's an alias of [`search`][search].

### `css_select(css_selectors) -> xmlua.NodeSet` {#css-select}

It searches nodes by [CSS Selectors][css-selectors] and returns as [`xmlua.NodeSet`][node-set] object.

If the receiver is a [`xmlua.Document`][document], the context node in CSS Selectors is the root node.

If the receiver is a [`xmlua.Element`][element], the context node in CSS Selectors is the element. It means that the current element is the receiver element.

`css_selectors`: CSS Selectors to search nodes as `string`.

If CSS Selectors is invalid, it raises an error.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Searches all sub elements under the <root> element
local all_subs = document:css_select("root *")

-- You can use "#" for getting the number of matched nodes
print(#all_subs) -- -> 3

-- You can access the N-th node by "[]".
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

You can search from an element.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1>text1</sub1>
  <sub2>text2</sub2>
  <sub3>text3</sub3>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Root element
local root = document:root()

-- Searches all sub elements under the <root> element
local all_subs = root:css_select("*")

-- You can use "#" for getting the number of matched nodes
print(#all_subs) -- -> 3

-- You can access the N-th node by "[]".
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

## See also

  * [XPath][xpath]: The XPath specification.

  * [`xmlua.Document`][document]: The class for HTML document and XML document.

  * [`xmlua.Element`][element]: The class for element node.

  * [`xmlua.NodeSet`][node-set]: The class for multiple nodes.


[xpath]:https://www.w3.org/TR/xpath/

[search]:#search

[css-selectors]:https://www.w3.org/TR/selectors-3/

[document]:document.html

[element]:element.html

[node-set]:node-set.html
