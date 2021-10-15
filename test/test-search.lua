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
  luaunit.assertEquals(message:gsub("^.+:%d+: ", ""),
                       "Invalid expression\n")
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

function TestSearch.test_namespaces_default()
  local document = xmlua.XML.parse([[
<example:root xmlns:example="http://example.com/">
  <example:sub>text</example:sub>
</example:root>
]])
  luaunit.assertEquals(document:search("/example:root/example:sub")[1]:to_xml(),
                       "<example:sub>text</example:sub>")
end

function TestSearch.test_namespaces_custom()
  local document = xmlua.XML.parse([[
<example:root xmlns:example="http://example.com/">
  <example:sub>text</example:sub>
</example:root>
]])
  local namespaces = {
    {
      prefix = "e",
      href = "http://example.com/",
    }
  }
  luaunit.assertEquals(document:search("/e:root/e:sub", namespaces)[1]:to_xml(),
                       "<example:sub>text</example:sub>")
end
