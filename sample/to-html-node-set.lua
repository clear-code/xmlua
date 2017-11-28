#!/usr/bin/env luajit

local xmlua = require("xmlua")

local document = xmlua.HTML.parse([[
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>World</body>
</html>
]])

-- All elements under <html> (<head> and <body>)
local node_set = document:search("/html/*")

-- Serializes all elements as HTML and concatenates serialized HTML
print(node_set:to_html())
-- <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
--    <title>Hello</title>
--  </head><body>World</body>

-- FYI: <head> serialization
print(node_set[1]:to_html())
-- <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
--    <title>Hello</title>
--  </head>

-- FYI: <body> serialization
print(node_set[2]:to_html())
-- <body>World</body>
