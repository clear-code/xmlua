local luaunit = require("luaunit")
local Document = require("xmlua.document")

TestDocument = {}

function TestDocument.test_build()
  local tree = {
    "root",
    {
      ["class"] = "A",
      ["id"] = "1"
    },
    "This is text.",
    {
      "child",
      {
        ["class"] = "B",
        ["id"] = "2"
      }
    }
  }
  local document = Document.build(tree)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root id="1" class="A">This is text.<child class="B" id="2"/></root>
]])
end

function TestDocument.test_build_empty()
  local document = Document.build({})
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
]])
end

function TestDocument.test_build_empty_root()
  local document = Document.build({"root"})
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
]])
end
