local luaunit = require("luaunit")
local Document = require("xmlua.document")
local ffi = require("ffi")

TestDocument = {}

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

function TestDocument.test_build_root_namespace()
  local uri = "http://example.com/"
  local tree = {
    "example:root",
    {
      ["xmlns:example"] = uri,
    }
  }
  local document = Document.build(tree)
  luaunit.assertEquals({
                         ffi.string(document:root().node.ns.href),
                         document:to_xml(),
                       },
                       {
                         uri,
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<example:root xmlns:example="http://example.com/"/>
]]
                       })
end

function TestDocument.test_build_root_children()
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
<root class="A" id="1">This is text.<child class="B" id="2"/></root>
]])
end

function TestDocument.test_build_nested()
  local tree = {
    "root",
    {
      ["class"] = "A",
      ["id"] = "1"
    },
    "root text",
    {
      "child",
      {
        ["class"] = "B",
        ["id"] = "2"
      },
      "child text",
      {
        "grand-child",
      },
    }
  }
  local document = Document.build(tree)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root class="A" id="1">root text<child class="B" id="2">child text<grand-child/></child></root>
]])
end
