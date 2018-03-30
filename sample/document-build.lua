#!/usr/bin/env luajit

local xmlua = require("xmlua")

local tree
local document

-- Empty tree
tree = {}
document = xmlua.XML.build(tree)
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>

-- Root only document
tree = {"root"}
document = xmlua.XML.build(tree)
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root/>

-- Root with attributes
tree = {
  "root",
  {
    attribute1 = "value1",
    attribute2 = "value2",
  },
}
document = xmlua.XML.build(tree)
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root attribute2="value2" attribute1="value1"/>

-- Root with namespaces
tree = {
  "example:root",
  {
    ["xmlns:example"] = "http://example.com/",
    ["example:attribute"] = "with-namespace",
    ["attribute"] = "without-namespace",
  },
}
document = xmlua.XML.build(tree)
print(document:to_xml())
-- (Indented manually for readability)
--
-- <?xml version="1.0" encoding="UTF-8"?>
-- <example:root
--   xmlns:example="http://example.com/"
--   attribute="without-namespace"
--   example:attribute="with-namespace"/>

-- Child elements
tree = {
  "root",
  {},
  {
    "child",
    {
      attribute = "child-value",
    },
  },
}
document = xmlua.XML.build(tree)
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <child attribute="child-value"/>
-- </root>

-- Child elements
tree = {
  "root",
  {},
  "root text1",
  {
    "child",
    {
      attribute = "child-value",
    },
    "child-text",
  },
  "root text2",
}
document = xmlua.XML.build(tree)
print(document:to_xml())
-- (Indented manually for readability)
--
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   root text1
--   <child attribute="child-value">
--     child-text
--   </child>
--   root text2
-- </root>
