# README

## Name

XMLua

## Description

XMLua is a Lua library for processing XML and HTML. It's based on
[libxml2](http://xmlsoft.org/). It uses LuaJIT's FFI module.

XMLua provides user-friendly API instead of low-level libxml2 API.
The user-friendly API is implemented top of low-level libxml2 API.

## Dependencies

  * LuaJIT

  * libxml2

## Install

```console
% luarocks install xmlua
```

## Usage

...

## API

### Internal modules

The following modules aren't exported into public API but you can use
them via public classes such as `xmlua.HTML` and `xmlua.XML`:

  * `xmlua.Document`

  * `xmlua.Savable`

  * `xmlua.Searchable`

#### `xmlua.Document`

It provides common features for HTML document and XML document.

##### `root() -> xmlua.Element`

It returns the root element.

#### `xmlua.Savable`

...

#### `xmlua.Searchable`

..

### public Classes

#### `xmlua.HTML`

It has methods of the following modules:

  * `xmlua.Document`

  * `xmlua.Savable`

  * `xmlua.Searchable`

It means that you can use methods in the modules. For example:

```lua
-- Call `xmlua.Document.root` method
html:root() -- -> Root element
```

##### `xmlua.HTML.parse(html) -> xmlua.HTML`

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

## Authors

  * Horimoto Yasuhiro \<horimoto@clear-code.com\>

  * Kouhei Sutou \<kou@clear-code.com\>

## License

MIT. See LICENSE for details.
