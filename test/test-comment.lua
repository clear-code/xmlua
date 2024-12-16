local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestComment = {}

function TestComment.test_node_Name()
  local document = xmlua.XML.parse([[
<root>
  <!--This is comment!-->
</root>
]])
  local comment = document:search("/root/comment()")
  luaunit.assertEquals(comment[1]:node_name(),
                       "comment")
end

function TestComment.test_path()
  local document = xmlua.XML.parse([[
<root>
  <!--This is comment!-->
</root>
]])
  local comment = document:search("/root/comment()")
  luaunit.assertEquals(comment[1]:path(),
                       "/root/comment()")
end

function TestComment.test_content()
  local document = xmlua.XML.parse([[
<root>
  <!--This is comment!-->
</root>
]])
  local comment = document:search("/root/comment()")
  luaunit.assertEquals(comment[1]:content(),
                       "This is comment!")
end

function TestComment.test_set_content()
  local document = xmlua.XML.parse([[
<root>
  <!--This is comment!-->
</root>
]])
  local comment = document:search("/root/comment()")
  comment[1]:set_content("Setting comment!")
  luaunit.assertEquals(comment[1]:content(),
                       "Setting comment!")
end

function TestComment.test_text()
  local document = xmlua.XML.parse([[
<root>
  <!--This is comment!-->
</root>
]])
  local comment = document:search("/root/comment()")
  luaunit.assertEquals(comment[1]:text(),
                       "")
end
