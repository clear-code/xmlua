-- -*- lua -*-

local package_version = "1.0.6"

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
    ["xmlua.converter"] = "xmlua/converter.lua",
    ["xmlua.document"] = "xmlua/document.lua",
    ["xmlua.element"] = "xmlua/element.lua",
    ["xmlua.html"] = "xmlua/html.lua",
    ["xmlua.html-sax-parser"] = "xmlua/html-sax-parser.lua",
    ["xmlua.libxml2"] = "xmlua/libxml2.lua",
    ["xmlua.libxml2.dict"] = "xmlua/libxml2/dict.lua",
    ["xmlua.libxml2.encoding"] = "xmlua/libxml2/encoding.lua",
    ["xmlua.libxml2.global"] = "xmlua/libxml2/global.lua",
    ["xmlua.libxml2.hash"] = "xmlua/libxml2/hash.lua",
    ["xmlua.libxml2.html-parser"] = "xmlua/libxml2/html-parser.lua",
    ["xmlua.libxml2.memory"] = "xmlua/libxml2/memory.lua",
    ["xmlua.libxml2.parser"] = "xmlua/libxml2/parser.lua",
    ["xmlua.libxml2.tree"] = "xmlua/libxml2/tree.lua",
    ["xmlua.libxml2.valid"] = "xmlua/libxml2/valid.lua",
    ["xmlua.libxml2.xmlerror"] = "xmlua/libxml2/xmlerror.lua",
    ["xmlua.libxml2.xmlsave"] = "xmlua/libxml2/xmlsave.lua",
    ["xmlua.libxml2.xmlstring"] = "xmlua/libxml2/xmlstring.lua",
    ["xmlua.libxml2.xpath"] = "xmlua/libxml2/xpath.lua",
    ["xmlua.node"] = "xmlua/node.lua",
    ["xmlua.node-set"] = "xmlua/node-set.lua",
    ["xmlua.searchable"] = "xmlua/searchable.lua",
    ["xmlua.serializable"] = "xmlua/serializable.lua",
    ["xmlua.text"] = "xmlua/text.lua",
    ["xmlua.xml"] = "xmlua/xml.lua",
    ["xmlua.xml-sax-parser"] = "xmlua/xml-sax-parser.lua"
  },
  copy_directories = {
    "docs"
  }
}
