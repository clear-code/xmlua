local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestXML = {}
function TestXML:test_parse_valid()
  local success, xml = pcall(xmlua.XML.parse, "<html/>")
  luaunit.assertEquals(success, true)
  luaunit.assertEquals(xml:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html></html>
]])
end

function TestXML:test_parse_invalid()
  local success, err = pcall(xmlua.XML.parse, " ")
  luaunit.assertEquals(success, false)
  luaunit.assertEquals(err, {message="Document is empty\n"})
end
