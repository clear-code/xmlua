local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestHTML = {}
function TestHTML:test_parse_valid()
  local success, html = pcall(xmlua.HTML.parse, "<html></html>")
  luaunit.assertEquals(success, true)
  luaunit.assertEquals(html:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html></html>
]])
end

function TestHTML:test_parse_invalid()
  local success, err = pcall(xmlua.HTML.parse, " ")
  luaunit.assertEquals(success, false)
  luaunit.assertEquals(err, {message="Document is empty\n"})
end
