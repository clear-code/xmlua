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
  -- TODO: Use to_xml()
  luaunit.assertEquals(node_set[1]:to_html(),
                       "<sub class=\"A\">1</sub>")
end
