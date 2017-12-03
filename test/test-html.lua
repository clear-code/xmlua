local luaunit = require("luaunit")
local xmlua = require("xmlua")

local ffi = require("ffi")

TestHTML = {}
function TestHTML.test_parse_valid()
  local success, html = pcall(xmlua.HTML.parse, "<html></html>")
  luaunit.assertEquals(success, true)
  luaunit.assertEquals(html:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html></html>
]])
end

function TestHTML.test_parse_invalid()
  local document = xmlua.HTML.parse("<p id='a'></p><p id='a'></p>")
  luaunit.assertEquals(document:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html><body>
<p id="a"></p>
<p id="a"></p>
</body></html>
]])
  luaunit.assertEquals(document.errors,
                       {
                         {
                           code = ffi.C.XML_DTD_ID_REDEFINED,
                           domain = ffi.C.XML_FROM_VALID,
                           level = ffi.C.XML_ERR_ERROR,
                           message = "ID a already defined\n",
                           line = 1,
                         },
                       })
end

function TestHTML.test_parse_prefer_charset_meta_charset()
  local html = [[
<html>
  <head>
    <title>タイトル</title>
    <meta charset="UTF-8">
  </head>
</html>
]]
  local document = xmlua.HTML.parse(html, {prefer_charset = true})
  luaunit.assertEquals(document:search("//title"):text(),
                       "タイトル")
end

function TestHTML.test_parse_encoding_content_type()
  local html = [[
<html>
  <head>
    <title>タイトル</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
</html>
]]
  local document = xmlua.HTML.parse(html)
  luaunit.assertEquals(document:search("//title"):text(),
                       "タイトル")
end

function TestHTML.test_root()
  local html = xmlua.HTML.parse("<html></html>")
  luaunit.assertEquals(html:root():to_html(),
                       "<html></html>")
end

function TestHTML.test_parent()
  local html = xmlua.HTML.parse("<html></html>")
  luaunit.assertNil(html:parent())
end
