local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestNodeSet = {}

function TestNodeSet.test_nth()
  local document = xmlua.XML.parse([[
<root>
  <sub class="A">1</sub>
  <sub class="A">2</sub>
  <sub class="B">3</sub>
</root>
]])
  local node_set = document:search("/root/sub[@class='A']")
  luaunit.assertEquals(node_set[1]:to_xml(),
                       "<sub class=\"A\">1</sub>")
end

function TestNodeSet.test_to_xml()
  local document = xmlua.XML.parse([[
<root>
  <sub class="A">1</sub>
  <sub class="A">2</sub>
  <sub class="B">3</sub>
</root>
]])
  local node_set = document:search("/root/sub[@class='A']")
  luaunit.assertEquals(node_set:to_xml(),
                       "<sub class=\"A\">1</sub>" ..
                       "<sub class=\"A\">2</sub>")
end

function TestNodeSet.test_to_html()
  local document = xmlua.HTML.parse([[
<html>
  <body>
    <p>paragraph1</p>
    <p>paragraph2</p>
    <p>paragraph3</p>
  </body>
</html>
]])
  local node_set = document:search("//p")
  luaunit.assertEquals(node_set:to_html(),
                       "<p>paragraph1</p>" ..
                       "<p>paragraph2</p>" ..
                       "<p>paragraph3</p>")
end
