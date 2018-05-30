local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestAttr = {}

function TestAttr.test_path()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root id="1"/>
]])
  local attr = document:search("/root/@id")
  luaunit.assertEquals(attr[1]:path(),
                       "/root/@id")
end

function TestAttr.test_content()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root id="1"/>
]])
  local attr = document:search("/root/@id")
  luaunit.assertEquals(attr[1]:content(),
                       "1")
end

function TestAttr.test_name()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root id="1"/>
]])
  local attr = document:search("/root/@id")
  luaunit.assertEquals(attr[1]:name(),
                       "id")
end
