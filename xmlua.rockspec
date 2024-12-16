-- -*- lua -*-

local package_version = "1.2.2"

package = "XMLua"
version = package_version .. "-0"
description = {
  summary = "XMLua is a Lua library for processing XML and HTML",
  detailed = [[
    It's based on libxml2. It uses LuaJIT's FFI module.
    XMLua provides user-friendly API instead of low-level libxml2 API.
    The user-friendly API is implemented top of low-level libxml2 API.
  ]],
  license = "MIT",
  homepage = "https://clear-code.github.io/xmlua/",
  -- Since 3.0
  -- issues_url = "https://github.com/clear-code/xmlua/issues",
  maintainer = "Horimoto Yasuhiro <horimoto@clear-code.com> and Kouhei Sutou <kou@clear-code.com>",
  -- Since 3.0
  -- labels = {"xml"},
}
dependencies = {
  "luacs",
}
external_dependencies = {
  LIBXML2 = {
    library = "xml2"
  }
}
source = {
  url = "https://github.com/clear-code/xmlua/archive/" .. package_version .. ".zip",
  dir = "xmlua-" .. package_version,
}
build = {
  type = "builtin",
  modules = {
    ["xmlua"] = "xmlua.lua",
    ["xmlua.attribute"] = "xmlua/attribute.lua",
    ["xmlua.attribute-declaration"] = "xmlua/attribute-declaration.lua",
    ["xmlua.cdata-section"] = "xmlua/cdata-section.lua",
    ["xmlua.comment"] = "xmlua/comment.lua",
    ["xmlua.converter"] = "xmlua/converter.lua",
    ["xmlua.document"] = "xmlua/document.lua",
    ["xmlua.document-fragment"] = "xmlua/document-fragment.lua",
    ["xmlua.document-type"] = "xmlua/document-type.lua",
    ["xmlua.element"] = "xmlua/element.lua",
    ["xmlua.element-declaration"] = "xmlua/element-declaration.lua",
    ["xmlua.entity"] = "xmlua/entity.lua",
    ["xmlua.entity-declaration"] = "xmlua/entity-declaration.lua",
    ["xmlua.entity-reference"] = "xmlua/entity-reference.lua",
    ["xmlua.html"] = "xmlua/html.lua",
    ["xmlua.html-sax-parser"] = "xmlua/html-sax-parser.lua",
    ["xmlua.libxml2"] = "xmlua/libxml2.lua",
    ["xmlua.libxml2.dict"] = "xmlua/libxml2/dict.lua",
    ["xmlua.libxml2.encoding"] = "xmlua/libxml2/encoding.lua",
    ["xmlua.libxml2.entities"] = "xmlua/libxml2/entities.lua",
    ["xmlua.libxml2.global"] = "xmlua/libxml2/global.lua",
    ["xmlua.libxml2.hash"] = "xmlua/libxml2/hash.lua",
    ["xmlua.libxml2.html-parser"] = "xmlua/libxml2/html-parser.lua",
    ["xmlua.libxml2.html-tree"] = "xmlua/libxml2/html-tree.lua",
    ["xmlua.libxml2.memory"] = "xmlua/libxml2/memory.lua",
    ["xmlua.libxml2.parser"] = "xmlua/libxml2/parser.lua",
    ["xmlua.libxml2.tree"] = "xmlua/libxml2/tree.lua",
    ["xmlua.libxml2.valid"] = "xmlua/libxml2/valid.lua",
    ["xmlua.libxml2.xmlerror"] = "xmlua/libxml2/xmlerror.lua",
    ["xmlua.libxml2.xmlsave"] = "xmlua/libxml2/xmlsave.lua",
    ["xmlua.libxml2.xmlstring"] = "xmlua/libxml2/xmlstring.lua",
    ["xmlua.libxml2.xpath"] = "xmlua/libxml2/xpath.lua",
    ["xmlua.namespace"] = "xmlua/namespace.lua",
    ["xmlua.namespace-declaration"] = "xmlua/namespace-declaration.lua",
    ["xmlua.node"] = "xmlua/node.lua",
    ["xmlua.node-set"] = "xmlua/node-set.lua",
    ["xmlua.notation"] = "xmlua/notation.lua",
    ["xmlua.notation-declaration"] = "xmlua/notation-declaration.lua",
    ["xmlua.processing-instruction"] = "xmlua/processing-instruction.lua",
    ["xmlua.searchable"] = "xmlua/searchable.lua",
    ["xmlua.serializable"] = "xmlua/serializable.lua",
    ["xmlua.text"] = "xmlua/text.lua",
    ["xmlua.xml"] = "xmlua/xml.lua",
    ["xmlua.xml-sax-parser"] = "xmlua/xml-sax-parser.lua",
    ["xmlua.xml-stream-sax-parser"] = "xmlua/xml-stream-sax-parser.lua",
  },
  copy_directories = {
    "docs"
  }
}
