---
title: xmlua.HTML
---

# `xmlua.HTML` module

## Summary

It's a class for processing a HTML document.

It has methods of the following modules:

  * [`xmlua.Document`][document]: Provides document such as HTML and XML related methods.

  * [`xmlua.Savable`][savable]: Provides HTML and XML serialization related methods.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.

It means that you can use methods in the modules.

Example:

```lua
local xmlua = require("xmlua")

local document = xmlua.HTML.parse("<html><body></body></html>")

-- Call xmlua.Document:root method
document:root() -- -> Root element
```

## Class methods

### `xmlua.HTML.parse(html) -> xmlua.HTML`

`html`: HTML string to be parsed.

It parses the given HTML and returns `xmlua.HTML` object.

The encoding of HTML is guessed.

If HTML parsing is failed, it raises an error. The error has the
following structure:

```lua
{
  message = "Error details",
}
```

Here is an example to parse HTML:

```lua
local xmlua = require("xmlua")

-- HTML to be parsed.
-- You may want to use HTML in a file. If you want to use HTML in a file,
-- you need to read HTML content from a file by yourself.
local html = [[
<html>
  <body>
    <p>Hello</p>
  </body>
</html>
]]

-- Parses HTML
local success, document = pcall(xmlua.HTML.parse, html)
if not success then
  local err = document
  print("Failed to parse HTML: " .. err.message)
  os.exit(1)
end

-- Gets the root element
local root = document:root() -- --> <html> element as xmlua.Element

-- Prints root element name
print(root:name()) -- -> html
```

## Instance methods

There are not instance methods.

Use methods of the included modules.

## See also

  * [`xmlua.Document`][document]: Provides document such as HTML and XML related methods.

  * [`xmlua.Savable`][savable]: Provides HTML and XML serialization related methods.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.


[document]:document.html

[savable]:savable.html

[searchable]:searchable.html
