local luaunit = require("luaunit")
local HTML = require("xmlua.html")
local ffi = require("ffi")

TestHTMLBuild = {}

function TestHTMLBuild.test_empty()
  local document = HTML.build({})
  luaunit.assertEquals(document:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">

]])
end

function TestHTMLBuild.test_empty_root()
  local document = HTML.build({"html"})
  luaunit.assertEquals(document:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html></html>
]])
end

function TestHTMLBuild.test_empty_root_dtd_systemid()
  local uri = "file:///usr/local/share/test.dtd"
  local document = HTML.build({"html"}, uri)
  luaunit.assertEquals({
                          ffi.string(document.raw_document.intSubset.SystemID),
                          document:to_html()
                       },
                       {
                         uri,
                         [[
<!DOCTYPE html SYSTEM "file:///usr/local/share/test.dtd">
<html></html>
]]
                       })
end

function TestHTMLBuild.test_empty_root_dtd_publicid()
  local uri = "http://www.w3.org/TR/html4/strict.dtd"
  local public_id = "-//W3C//DTD HTML 4.01//EN"
  local document = HTML.build({"html"}, uri, public_id)
  luaunit.assertEquals({
                         ffi.string(document.raw_document.intSubset.SystemID),
                         ffi.string(document.raw_document.intSubset.ExternalID),
                         document:to_html()
                       },
                       {
                         uri,
                         public_id,
                         [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html></html>
]]
                       })
end

function TestHTMLBuild.test_root_children()
  local tree = {
    "html",
    {},
    {
      "body",
    },
  }
  local document = HTML.build(tree)
  luaunit.assertEquals(document:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html><body></body></html>
]])
end

function TestHTMLBuild.test_nested()
  local tree = {
    "html",
    {
      ["lang"] = "ja",
    },
    {
      "title",
      {},
      "This is Test Page!",
    }
  }
  local document = HTML.build(tree)
  luaunit.assertEquals(document:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html lang="ja"><title>This is Test Page!</title></html>
]])
end

function TestHTMLBuild.test_texts()
  local tree = {
    "html",
    {},
    {
      "div",
      {
        ["class"] = "A"
      },
      "text1",
      "text2",
    },
  }
  local document = HTML.build(tree)
  luaunit.assertEquals(document:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html><div class="A">text1text2</div></html>
]])
end
