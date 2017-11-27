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
  local success, err = pcall(xmlua.XML.parse, " ")
  luaunit.assertEquals(success, false)
  luaunit.assertEquals(err, {message = "Start tag expected, '<' not found\n"})
end

function TestXML.test_root_element()
  local xml = xmlua.XML.parse("<root><child/></root>")
  luaunit.assertEquals(xml:root_element():to_xml(),
                       [[
<root>
  <child/>
</root>]])
end
