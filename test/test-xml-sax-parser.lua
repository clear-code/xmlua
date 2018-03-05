local luaunit = require("luaunit")
local xmlua = require("xmlua")

local ffi = require("ffi")

TestXMLSAXParser = {}

function TestXMLSAXParser.test_start_document()
  local html = [[
<?xml version="1.0" encoding="UTF-8" ?>
]]
  local parser = xmlua.XMLSAXParser.new()
  local called = false
  parser.start_document = function()
    called = true
  end

  local succeeded = parser:parse(html)
  luaunit.assertEquals({succeeded, called}, {true, true})
end

function TestXMLSAXParser.test_end_document()
  local html = [[
<?xml version="1.0" encoding="UTF-8" ?>
<xml></xml>
]]
  local parser = xmlua.XMLSAXParser.new()
  local called = false
  parser.end_document = function()
    called = true
  end

  local succeeded = parser:parse(html)
  luaunit.assertEquals({succeeded, called}, {true, false})
  succeeded = parser:finish()
  luaunit.assertEquals({succeeded, called}, {true, true})
end
