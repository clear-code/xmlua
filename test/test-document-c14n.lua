local luaunit = require("luaunit")
local xmlua = require("xmlua")
local ffi = require("ffi")

TestDocumentC14N = {}

-- From: https://www.w3.org/2008/xmlsec/Drafts/c14n-20/test-cases/Overview.src.html

function TestDocumentC14N.test_PIs_Comments_and_Outside_of_Document_Element()
  -- https://www.w3.org/2008/xmlsec/Drafts/c14n-20/test-cases/files/inC14N1.xml
  local input = [[
<?xml version="1.0"?>

<?xml-stylesheet   href="doc.xsl"
   type="text/xsl"   ?>

<!DOCTYPE doc SYSTEM "doc.dtd">

<doc>Hello, world!<!-- Comment 1 --></doc>

<?pi-without-data     ?>

<!-- Comment 2 -->

<!-- Comment 3 -->
]]
  local options = {}
  -- https://www.w3.org/2008/xmlsec/Drafts/c14n-20/test-cases/files/out_inC14N1_c14nDefault.xml
  local expected = [[
<?xml-stylesheet href="doc.xsl"
   type="text/xsl"   ?>
<doc>Hello, world!</doc>
<?pi-without-data?>]]

  local document = xmlua.XML.parse(input)
  local c14n = document:canonicalize(nil, options)
  luaunit.assertEquals(c14n, expected)
end

function TestDocumentC14N.test_PIs_Comments_and_Outside_of_Document_Element_with_comments()
  -- https://www.w3.org/2008/xmlsec/Drafts/c14n-20/test-cases/files/inC14N1.xml
  local input = [[
<?xml version="1.0"?>

<?xml-stylesheet   href="doc.xsl"
   type="text/xsl"   ?>

<!DOCTYPE doc SYSTEM "doc.dtd">

<doc>Hello, world!<!-- Comment 1 --></doc>

<?pi-without-data     ?>

<!-- Comment 2 -->

<!-- Comment 3 -->
]]
  local options = {
    with_comments = true
  }
  -- https://www.w3.org/2008/xmlsec/Drafts/c14n-20/test-cases/files/out_inC14N1_c14nComment.xml
  local expected = [[
<?xml-stylesheet href="doc.xsl"
   type="text/xsl"   ?>
<doc>Hello, world!<!-- Comment 1 --></doc>
<?pi-without-data?>
<!-- Comment 2 -->
<!-- Comment 3 -->]]

  local document = xmlua.XML.parse(input)
  local c14n = document:canonicalize(nil, options)
  luaunit.assertEquals(c14n, expected)
end
