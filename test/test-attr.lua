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

function TestAttr.test_set_content()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root id="1"/>
]])
  local attr = document:search("/root/@id")
  attr[1]:set_content("345")
  luaunit.assertEquals(attr[1]:content(),
                       "345")
end

function TestAttr.test_get_owner_element()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root id="1"/>
]])
  local attr = document:search("/root/@id")
  local owner_element = attr[1]:get_owner_element()
  luaunit.assertEquals({
                         owner_element:name(),
                         owner_element:path()
                       },
                       {
                         "root",
                         "/root"
                       })
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
