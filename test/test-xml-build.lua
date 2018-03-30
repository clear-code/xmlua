local luaunit = require("luaunit")
local XML = require("xmlua.xml")
local ffi = require("ffi")

TestXMLBuild = {}

function TestXMLBuild.test_empty()
  local document = XML.build({})
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
]])
end

function TestXMLBuild.test_empty_root()
  local document = XML.build({"root"})
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
]])
end

function TestXMLBuild.test_root_namespace()
  local uri = "http://example.com/"
  local tree = {
    "example:root",
    {
      ["xmlns:example"] = uri,
    }
  }
  local document = XML.build(tree)
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

function TestXMLBuild.test_root_children()
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
  local document = XML.build(tree)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root class="A" id="1">This is text.<child class="B" id="2"/></root>
]])
end

function TestXMLBuild.test_nested()
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
  local document = XML.build(tree)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root class="A" id="1">root text<child class="B" id="2">child text<grand-child/></child></root>
]])
end

function TestXMLBuild.test_texts()
  local tree = {
    "root",
    {},
    "text1",
    "text2",
    {
      "child",
    },
    "text3",
  }
  local document = XML.build(tree)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>text1text2<child/>text3</root>
]])
end
