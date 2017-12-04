#!/usr/bin/env luajit

local xmlua = require("xmlua")

-- Invalid HTML. "&" is invalid.
local html = [[
<html>
  <body><p>&</p></body>
</html>
]]

-- Parses HTML loosely
local document = xmlua.HTML.parse(html)

-- "&" is parsed as "&amp;"
print(document:search("//body"):to_html())
-- <body><p>&amp;<p/></body>

for i, err in ipairs(document.errors) do
  print("Error" .. i .. ":")
  print("Line=" .. err.line .. ": " .. err.message)
  -- Line=2: htmlParseEntityRef: no name
end
