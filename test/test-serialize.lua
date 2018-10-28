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

function TestSave.test_to_html_encoding()
  local html = xmlua.HTML.parse("<html><head></head></html>")
  luaunit.assertEquals(html:to_html({encoding = "EUC-JP"}),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html><head><meta http-equiv="Content-Type" content="text/html; charset=EUC-JP"></head></html>
]])
end

function TestSave.test_to_xml()
  local xml = xmlua.XML.parse("<root/>")
  luaunit.assertEquals(xml:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
]])
end

function TestSave.test_to_xml_encoding()
  local xml = xmlua.XML.parse("<root/>")
  luaunit.assertEquals(xml:to_xml({encoding = "EUC-JP"}),
                       [[
<?xml version="1.0" encoding="EUC-JP"?>
<root/>
]])
end

function TestSave.test_escape()
  local entities = {
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ["&"] = "&amp;",
    ["\n"] = "&#xA;",
  }
  local function escape(out_bytes, out_length, in_bytes, in_length)
    local in_index = 0
    local out_index = 0
    local n_in_bytes = in_length[0]
    local n_out_bytes = out_length[0]
    while in_index < n_in_bytes and out_index < n_out_bytes do
      local entity = entities[string.char(in_bytes[in_index])]
      if entity then
        local n_entity_bytes = entity:len()
        if out_index + n_entity_bytes >= n_out_bytes then
          break
        end
        local i
        for i = 1, n_entity_bytes do
          out_bytes[out_index] = entity:byte(i, i)
          out_index = out_index + 1
        end
        in_index = in_index + 1
      else
        out_bytes[out_index] = in_bytes[in_index]
        out_index = out_index + 1
        in_index = in_index + 1
      end
    end
    in_length[0] = in_index
    out_length[0] = out_index
    return 0
  end
  local xml = xmlua.XML.parse("<root>before\nafter</root>")
  luaunit.assertEquals(xml:to_xml({escape = escape}),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>before&#xA;after</root>
]])
end
