local luaunit = require("luaunit")
local xmlua = require("xmlua")
local ffi = require("ffi")

TestElement = {}

local function get_prop(node, name, namespace_uri)
  if namespace_uri then
    return xmlua.libxml2.xmlGetNsProp(node, name, namespace_uri)
  else
    return xmlua.libxml2.xmlGetProp(node, name)
  end
end

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

function TestDocument.test_add_attribute_node()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root id="1">
  <child1/>
</root>
]])
  local attribute_node = document:search("/root/@id")

  local root = document:root()
  local child = root:children()[1]
  child:add_child(attribute_node[1])
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child1 id="1"/>
</root>
]])
end

function TestDocument.test_add_cdata_section_node()
  local document = xmlua.XML.build({"root"})
  local cdata_section_node =
    document:create_cdata_section("This is <CDATA>")
  local root = document:root()
  root:add_child(cdata_section_node)
  luaunit.assertEquals(document:to_xml(),
                       [=[
<?xml version="1.0" encoding="UTF-8"?>
<root><![CDATA[This is <CDATA>]]></root>
]=])
end

function TestDocument.test_add_comment_node()
  local document = xmlua.XML.build({"root"})
  local comment_node =
    document:create_comment("This is comment!")
  local root = document:root()
  root:add_child(comment_node)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <!--This is comment!-->
</root>
]])
end

function TestDocument.test_add_previous_sibling_node()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child1/>
</root>
]])
  local root = document:root()
  local comment_node =
    document:create_comment("This is comment!")
  local child = root:children()[1]
  child:add_previous_sibling(comment_node)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <!--This is comment!--><child1/>
</root>
]])
end

function TestDocument.test_add_sibling_node()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child1/>
</root>
]])
  local root = document:root()
  local comment_node =
    document:create_comment("This is comment!")
  local child = root:children()[1]
  child:add_sibling(comment_node)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child1/>
<!--This is comment!--></root>
]])
end

function TestDocument.test_add_next_sibling_node()
  local document = xmlua.XML.parse([[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child1/>
</root>
]])
  local root = document:root()
  local comment_node =
    document:create_comment("This is comment!")
  local child = root:children()[1]
  child:add_next_sibling(comment_node)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child1/><!--This is comment!-->
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
]]
  )
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

function TestElement.test_append_text()
  local document = xmlua.XML.parse([[<root/>]])
  local root = document:root()
  local text1 = root:append_text("text1")
  local text2 = root:append_text("text2")
  root:append_element("child")
  local text3 = root:append_text("text3")
  luaunit.assertEquals({
                         text1:text(),
                         text2:text(),
                         text3:text(),
                         root:to_xml(),
                       },
                       {
                         "text1text2",
                         "text1text2",
                         "text3",
                         "<root>text1text2<child/>text3</root>",
                       })
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
]],
                       })
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
                         [[<child id="1" class="A"/>]],
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child id="1" class="A"/>
</root>
]],
                       })
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
                         ffi.string(child.node.ns.href),
                         document:to_xml(),
                       },
                       {
                         [[<xhtml:child id="1" class="A"/>]],
                         "http://www.w3.org/1999/xhtml",
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <xhtml:child id="1" class="A"/>
</xhtml:html>
]],
                       })
end

function TestElement.test_append_element_with_namespace_declaration()
  local document = xmlua.XML.parse("<root/>")
  local root = document:root()
  local uri = "http://example.com"
  local attributes = {}
  attributes["xmlns:test"] = uri
  local child = root:append_element("test:child", attributes)
  luaunit.assertEquals({
                         child:to_xml(),
                         ffi.string(child.node.ns.href),
                         document:to_xml(),
                       },
                       {
                         [[<test:child xmlns:test="http://example.com"/>]],
                         uri,
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <test:child xmlns:test="http://example.com"/>
</root>
]],
                       })
end

function TestElement.test_append_element_with_default_namespace_declaration()
  local document = xmlua.XML.parse("<root/>")
  local root = document:root()
  local uri = "http://example.com/"
  local attributes = {}
  attributes["xmlns"] = uri
  attributes["data"] = "data-without-namespace"
  local child = root:append_element("child", attributes)
  luaunit.assertEquals({
                         child:to_xml(),
                         ffi.string(child.node.ns.href),
                         get_prop(child.node, "data"),
                         document:to_xml(),
                       },
                       {
                         [[
<child xmlns="http://example.com/" data="data-without-namespace"/>]],
                         uri,
                         "data-without-namespace",
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child xmlns="http://example.com/" data="data-without-namespace"/>
</root>
]],
                       })
end

function TestElement.test_append_element_with_default_namespace()
  local document = xmlua.XML.parse([[
<root xmlns="http://example.com/"/>
]])
  local root = document:root()
  local child = root:append_element("child", {})
  luaunit.assertEquals({
                         child:to_xml(),
                         ffi.string(child.node.ns.href),
                         document:to_xml(),
                       },
                       {
                         [[<child/>]],
                         "http://example.com/",
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root xmlns="http://example.com/">
  <child/>
</root>
]],
                       })
end

function TestElement.test_append_element_with_nonexistent_namespace()
  local document = xmlua.XML.parse("<root/>")
  local root = document:root()
  local child = root:append_element("nonexistent:child", {})
  luaunit.assertEquals({
                         child:to_xml(),
                         child.node.ns,
                         document:to_xml(),
                       },
                       {
                         [[<nonexistent:child/>]],
                         ffi.cast("xmlNsPtr", nil),
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <nonexistent:child/>
</root>
]],
                       })
end

function TestElement.test_append_element_with_namespace_attribute()
  local document = xmlua.XML.parse("<root/>")
  local root = document:root()
  local uri = "http://example.com/"
  local attributes = {}
  attributes["xmlns:example"] = uri
  attributes["example:data"] = "data-with-namespace"
  local child = root:append_element("child", attributes)
  luaunit.assertEquals({
                         child:to_xml(),
                         child.node.ns,
                         get_prop(child.node, "data", uri),
                         document:to_xml(),
                       },
                       {
                         [[
<child xmlns:example="http://example.com/" example:data="data-with-namespace"/>]],
                         ffi.cast("xmlNsPtr", nil),
                         "data-with-namespace",
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child xmlns:example="http://example.com/" example:data="data-with-namespace"/>
</root>
]],
                       })
end

function TestElement.test_insert_element()
  local document = xmlua.XML.parse([[<root><child1/><child2/></root>]])
  local root = document:root()
  local child = root:insert_element(2, "new-child")
  luaunit.assertEquals({
                         child:to_xml(),
                         document:to_xml(),
                       },
                       {
                         [[<new-child/>]],
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child1/>
  <new-child/>
  <child2/>
</root>
]],
                       })
end

function TestElement.test_insert_element_first_element()
  local document = xmlua.XML.parse([[<root/>]])
  local root = document:root()
  local child = root:insert_element(1, "child")
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
]],
                       })
end

function TestElement.test_insert_element_large_position()
  local document = xmlua.XML.parse([[<root/>]])
  local root = document:root()
  local child = root:insert_element(100, "child")
  luaunit.assertEquals({
                         child,
                         document:to_xml(),
                       },
                       {
                         nil,
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
]],
                       })
end

function TestElement.test_insert_element_with_attributes()
  local document = xmlua.XML.parse([[<root><child1/><child2/></root>]])
  local root = document:root()
  local child = root:insert_element(2, "new-child", {id="1", class="A"})
  luaunit.assertEquals({
                         child:to_xml(),
                         document:to_xml(),
                       },
                       {
                         [[<new-child id="1" class="A"/>]],
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <child1/>
  <new-child id="1" class="A"/>
  <child2/>
</root>
]],
                       })
end

function TestElement.test_insert_element_with_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <xhtml:child1/>
  <xhtml:child2/>
</xhtml:html>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  local child = root:insert_element(2,
                                    "xhtml:new-child",
                                    {id="1", class="A"})
  luaunit.assertEquals({
                         child:to_xml(),
                         document:to_xml(),
                       },
                       {
                         [[<xhtml:new-child id="1" class="A"/>]],
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <xhtml:child1/>
  <xhtml:new-child id="1" class="A"/><xhtml:child2/>
</xhtml:html>
]],
                       })
end

function TestElement.test_insert_element_with_new_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <xhtml:child1/>
  <xhtml:child2/>
</xhtml:html>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  local child = root:insert_element(2,
                                    "test:child",
                                    {["xmlns:test"]="http://example.com"})
  luaunit.assertEquals({
                         child:to_xml(),
                         document:to_xml(),
                       },
                       {
                         [[<test:child xmlns:test="http://example.com"/>]],
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <xhtml:child1/>
  <test:child xmlns:test="http://example.com"/><xhtml:child2/>
</xhtml:html>
]],
                       })
end

function TestElement.test_get_attribute_raw()
  local document = xmlua.XML.parse("<root class=\"A\"/>")
  local root = document:root()
  luaunit.assertEquals(root:get_attribute("class"),
                       "A")
end

function TestElement.test_get_attribute_property()
  local document = xmlua.XML.parse("<root class=\"A\"/>")
  local root = document:root()
  luaunit.assertEquals(root.class,
                       "A")
end

function TestElement.test_get_attribute_array_referece()
  local document = xmlua.XML.parse("<root class=\"A\"/>")
  local root = document:root()
  luaunit.assertEquals(root["class"],
                       "A")
end

function TestElement.test_get_attribute_namespace()
  local document = xmlua.XML.parse([[
<root xmlns:example="http://example.com/"/>
]])
  local root = document:root()
  luaunit.assertEquals(root["xmlns:example"],
                       "http://example.com/")
end

function TestElement.test_get_attribute_default_namespace()
  local document = xmlua.XML.parse([[
<root xmlns="http://example.com/"/>
]])
  local root = document:root()
  luaunit.assertEquals(root["xmlns"],
                       "http://example.com/")
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

function TestElement.test_set_attribute_nil()
  local document = xmlua.XML.parse([[<root data="root-data"/>]])
  local root = document:root()
  root:set_attribute("data", nil)
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
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

function TestElement.test_set_attribute_update()
  local document = xmlua.XML.parse("<root value='1'/>")
  local root = document:root()
  root.value = "2"
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root value="2"/>
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

function TestElement.test_set_attribute_update_with_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xhtml:class="top-level"/>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  root:set_attribute("xhtml:class", "top-level-updated")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml" xhtml:class="top-level-updated"/>
]])
end

function TestElement.test_set_attribute_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  local uri = "http://example.com/"
  root:set_attribute("xmlns:example", uri)
  root:set_attribute("example:attribute", "value")
  luaunit.assertEquals({
                         get_prop(root.node, "attribute", uri),
                         document:to_xml(),
                       },
                       {
                         "value",
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root xmlns:example="http://example.com/" example:attribute="value"/>
]],
                       })
end

function TestElement.test_set_attribute_namespace_update()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<example:root
  xmlns:example="http://example.com/"
  data="no-namespace-data"
  example:data="namespace-data">
  <example:sub1 data="sub1-no-namespace-data"/>
  <sub2 example:data="sub2-namespace-data"/>
</example:root>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  local uri = "http://example.org/"
  root:set_attribute("xmlns:example", uri)
  local sub2 = root:css_select("sub2")[1]
  luaunit.assertEquals({
                         get_prop(root.node, "data", uri),
                         get_prop(sub2.node, "data", uri),
                         document:to_xml(),
                       },
                       {
                         "namespace-data",
                         "sub2-namespace-data",
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<example:root xmlns:example="http://example.org/" data="no-namespace-data" example:data="namespace-data">
  <example:sub1 data="sub1-no-namespace-data"/>
  <sub2 example:data="sub2-namespace-data"/>
</example:root>
]],
                       })
end

function TestElement.test_set_attribute_default_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<root attribute="value">
  <sub data="sub-data"/>
</root>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  local sub = root:css_select("sub")[1]
  local uri = "http://example.com/"
  root:set_attribute("xmlns", uri)
  luaunit.assertEquals({
                         ffi.string(root.node.ns.href),
                         get_prop(root.node, "attribute", uri),
                         get_prop(root.node, "attribute"),
                         ffi.string(sub.node.ns.href),
                         get_prop(sub.node, "data", uri),
                         get_prop(sub.node, "data"),
                         document:to_xml(),
                       },
                       {
                         uri,
                         nil,
                         "value",
                         uri,
                         nil,
                         "sub-data",
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root xmlns="http://example.com/" attribute="value">
  <sub data="sub-data"/>
</root>
]],
                       })
end

function TestElement.test_set_attribute_default_namespace_update()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<root xmlns="http://example.com/" attribute="value">
  <sub data="sub-data"/>
</root>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  local sub = root:css_select("sub")[1]
  local old_uri = "http://example.com/"
  local new_uri = "http://example.org/"
  root:set_attribute("xmlns", new_uri)
  luaunit.assertEquals({
                         ffi.string(root.node.ns.href),
                         get_prop(root.node, "attribute", old_uri),
                         get_prop(root.node, "attribute", new_uri),
                         get_prop(root.node, "attribute"),
                         ffi.string(sub.node.ns.href),
                         get_prop(sub.node, "data", old_uri),
                         get_prop(sub.node, "data", new_uri),
                         get_prop(sub.node, "data", uri),
                         document:to_xml(),
                       },
                       {
                         new_uri,
                         nil,
                         nil,
                         "value",
                         new_uri,
                         nil,
                         nil,
                         "sub-data",
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root xmlns="http://example.org/" attribute="value">
  <sub data="sub-data"/>
</root>
]],
                       })
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
<xhtml:html
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xhtml:class="xhtml-top-level"
  xmlns:example="http://example.com/"
  example:class="example-top-level"/>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  root:remove_attribute("xhtml:class")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:example="http://example.com/" example:class="example-top-level"/>
]])
end

function TestElement.test_remove_attribute_with_nonexistent_namespace()
  local html = [[
<html
  class="html-top-level"
  nonexistent:class="nonexistent-top-level"/>
]]
  local document = xmlua.HTML.parse(html)
  local root = document:root()
  root:remove_attribute("nonexistent:class")
  luaunit.assertEquals(document:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html class="html-top-level"></html>
]])
end

function TestElement.test_remove_attribute_in_default_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<html
  xmlns="http://www.w3.org/1999/xhtml"
  class="top-level"/>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  root:remove_attribute("class")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml"/>
]])
end

function TestElement.test_remove_attribute_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<root xmlns:example="http://example.com/"/>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  root:remove_attribute("xmlns:example")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
]])
end

function TestElement.test_remove_attribute_namespace_sub_nodes()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<example:root
  xmlns:example="http://example.com/"
  a="attribute1"
  example:b="attribute2">
  <example:sub1/>
  <sub2 example:c="attribute-sub"/>
</example:root>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  root:remove_attribute("xmlns:example")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root a="attribute1" b="attribute2">
  <sub1/>
  <sub2 c="attribute-sub"/>
</root>
]])
end

function TestElement.test_remove_attribute_default_namespace()
  local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<root xmlns="http://example.com/"/>
]]
  local document = xmlua.XML.parse(xml)
  local root = document:root()
  root:remove_attribute("xmlns")
  luaunit.assertEquals(document:to_xml(),
                       [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
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
  local child = document:css_select("child")[1]
  local unlinked_node = child:unlink()
  luaunit.assertEquals({
                         unlinked_node:to_xml(),
                         document:to_xml(),
                       },
                       {
                         "<child/>",
                         [[
<?xml version="1.0" encoding="UTF-8"?>
<root/>
]],
                       })
end
