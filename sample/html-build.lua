#!/usr/bin/env luajit

local xmlua = require("xmlua")

local tree
local document

-- Empty tree
tree = {}
document = xmlua.HTML.build(tree)
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

-- Root only document
tree = {"html"}
document = xmlua.HTML.build(tree)
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html></html>

-- Root with attributes
tree = {
  "html",
  {
    attribute1 = "value1",
    attribute2 = "value2",
  },
}
document = xmlua.HTML.build(tree)
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html attribute1="value1" attribute2="value2"></html>

-- Specify external subset with system id
local uri = "file:///usr/local/share/test.dtd"
tree = {"html"}
document = xmlua.HTML.build(tree, uri)
print(document:to_html())
-- <!DOCTYPE html SYSTEM "file:///usr/local/share/test.dtd">
-- <html></html>

-- Specify external subset with public id
local uri = "http://www.w3.org/TR/html4/strict.dtd"
local public_id = "-//W3C//DTD HTML 4.01//EN"
tree = {"html"}
document = xmlua.HTML.build(tree, uri, public_id)
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
-- <html></html>

-- Child elements
tree = {
  "html",
  {},
  {
    "child",
    {
      attribute = "child-value",
    },
  },
}
document = xmlua.HTML.build(tree)
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html>
--   <child attribute="child-value"/>
-- </html>

-- Child elements
tree = {
  "html",
  {},
  {
    "title",
    {},
    "title-text",
  },
}
document = xmlua.HTML.build(tree)
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html>
--   <title>title-text</title>
-- </html>
