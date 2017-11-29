#!/usr/bin/env luajit

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
end
