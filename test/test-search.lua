local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestSearch = {}

function TestSearch.test_invalid()
  local document = xmlua.XML.parse([[
<root>
  <sub class="A"/>
  <sub class="A"/>
  <sub class="B"/>
</root>
]])
  local success, message = pcall(function() document:search("") end)
  luaunit.assertEquals(success, false)
  luaunit.assertEquals(message,
                       "./xmlua/searchable.lua:59: Invalid expression\n")
end

function TestSearch.test_no_match()
  local document = xmlua.XML.parse([[
<root>
  <sub class="A"/>
  <sub class="A"/>
  <sub class="B"/>
</root>
]])
  luaunit.assertEquals(#document:search("/nonexistent"),
                       0)
end

function TestSearch.test_no_node_set()
  local document = xmlua.XML.parse([[
<root>
  <sub class="A"/>
  <sub class="A"/>
  <sub class="B"/>
</root>
]])
  luaunit.assertEquals(#document:search(".."),
                       0)
end

function TestSearch.test_multiple()
  local document = xmlua.XML.parse([[
<root>
  <sub class="A"/>
  <sub class="A"/>
  <sub class="B"/>
</root>
]])
  luaunit.assertEquals(#document:search("/root/sub[@class='A']"),
                       2)
end

function TestSearch.test_node()
  local document = xmlua.XML.parse([[
<root>
  <sub>
    <subsub/>
  </sub>
</root>
]])
  local node = document:search("/root/sub")[1]
  luaunit.assertEquals(node:search("subsub")[1]:to_xml(),
                       "<subsub/>")
end

function TestSearch.test_text()
  local document = xmlua.XML.parse([[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]])
  -- TODO: Support text nodes
  luaunit.assertEquals(document:search("/root/sub/text()"):content(),
                       "text1text2text3")
end
