local luaunit = require("luaunit")
local xmlua = require("xmlua")
local ffi = require("ffi")

TestDocument = {}

function TestDocument.test_add_entity()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE example [
]>
]]
  local parser = xmlua.XMLSAXParser.new()
  local succeeded = parser:parse(xml)
  local document = parser.document

  local entity_info = {
    name = "Sample",
    entity_type = ffi.C.XML_INTERNAL_GENERAL_ENTITY,
    external_id = "-//W3C//DTD XHTML 1.0 Transitional//EN",
    system_id = "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
    content = "This is test."
  }
  document:add_entity(entity_info)
  local entity = document:get_entity("Sample")
  luaunit.assertEquals({
                         ffi.string(entity.name),
                         tonumber(entity.etype),
                         ffi.string(entity.ExternalID),
                         ffi.string(entity.SystemID),
                         ffi.string(entity.content),
                       },
                       {
                         "Sample",
                         ffi.C.XML_INTERNAL_GENERAL_ENTITY,
                         "-//W3C//DTD XHTML 1.0 Transitional//EN",
                         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
                         "This is test."
                       })
end

function TestDocument.test_add_dtd_entity()
  local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE root SYSTEM "./test/test.dtd">
<root>
<A></A>
</root>
]]
  local options = {parser_dtd_load = true}
  local parser = xmlua.XMLSAXParser.new(options)
  local succeeded = parser:parse(xml)
  local document = parser.document

  local entity_info = {
    name = "Sample",
    entity_type = ffi.C.XML_INTERNAL_GENERAL_ENTITY,
    external_id = "-//W3C//DTD XHTML 1.0 Transitional//EN",
    system_id = "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
    content = "This is test."
  }
  document:add_dtd_entity(entity_info)
  local entity = document:get_dtd_entity("Sample")
  luaunit.assertEquals({
                         ffi.string(entity.name),
                         tonumber(entity.etype),
                         ffi.string(entity.ExternalID),
                         ffi.string(entity.SystemID),
                         ffi.string(entity.content),
                       },
                       {
                         "Sample",
                         ffi.C.XML_INTERNAL_GENERAL_ENTITY,
                         "-//W3C//DTD XHTML 1.0 Transitional//EN",
                         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
                         "This is test."
                       })
end

