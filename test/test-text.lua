local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestText = {}

function TestText.test_path()
  local document = xmlua.XML.parse([[
<root>text</root>
]])
  local text = document:search("/root/text()")
  luaunit.assertEquals(text[1]:path(),
                       "/root/text()")
end

function TestText.test_concat()
  local document =
    xmlua.XML.build({"root", {}, "Text1"})
  local text_nodes = document:search("/root/text()")
  text_nodes[1]:concat("Text2")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>Text1Text2</root>
]])
end

function TestText.test_merge()
  local document = xmlua.XML.parse([[
<root>
  Text:
  <child>This is child</child>
</root>
]])
  local text1 = document:search("/root/text()")
  local text2 = document:search("/root/child/text()")

  text1[1]:merge(text2[1])
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  Text:
  This is child<child/>
</root>
]])
end

function TestText.test_merge_receiver_nil()
  local document = xmlua.XML.parse([[
<root>
  Text:
  <child>This is child</child>
</root>
]])
  local text1 = document:search("/root/text()")
  local text2 = document:search("/root/child/text()")

  text1[1].node = nil
  luaunit.assertErrorMsgEquals("./xmlua/text.lua:29: Already freed reciver node",
                               text1[1].merge, text1[1], text2[1])
end
