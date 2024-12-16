local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestProcessingInstruction = {}

function TestProcessingInstruction.test_node_name()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8" ?>
<?xml-stylesheet href="www.test.com/test-style.xsl" type="text/xsl" ?>
<root/>
]])
  local pi = document:search("/processing-instruction()")
  luaunit.assertEquals(pi[1]:node_name(),
                       "processing-instruction")
end

function TestProcessingInstruction.test_path()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8" ?>
<?xml-stylesheet href="www.test.com/test-style.xsl" type="text/xsl" ?>
<root/>
]])
  local pi = document:search("/processing-instruction()")
  luaunit.assertEquals(pi[1]:path(),
                       "/processing-instruction('xml-stylesheet')")
end

function TestProcessingInstruction.test_set_content()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8" ?>
<?xml-stylesheet href="www.test.com/test-style.xsl" type="text/xsl" ?>
<root/>
]])
  local pi = document:search("/processing-instruction()")
  pi[1]:set_content("href=\"www.sample.com/sample-style.xsl\" type=\"text/xsl\" ")
  luaunit.assertEquals(pi[1]:content(),
                       "href=\"www.sample.com/sample-style.xsl\" type=\"text/xsl\" ")
end

function TestProcessingInstruction.test_content()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8" ?>
<?xml-stylesheet href="www.test.com/test-style.xsl" type="text/xsl" ?>
<root/>
]])
  local pi = document:search("/processing-instruction()")
  luaunit.assertEquals(pi[1]:content(),
                       "href=\"www.test.com/test-style.xsl\" type=\"text/xsl\" ")
end

function TestProcessingInstruction.test_text()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8" ?>
<?xml-stylesheet href="www.test.com/test-style.xsl" type="text/xsl" ?>
<root/>
]])
  local pi = document:search("/processing-instruction()")
  luaunit.assertEquals(pi[1]:text(),
                       "")
end

function TestProcessingInstruction.test_target()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8" ?>
<?xml-stylesheet href="www.test.com/test-style.xsl" type="text/xsl" ?>
<root/>
]])
  local pi = document:search("/processing-instruction()")
  luaunit.assertEquals(pi[1]:target(),
                       "xml-stylesheet")
end
