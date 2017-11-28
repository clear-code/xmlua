#!/usr/bin/env luajit

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
