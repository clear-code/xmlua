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

-- Serializes as HTML
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html>
--   <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
--     <title>Hello</title>
--   </head>
--   <body>World</body>
-- </html>

-- Serializes as EUC-JP encoded HTML
print(document:to_html({encoding = "EUC-JP"}))
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html>
--   <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
--     <title>Hello</title>
--   </head>
--   <body>World</body>
-- </html>

-- Serializes <body> element as HTML
print(document:search("/html/body")[1]:to_html())
-- <body>World</body>

-- Serializes elements under <html> (<head> and <body>) as HTML
print(document:search("/html/*"):to_html())
-- <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
--    <title>Hello</title>
--  </head><body>World</body>
