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

function TestNodeSet.test_search()
  local document = xmlua.XML.parse([[
<root>
  <sub>
    <subsub>1</subsub>
    <subsub>2</subsub>
    <subsub>3</subsub>
  </sub>
</root>
]])
  local sub_node_set = document:search("/root/sub")
  luaunit.assertEquals(sub_node_set:search("subsub"):to_xml(),
                       "<subsub>1</subsub>" ..
                       "<subsub>2</subsub>" ..
                       "<subsub>3</subsub>")
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

function TestNodeSet.test_content()
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
  luaunit.assertEquals(node_set:content(),
                       "paragraph1" ..
                       "paragraph2" ..
                       "paragraph3")
end

function TestNodeSet.test_text()
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
  luaunit.assertEquals(node_set:text(),
                       node_set:content())
end
