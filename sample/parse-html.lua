#!/usr/bin/env luajit

local xmlua = require("xmlua")

-- HTML to be parsed
local html = [[
<html>
  <body>
    <p>Hello</p>
  </body>
</html>
]]

-- If you want to use text in a file, you need to read file content by yourself.

-- local html = io.open("example.html"):read("*all")

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
