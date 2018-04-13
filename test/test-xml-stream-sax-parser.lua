local luaunit = require("luaunit")
local xmlua = require("xmlua")

local ffi = require("ffi")

TestXMLStreamSAXParser = {}

function TestXMLStreamSAXParser.test_multiple_documents()
  local xml = [[
<root/>
<root/>
<root/>
]]
  local listener = {
    elements = {},
    errors = {},
  }
  function listener:start_element(local_name, ...)
    table.insert(self.elements, local_name)
  end
  function listener:error(error)
    table.insert(self.errors, error.message)
  end
  local parser = xmlua.XMLStreamSAXParser.new(listener)
  local parse_succeeded = parser:parse(xml)
  local finish_succeeded = parser:finish()
  luaunit.assertEquals({
                          parse_succeeded,
                          finish_succeeded,
                          listener.elements,
                          listener.errors,
                       },
                       {
                         true,
                         true,
                         {"root", "root", "root"},
                         {},
                       })
end
