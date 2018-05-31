local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestCDATASection = {}

function TestCDATASection.test_path()
  local document = xmlua.XML.parse([=[
<root><![CDATA[This is <CDATA>]]></root>
]=])
  local cdata_section = document:search("/root/text()")
  luaunit.assertEquals(cdata_section[1]:path(),
                       "/root/text()")
end

function TestCDATASection.test_content()
  local document = xmlua.XML.parse([=[
<root><![CDATA[This is <CDATA>]]></root>
]=])
  local cdata_section = document:search("/root/text()")
  luaunit.assertEquals(cdata_section[1]:content(),
                       "This is <CDATA>")
end
