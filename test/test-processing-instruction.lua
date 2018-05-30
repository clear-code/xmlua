local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestProcessingInstruction = {}

function TestProcessingInstruction.test_path()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8" ?>
<?xml-stylesheet href="www.test.com/test-style.xsl" type="text/xsl" ?>
<root></root>
]])
  local pi = document:search("/processing-instruction()")
  luaunit.assertEquals(pi[1]:path(),
                       "/processing-instruction('xml-stylesheet')")
end