#!/usr/bin/env luajit

local xmlua = require("xmlua")

-- XML to be parsed
local xml = [[
<root>
  <sub/>
</root>
]]

-- If you want to parse text in a file,
-- you need to read file content by yourself.

-- local xml = io.open("example.xml"):read("*all")


-- Parses XML
local success, document = pcall(xmlua.XML.parse, xml)
if not success then
  local err = document
  print("Failed to parse XML: " .. err.message)
  os.exit(1)
end

-- Gets the root element
local root = document:root() -- --> <root> element as xmlua.Element

-- Prints the root element name
print(root:name()) -- -> root
