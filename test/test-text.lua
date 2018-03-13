local luaunit = require("luaunit")
local xmlua = require("xmlua")
local Text = require("xmlua.text")

TestText = {}

function TestText.test_path()
  local document = xmlua.XML.parse([[
<root>text</root>
]])
  local text = document:search("/root/text()")
  luaunit.assertEquals(text[1]:path(),
                       "/root/text()")
end
