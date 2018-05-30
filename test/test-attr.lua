local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestAttr = {}

function TestAttr.test_path()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child id="1"/>
</root>
]])
  local attr = document:search("/root/child/@id")
  luaunit.assertEquals(attr[1]:path(),
                       "/root/child/@id")
end
