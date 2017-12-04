local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestXML = {}
function TestXML.test_parse_valid()
  local success, xml = pcall(xmlua.XML.parse, "<html/>")
  luaunit.assertEquals(success, true)
  luaunit.assertEquals(xml:to_html(),
                       "<html></html>\n")
end

function TestXML.test_parse_invalid()
  local success, message = pcall(xmlua.XML.parse, " ")
  luaunit.assertEquals(success, false)
  luaunit.assertEquals(message,
                       "./xmlua/xml.lua:18: Failed to parse XML: " ..
                         "Start tag expected, '<' not found\n")
end

function TestXML.test_root()
  local xml = xmlua.XML.parse("<root><child/></root>")
  luaunit.assertEquals(xml:root():to_xml(),
                       [[
<root>
  <child/>
</root>]])
end

function TestXML.test_parent()
  local xml = xmlua.XML.parse("<root><child/></root>")
  luaunit.assertNil(xml:parent())
end
