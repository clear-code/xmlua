local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestElement = {}

function TestElement.test_to_html()
  local document = xmlua.XML.parse([[
<html>
  <head>
    <title>Title</title>
  </head>
</html>
]])
  local node_set = document:search("//title")
  luaunit.assertEquals(node_set[1]:to_html(),
                       "<title>Title</title>")
end

function TestElement.test_to_xml()
  local document = xmlua.XML.parse([[<root/>]])
  local node_set = document:search("/root")
  luaunit.assertEquals(node_set[1]:to_xml(),
                       "<root/>")
end

function TestElement.test_previous()
  local document = xmlua.XML.parse([[<root><child1/><child2/></root>]])
  local child2 = document:search("/root/child2")[1]
  luaunit.assertEquals(child2:previous():name(),
                       "child1")
end

function TestElement.test_previous_first()
  local document = xmlua.XML.parse([[<root><child1/><child2/></root>]])
  local child1 = document:search("/root/child1")[1]
  luaunit.assertNil(child1:previous())
end

function TestElement.test_next()
  local document = xmlua.XML.parse([[<root><child1/><child2/></root>]])
  local child1 = document:search("/root/child1")[1]
  luaunit.assertEquals(child1:next():name(),
                       "child2")
end

function TestElement.test_next_last()
  local document = xmlua.XML.parse([[<root><child1/><child2/></root>]])
  local child2 = document:search("/root/child2")[1]
  luaunit.assertNil(child2:next())
end

function TestElement.test_parent()
  local document = xmlua.XML.parse([[<root><child/></root>]])
  local child = document:search("/root/child")[1]
  luaunit.assertEquals(child:parent():name(),
                       "root")
end

function TestElement.test_parent_root()
  local document = xmlua.XML.parse([[<root><child/></root>]])
  local root = document:root()
  luaunit.assertEquals(root:parent():to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child/>
</root>
]])
end

function TestElement.test_children()
  local document = xmlua.XML.parse([[
<root>
  text1
  <child1/>
  text2
  <child2/>
  text3
</root>
]])
  local root = document:root()
  luaunit.assertEquals(root:children():to_xml(),
                       "<child1/><child2/>")
end

function TestElement.test_content()
  local document = xmlua.XML.parse([[
<root>
  text1
  <child1>text1-1</child1>
  text2
  <child2>text2-1</child2>
  text3
</root>
]])
  local root = document:root()
  luaunit.assertEquals(root:content(),
                       [[

  text1
  text1-1
  text2
  text2-1
  text3
]])
end

function TestElement.test_text()
  local document = xmlua.XML.parse([[
<root>
  text1
  <child1>text1-1</child1>
  text2
  <child2>text2-1</child2>
  text3
</root>
]])
  local root = document:root()
  luaunit.assertEquals(root:text(),
                       root:content())
end

function TestElement.test_append_element()
  local document = xmlua.XML.parse("<root/>")
  local root = document:root()
  local child = root:append_element("child")
  luaunit.assertEquals({
                         child:to_xml(),
                         document:to_xml(),
                       },
                       {
                       [[<child/>]],
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child/>
</root>
]],})
end

function TestElement.test_append_element_with_attribute()
  local document = xmlua.XML.parse("<root/>")
  local root = document:root()
  local child = root:append_element("child", {id="1", class="A"})
  luaunit.assertEquals({
                         child:to_xml(),
                         document:to_xml(),
                       },
                       {
                       [[<child class="A" id="1"/>]],
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child class="A" id="1"/>
</root>
]],})
end

function TestElement.test_append_element_with_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml"/>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  local child = root:append_element("xhtml:child", {id="1", class="A"})
  luaunit.assertEquals({
                         child:to_xml(),
                         document:to_xml(),
                       },
                       {
                       [[<xhtml:child class="A" id="1"/>]],
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <xhtml:child class="A" id="1"/>
</xhtml:html>
]],})
end

function TestElement.test_append_element_with_new_namespace()
  local document = xmlua.XML.parse("<root/>")
  local root = document:root()
  local child = root:append_element("test:child",
                                    {["xmlns:test"]="http://example.com"})
  luaunit.assertEquals({
                         child:to_xml(),
                         document:to_xml(),
                       },
                       {
                       [[<test:child xmlns:test="http://example.com"/>]],
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <test:child xmlns:test="http://example.com"/>
</root>
]],})
end

function TestElement.test_get_attribute_raw()
  local document = xmlua.XML.parse("<root class=\"A\"/>")
  local node_set = document:search("/root")
  luaunit.assertEquals(node_set[1]:get_attribute("class"),
                       "A")
end

function TestElement.test_get_attribute_property()
  local document = xmlua.XML.parse("<root class=\"A\"/>")
  local node_set = document:search("/root")
  luaunit.assertEquals(node_set[1].class,
                       "A")
end

function TestElement.test_get_attribute_array_referece()
  local document = xmlua.XML.parse("<root class=\"A\"/>")
  local node_set = document:search("/root")
  luaunit.assertEquals(node_set[1]["class"],
                       "A")
end

function TestElement.test_set_attribute_raw()
  local document = xmlua.XML.parse("<root/>")
  local root = document:root()
  root:set_attribute("class", "A")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root class="A"/>
]])
end

function TestElement.test_set_attribute_substitution()
  local document = xmlua.XML.parse("<root/>")
  local root = document:root()
  root.class = "A"
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root class="A"/>
]])
end

function TestElement.test_set_attribute_with_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml"/>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  root:set_attribute("xhtml:class", "top-level")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml" xhtml:class="top-level"/>
]])
end

function TestElement.test_remove_attribute_raw()
  local document = xmlua.XML.parse("<root class=\"A\"/>")
  local node_set = document:search("/root")
  node_set[1]:remove_attribute("class")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
]])
end

function TestElement.test_remove_attribute_with_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml" xhtml:class="top-level"/>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  root:remove_attribute("xhtml:class")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml"/>
]])
end

function TestElement.test_path()
  local document = xmlua.XML.parse("<root/>")
  local root = document:root()
  luaunit.assertEquals(root:path(),
                       "/root")
end

function TestElement.test_unlink()
  local document = xmlua.XML.parse([[<root><child/></root>]])
  local root = document:root()
  local child = root:children()[1]
  child:unlink()
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
]])
end
