local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestCSSSelect = {}

local function css_select(xml, css_selector_groups)
  local document = xmlua.XML.parse(xml)
  local matched_xmls = {}
  for _, node in ipairs(document:css_select(css_selector_groups)) do
    table.insert(matched_xmls, node:to_xml())
  end
  return matched_xmls
end

function TestCSSSelect.test_selector_groups()
  local xml = [[
<root>
  <sub1 class="A"/>
  <sub2 class="A"/>
  <sub1 class="B"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1, sub2"),
                       {
                         [[<sub1 class="A"/>]],
                         [[<sub1 class="B"/>]],
                         [[<sub2 class="A"/>]],
                       })
end

function TestCSSSelect.test_combinator_plus()
  local xml = [[
<root>
  <sub1 class="A">
    <sub2 class="AA"/>
  </sub1>
  <sub2 class="A"/>
  <sub1 class="B"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1 + sub2"),
                       {
                         [[<sub2 class="A"/>]],
                       })
end

function TestCSSSelect.test_combinator_greater()
  local xml = [[
<root>
  <sub1 class="A">
    <sub2 class="AA"/>
    <sub2 class="AB"/>
    <sub2 class="AC"/>
    <sub3 class="AX">
      <sub2 class="AXA"/>
    </sub3>
  </sub1>
  <sub2 class="A"/>
  <sub1 class="B"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1 > sub2"),
                       {
                         [[<sub2 class="AA"/>]],
                         [[<sub2 class="AB"/>]],
                         [[<sub2 class="AC"/>]],
                       })
end

function TestCSSSelect.test_combinator_tilda()
  local xml = [[
<root>
  <sub1 class="A">
    <sub2 class="AA"/>
    <sub2 class="AB"/>
    <sub3 class="AX">
      <sub2 class="AXA"/>
    </sub3>
  </sub1>
  <sub2 class="A"/>
  <sub1 class="B"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1 sub2"),
                       {
                         [[<sub2 class="AA"/>]],
                         [[<sub2 class="AB"/>]],
                         [[<sub2 class="AXA"/>]],
                       })
end

function TestCSSSelect.test_combinator_whitespace()
  local xml = [[
<root>
  <sub1 class="A">
    <sub2 class="AA"/>
    <sub2 class="AB"/>
  </sub1>
  <sub2 class="A"/>
  <sub2 class="B"/>
  <sub1 class="B"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1 ~ sub2"),
                       {
                         [[<sub2 class="A"/>]],
                         [[<sub2 class="B"/>]],
                       })
end

function TestCSSSelect.test_type_selector()
  local xml = [[
<root xmlns:a="http://example.com/a/">
  <sub class="A"/>
  <a:sub class="B"/>
  <sub class="C" xmlns="http://example.com/b/"/>
  <sub class="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub"),
                       {
                         [[<sub class="A"/>]],
                         [[<a:sub class="B"/>]],
                         [[<sub xmlns="http://example.com/b/" class="C"/>]],
                         [[<sub class="D"/>]],
                       })
end

function TestCSSSelect.test_type_selector_namespace_prefix_name()
  local xml = [[
<root xmlns:a="http://example.com/a/">
  <sub class="A"/>
  <a:sub class="B"/>
  <sub class="C" xmlns="http://example.com/b/"/>
  <sub class="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "a|sub"),
                       {
                         [[<a:sub class="B"/>]],
                       })
end

function TestCSSSelect.test_type_selector_namespace_prefix_star()
  local xml = [[
<root xmlns:a="http://example.com/a/">
  <sub class="A"/>
  <a:sub class="B"/>
  <sub class="C" xmlns="http://example.com/b/"/>
  <sub class="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "*|sub"),
                       {
                         [[<sub class="A"/>]],
                         [[<a:sub class="B"/>]],
                         [[<sub xmlns="http://example.com/b/" class="C"/>]],
                         [[<sub class="D"/>]],
                       })
end

function TestCSSSelect.test_type_selector_namespace_prefix_none()
  local xml = [[
<root xmlns:a="http://example.com/a/">
  <sub class="A"/>
  <a:sub class="B"/>
  <sub class="C" xmlns="http://example.com/b/"/>
  <sub class="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "|sub"),
                       {
                         [[<sub class="A"/>]],
                         [[<sub class="D"/>]],
                       })
end

function TestCSSSelect.test_universal()
  local xml = [[
<root xmlns:a="http://example.com/a/">
  <sub class="A"/>
  <a:sub class="B"/>
  <sub class="C" xmlns="http://example.com/b/"/>
  <sub class="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "root *"),
                       {
                         [[<sub class="A"/>]],
                         [[<a:sub class="B"/>]],
                         [[<sub xmlns="http://example.com/b/" class="C"/>]],
                         [[<sub class="D"/>]],
                       })
end

function TestCSSSelect.test_universal_namespace_prefix_name()
  local xml = [[
<root xmlns:a="http://example.com/a/">
  <sub class="A"/>
  <a:sub class="B"/>
  <sub class="C" xmlns="http://example.com/b/"/>
  <sub class="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "root a|*"),
                       {
                         [[<a:sub class="B"/>]],
                       })
end

function TestCSSSelect.test_universal_namespace_prefix_star()
  local xml = [[
<root xmlns:a="http://example.com/a/">
  <sub class="A"/>
  <a:sub class="B"/>
  <sub class="C" xmlns="http://example.com/b/"/>
  <sub class="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "root *|*"),
                       {
                         [[<sub class="A"/>]],
                         [[<a:sub class="B"/>]],
                         [[<sub xmlns="http://example.com/b/" class="C"/>]],
                         [[<sub class="D"/>]],
                       })
end

function TestCSSSelect.test_universal_namespace_prefix_none()
  local xml = [[
<root xmlns:a="http://example.com/a/">
  <sub class="A"/>
  <a:sub class="B"/>
  <sub class="C" xmlns="http://example.com/b/"/>
  <sub class="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "root |*"),
                       {
                         [[<sub class="A"/>]],
                         [[<sub class="D"/>]],
                       })
end

function TestCSSSelect.test_hash()
  local xml = [[
<root>
  <sub id="A"/>
  <sub id="B"/>
  <sub id="C"/>
  <sub id="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "#B"),
                       {
                         [[<sub id="B"/>]],
                       })
end

function TestCSSSelect.test_hash_type_selector()
  local xml = [[
<root>
  <sub id="A"/>
  <sub id="B"/>
  <sub id="C"/>
  <sub id="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub#B, root#B"),
                       {
                         [[<sub id="B"/>]],
                       })
end

function TestCSSSelect.test_class()
  local xml = [[
<root>
  <sub1 class="A"/>
  <sub1 class="B"/>
  <sub1 class="C">
    <sub1 class="B" id="CB"/>
  </sub1>
  <sub2 class="B"/>
  <sub1 class="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, ".B"),
                       {
                         [[<sub1 class="B"/>]],
                         [[<sub1 class="B" id="CB"/>]],
                         [[<sub2 class="B"/>]],
                       })
end

function TestCSSSelect.test_class_type_selector()
  local xml = [[
<root>
  <sub1 class="A"/>
  <sub1 class="B"/>
  <sub1 class="C">
    <sub1 class="B" id="CB"/>
  </sub1>
  <sub2 class="B"/>
  <sub1 class="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1.B"),
                       {
                         [[<sub1 class="B"/>]],
                         [[<sub1 class="B" id="CB"/>]],
                       })
end

function TestCSSSelect.test_attribute()
  local xml = [[
<root>
  <sub1 class="A"/>
  <sub1 class="B"/>
  <sub2/>
  <sub2 class="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "[class]"),
                       {
                         [[<sub1 class="A"/>]],
                         [[<sub1 class="B"/>]],
                         [[<sub2 class="D"/>]],
                       })
end

function TestCSSSelect.test_attribute_type_selector()
  local xml = [[
<root>
  <sub1 class="A"/>
  <sub1 class="B"/>
  <sub2/>
  <sub2 class="D"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1[class]"),
                       {
                         [[<sub1 class="A"/>]],
                         [[<sub1 class="B"/>]],
                       })
end

function TestCSSSelect.test_attribute_prefix_match()
  local xml = [[
<root>
  <sub1 class="xxx-A"/>
  <sub1 class="xxx-B"/>
  <sub2 class="xx-C"/>
  <sub2 class="xxx-A"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "[class^='xxx']"),
                       {
                         [[<sub1 class="xxx-A"/>]],
                         [[<sub1 class="xxx-B"/>]],
                         [[<sub2 class="xxx-A"/>]],
                       })
end

function TestCSSSelect.test_attribute_prefix_match_type_selector()
  local xml = [[
<root>
  <sub1 class="xxx-A"/>
  <sub1 class="xxx-B"/>
  <sub2 class="xx-C"/>
  <sub2 class="xxx-A"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1[class^='xxx']"),
                       {
                         [[<sub1 class="xxx-A"/>]],
                         [[<sub1 class="xxx-B"/>]],
                       })
end

function TestCSSSelect.test_attribute_suffix_match()
  local xml = [[
<root>
  <sub1 class="A-xxx"/>
  <sub1 class="B-xxx"/>
  <sub2 class="C-xx"/>
  <sub2 class="A-xxx"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "[class$='xxx']"),
                       {
                         [[<sub1 class="A-xxx"/>]],
                         [[<sub1 class="B-xxx"/>]],
                         [[<sub2 class="A-xxx"/>]],
                       })
end

function TestCSSSelect.test_attribute_suffix_match_type_selector()
  local xml = [[
<root>
  <sub1 class="A-xxx"/>
  <sub1 class="B-xxx"/>
  <sub2 class="C-xx"/>
  <sub2 class="A-xxx"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1[class$='xxx']"),
                       {
                         [[<sub1 class="A-xxx"/>]],
                         [[<sub1 class="B-xxx"/>]],
                       })
end

function TestCSSSelect.test_attribute_substring_match()
  local xml = [[
<root>
  <sub1 class="A-xxx"/>
  <sub1 class="B-xxx"/>
  <sub2 class="C-x"/>
  <sub2 class="A-xxx"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "[class*='-xx']"),
                       {
                         [[<sub1 class="A-xxx"/>]],
                         [[<sub1 class="B-xxx"/>]],
                         [[<sub2 class="A-xxx"/>]],
                       })
end

function TestCSSSelect.test_attribute_substring_match_type_selector()
  local xml = [[
<root>
  <sub1 class="A-xxx"/>
  <sub1 class="B-xxx"/>
  <sub2 class="C-x"/>
  <sub2 class="A-xxx"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1[class*='-xx']"),
                       {
                         [[<sub1 class="A-xxx"/>]],
                         [[<sub1 class="B-xxx"/>]],
                       })
end

function TestCSSSelect.test_attribute_equal()
  local xml = [[
<root>
  <sub1 class="xxx"/>
  <sub1 class="B-xxx"/>
  <sub2 class="xxx"/>
  <sub2 class="B-xxx"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "[class='xxx']"),
                       {
                         [[<sub1 class="xxx"/>]],
                         [[<sub2 class="xxx"/>]],
                       })
end

function TestCSSSelect.test_attribute_equal_type_selector()
  local xml = [[
<root>
  <sub1 class="xxx"/>
  <sub1 class="B-xxx"/>
  <sub2 class="xxx"/>
  <sub2 class="B-xxx"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1[class='xxx']"),
                       {
                         [[<sub1 class="xxx"/>]],
                       })
end

function TestCSSSelect.test_attribute_include()
  local xml = [[
<root>
  <sub1 class="xxx A"/>
  <sub1 class="B-xxx"/>
  <sub2 class="A xxx"/>
  <sub2 class="B-xxx"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "[class~='xxx']"),
                       {
                         [[<sub1 class="xxx A"/>]],
                         [[<sub2 class="A xxx"/>]],
                       })
end

function TestCSSSelect.test_attribute_include_type_selector()
  local xml = [[
<root>
  <sub1 class="xxx A"/>
  <sub1 class="B-xxx"/>
  <sub2 class="A xxx"/>
  <sub2 class="B-xxx"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1[class~='xxx']"),
                       {
                         [[<sub1 class="xxx A"/>]],
                       })
end

function TestCSSSelect.test_attribute_dash_match()
  local xml = [[
<root>
  <sub1 lang="ja"/>
  <sub1 lang="ja-JP"/>
  <sub2 lang="ja"/>
  <sub2 lang="ja.JP"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "[lang|='ja']"),
                       {
                         [[<sub1 lang="ja"/>]],
                         [[<sub1 lang="ja-JP"/>]],
                         [[<sub2 lang="ja"/>]],
                       })
end

function TestCSSSelect.test_attribute_dash_match_type_selector()
  local xml = [[
<root>
  <sub1 lang="ja"/>
  <sub1 lang="ja-JP"/>
  <sub2 lang="ja"/>
  <sub2 lang="ja.JP"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1[lang|='ja']"),
                       {
                         [[<sub1 lang="ja"/>]],
                         [[<sub1 lang="ja-JP"/>]],
                       })
end

function TestCSSSelect.test_pseudo_class_root()
  local xml = [[
<root>
  <sub/>
</root>
]]
  luaunit.assertEquals(css_select(xml, ":root"),
                       {
                         "<root>\n" ..
                           "  <sub/>\n" ..
                           "</root>",
                       })
end

function TestCSSSelect.test_pseudo_class_root_type_selector()
  local xml = [[
<root>
  <sub/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "root:root"),
                       {
                         "<root>\n" ..
                           "  <sub/>\n" ..
                           "</root>",
                       })
end

function TestCSSSelect.test_pseudo_class_first_child()
  local xml = [[
<root>
  <sub class="A"/>
  <sub class="B"/>
  <sub class="C"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "root :first-child"),
                       {
                         [[<sub class="A"/>]],
                       })
end

function TestCSSSelect.test_pseudo_class_first_child_type_selector()
  local xml = [[
<root>
  <sub class="A"/>
  <sub class="B"/>
  <sub class="C"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub:first-child"),
                       {
                         [[<sub class="A"/>]],
                       })
end

function TestCSSSelect.test_pseudo_class_last_child()
  local xml = [[
<root>
  <sub class="A"/>
  <sub class="B"/>
  <sub class="C"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "root :last-child"),
                       {
                         [[<sub class="C"/>]],
                       })
end

function TestCSSSelect.test_pseudo_class_last_child_type_selector()
  local xml = [[
<root>
  <sub class="A"/>
  <sub class="B"/>
  <sub class="C"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub:last-child"),
                       {
                         [[<sub class="C"/>]],
                       })
end
