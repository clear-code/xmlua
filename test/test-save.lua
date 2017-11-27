local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestSave = {}

function TestSave.test_to_html()
  local html = xmlua.HTML.parse("<html></html>")
  luaunit.assertEquals(html:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html></html>
]])
end

function TestSave.test_to_html_options()
  local html = xmlua.HTML.parse("<html><head></head></html>")
  luaunit.assertEquals(html:to_html({encoding = "EUC-JP"}),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html><head><meta http-equiv="Content-Type" content="text/html; charset=EUC-JP"></head></html>
]])
end
