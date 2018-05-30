local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestComment = {}

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
