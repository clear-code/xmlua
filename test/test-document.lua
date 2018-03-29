local luaunit = require("luaunit")
local Document = require("xmlua.document")

TestDocument = {}

function TestDocument.test_build()
  local doc_tree =
  {
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
  local document = Document.build(doc_tree)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root id="1" class="A">This is text.<child id="2" class="B"/></root>
]])
end
