---
title: Tutorial
---

# Tutorial

This document describes how to use XMLua step by step. If you don't install XMLua yet, [install][install] XMLua before you read this document.

## Parse a document

You need to parse document at first to use XMLua. XMLua supports HTML document and XML document.

You can use [`xmlua.HTML.parse`][html-parse] to parse HTML.

Example:

```lua
-- Requires "xmlua" module
local xmlua = require("xmlua")

local html = [[
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>
    <p>World</p>
  </body>
</html>
]]

-- Parses HTML
local document = xmlua.HTML.parse(html)

-- Serializes to HTML
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html>
--   <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
--     <title>Hello</title>
--   </head>
--   <body>
--     <p>World</p>
--   </body>
-- </html>
```

You can use [`xmlua.XML.parse`][xml-parse] to parse XML.

Example:

```lua
-- Requires "xmlua" module
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]]

-- Parses XML
local document = xmlua.XML.parse(xml)

-- Serializes to XML
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub>text1</sub>
--   <sub>text2</sub>
--   <sub>text3</sub>
-- </root>
```

You must pass HTML or XML as `string`. If you want to parse HTML or XML in a file, you need to read it by yourself.

Example:

```lua
local xmlua = require("xmlua")

local xml_file = io.open("example.xml")
local xml = xml_file:read("*all")
xml_file:close()

local document = xmlua.XML.parse(xml)
```

`xmlua.HTML.parse` and `xmlua.XML.parse` may fail. For example, they fail with invalid document. If they fail, they raises an error.

Here is the error structure:

```lua
{
  message = "Error details",
}
```

If you need to assume that document may be invalid, you need to handle error with `pcall`.

Example:

```lua
local xmlua = require("xmlua")

local invalid_xml = "<root>"

-- Parses invalid XML
local success, document = pcall(xmlua.XML.parse, invalid_xml)

if success then
  print("Succeeded to parse XML")
else
  -- If pcall returns not success, the second return value is error
  -- object not document.
  local err = document
  print("Failed to parse XML: " .. err.message)
  -- -> Failed to parse XML: Premature end of data in tag root line 1
end
```

Both parsed HTML and parsed XML are [`xmlua.Document`][document] object in XMLua. You can handle both of them in the same way.

## Search elements

You can use [XPath][xpath] to search elements. You can use [`xmlua.Searchable:search`][searchable-search] method for it.

[`xmlua.Document`][document] can use the method.

The method returns a [`xmlua.NodeSet`][node-set] object. It's a normal array with convenience methods. You can use normal array features such as `#` and `[]`.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Searches all <sub> elements under the <root> element
local all_subs = document:search("/root/sub")

-- You can use "#" for getting the number of matched nodes
print(#all_subs) -- -> 3

-- You can access the N-th node by "[]".
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

[`xmlua.NodeSet`][node-set] object can also use `search` method. It means that you can search against searched result.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub class="A"><subsub1/></sub>
  <sub class="B"><subsub2/></sub>
  <sub class="A"><subsub3/></sub>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Searches all <sub class="A"> elements
local class_a_subs = document:search("//sub[@class='A']")

-- Searches all elements under <sub class="A"> elements
local subsubs_in_class_a = class_a_subs:search("*")

print(#subsubs_in_class_a) -- -> 2

-- It's /root/sub[@class="A"]/subsub1
print(subsubs_in_class_a[1]:to_xml())
-- <subsub1/>

-- It's /root/sub[@class="A"]/subsub3
print(subsubs_in_class_a[2]:to_xml())
-- <subsub3/>
```

The `search` method is [`xmlua.NodeSet:search`][node-set-search]. It's not [`xmlua.Searchable:search`][searchable-search] method.

You can also use [`xmlua.Searchable:search`][searchable-search] method against element.

Example:

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]]

local document = xmlua.XML.parse(xml)

-- Searches the <root> element
local roots = document:search("/root")
local root = roots[1]

-- Searches all <sub> elements under the <root> element
local all_subs = root:search("sub")

-- You can use "#" for getting the number of matched nodes
print(#all_subs) -- -> 3

-- You can access the N-th node by "[]".
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

`search` may fail. For example. it fails with invalid XPath. If it fails, it raises an error.

Here is the error structure:

```lua
{
  message = "Error details",
}
```

If you need to assume that XPath may be invalid, you need to handle error with `pcall`.

Example:

```lua
local xmlua = require("xmlua")

local xml = "<root/>"

local document = xmlua.XML.parse(xml)

local invalid_xpath = "..."
local success, node_set = pcall(function()
  return document:search(invalid_xpath)
end)

if success then
  print("Succeeded to search by XPath")
else
  -- If pcall returns not success, the second return value is error
  -- object not node set.
  local err = node_set
  print("Failed to search by XPath: " .. err.message)
  -- -> Failed to search by XPath: Invalid expression
end
```

## Get attribute value

You need to get [`xmlua.Element`][element] object to get attribute value in element.

Normally, you can get `xmlua.Element` by [`xmlua.Document:root`][document-root] or [`xmlua.Searchable:search`][searchable-search].

`xmlua.Document:root` returns the root element of the document.

`xmlua.Searchable:search` returns elements as [`xmlua.NodeSet`][node-set]. You can get the first element by `node_set[1]`.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root class='A'/>")

-- Gets the root element: <root>
local root = document:root()

-- Gets the root element: <root>
local root = document:search("/root")[1]
```

You can get attribute value by one of the followings:

  * `element.attribute_name`: Dot syntax.

  * `element["attribute_name"]`: `[]` syntax.

  * `element:get_attribute("attribute_name")`: Method syntax.

Normally, dot syntax and `[]` syntax are recommended.

If attribute name is valid Lua identifier such as "`class`", dot syntax is recommended.

If attribute name isn't valid Lua identifier such as "`xml:lang`", `[]` syntax is recommended.

If attribute name conflicts with method names available in `xmlua.Element` such as `search` and `parent`, method syntax is recommended.

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

If the specified attribute doesn't exist, `nil` is returned.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root class='A'/>")
local root = document:root()

-- Returns nil for nonexistent attribute name
print(root.nonexistent)
-- -> nil
```

If the attribute what you find has namespace, you can use `"namespace-prefix:local-name"` syntax attribute name such as `"xml:lang"`. In this case, you can't use dot syntax because `":"` is included in attribute name.

If the specified namespace prefix doesn't exist, the whole specified attribute name is treated as attribute name instead of namespace URI and local name.

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

## Get elements

You can get the sibling elements by [`xmlua.Element:previous`][element-previous] and [`xmlua.Element:next`][element-next].

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

-- Gets the next sibling element of <sub2>
print(sub2:next():to_xml())
-- <sub3/>
```

If there are no sibling elements, they returns `nil`.

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
local sub1 = document:search("/root/sub1")[1]
local sub3 = document:search("/root/sub3")[1]

-- Gets the previous sibling element of <sub1>
print(sub1:previous())
-- nil

-- Gets the next sibling element of <sub3>
print(sub3:next():to_xml())
-- nil
```

You can get the parent element by [`xmlua.Element:parent`][element-parent].

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

```

If the element is the root element, it returns [`xmlua.Document`][document].

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

-- Gets the parent of <root>: xmlua.Document
print(root:parent():to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3/>
-- </root>

```

[`xmlua.Document:parent`][document-parent] also exists. It always returns `nil`. It just exist for consistent API.

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

-- Gets the parent of document
print(document:parent())
-- nil
```

## Multithread

You can use XMLua with multiple threads. But you need more codes to do it.

You must call [`xmlua.init()`][xmlua-init] in the main thread before you create any threads that use xmlua.

Example:

```lua
local xmlua = require("xmlua")

-- You must call xmlua.init() in main thread before you create threads
-- when you use xmlua with multiple threads.
xmlua.init()

local thread = require("cqueues.thread")
-- ...
```

You can call [`xmlua.cleanup()`][xmlua-cleanup] in the main thread after you finish all threads that use XMLua and you finish all MXLua use.

Example:

```lua
local xmlua = require("xmlua")

xmlua.init()

local thread = require("cqueues.thread")
-- ...

-- You can call xmlua.cleanup() in main thread to free all resources
-- used by xmlua. You must ensure that all threads are finished and
-- all xmlua related objects aren't used anymore.
xmlua.cleanup()

os.exit()
```

If you work on GNU/Linux and your LuaJIT isn't linked with pthread, `require("xmlua")` isn't thread safe. Here are solutions:

  * Link `libpthread.so.0` by `LD_PRELOAD` environment variable.

  * Don't execute `require("xmlua")` at the same time.

Here are example command lines to use `LD_PRELOAD`.

Debian GNU/Linux and Ubuntu:

```console
% LD_PRELOAD=/lib/x86_64-linux-gnu/libpthread.so.o luajit XXX.lua
```

CentOS:

```console
% LD_PRELOAD=/lib64/libpthread.so.o luajit XXX.lua
```

If you use [cqueues][cqueues], you can use connection returned by `cqueues.thread.start`.

Example:

```lua
local xmlua = require("xmlua")
xmlua.init()

local thread = require("cqueues.thread")

local n = 10

local workers = {}
local connections = {}

for i = 1, n do
  local worker, connection = thread.start(function(connection)
    -- require("xmlua") isn't thread safe.
    local xmlua = require("xmlua")
    -- Notify that require("xmlua") is finished.
    connection:write("ready\n")

    for job in connection:lines("*l") do
      -- local html = ...
      -- local document = xmlua.HTML.parse(html)
      -- document:search("...")
    end
  end)
  -- Wait until require("xmlua") is finished.
  connection:read("*l")
  table.insert(workers, worker)
  table.insert(connections, connection)
end

for _, connection in ipairs(connections) do
  -- Put jobs to workers
  connection:write("Job1\n")
  connection:write("Job2\n")
  -- ...
end

for _, connection in ipairs(connections) do
  -- Finish providing jobs
  connection:close()
end

for _, worker in ipairs(workers) do
  worker:join()
end

xmlua.cleanup()
```

## Next step

Now, you knew all major XMLua features! If you want to understand each feature, see [reference manual][reference] for each feature.


[install]:../install/

[html-parse]:../reference/html.html#parse

[xml-parse]:../reference/xml.html#parse

[document]:../reference/document.html

[xpath]:https://www.w3.org/TR/xpath/

[searchable-search]:../reference/searchable.html#search

[node-set]:../reference/node-set.html

[node-set-search]:../reference/node-set.html#search

[element]:../reference/element.html

[document-root]:../reference/document.html#root

[element-previous]:../reference/element.html#previous

[element-next]:../reference/element.html#next

[element-parent]:../reference/element.html#parent

[document-parent]:../reference/document.html#parent

[xmlua-init]:../reference/xmlua.html#init

[xmlua-cleanup]:../reference/xmlua.html#cleanup

[cqueues]:http://25thandclement.com/~william/projects/cqueues.html

[reference]:../reference/
