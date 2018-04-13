#!/usr/bin/env luajit

local xmlua = require("xmlua")

-- Add a new entity to document
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE root [
]>
<root/>
]]

local parser = xmlua.XMLSAXParser.new()
parser.start_element = function()
  local document = parser.document
  -- Setting information for add a entity
  local entity = {
    name = "Sample",
  -- Entity type list
  --   XML_INTERNAL_GENERAL_ENTITY = 1
  --   XML_EXTERNAL_GENERAL_PARSED_ENTITY = 2
  --   XML_EXTERNAL_GENERAL_UNPARSED_ENTITY = 3
  --   XML_INTERNAL_PARAMETER_ENTITY = 4
  --   XML_EXTERNAL_PARAMETER_ENTITY = 5
  --   XML_INTERNAL_PREDEFINED_ENTITY = 6
    entity_type = 1,
    external_id = "-//W3C//DTD XHTML 1.0 Transitional//EN",
    system_id = "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
    content = "This is test."
  }
  document:add_entity(entity)
end
parser:parse(xml)


-- Add a new entity to document DTD external subset
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE root SYSTEM "./sample/sample.dtd">
<root>
<A></A>
</root>
]]

local options = {parser_dtd_load = true}
local parser = xmlua.XMLSAXParser.new(options)

parser.start_element = function()
  local document = parser.document
  -- Setting information for add entity
  local entity = {
    name = "Sample",
  -- Entity type list
  --   XML_INTERNAL_GENERAL_ENTITY = 1
  --   XML_EXTERNAL_GENERAL_PARSED_ENTITY = 2
  --   XML_EXTERNAL_GENERAL_UNPARSED_ENTITY = 3
  --   XML_INTERNAL_PARAMETER_ENTITY = 4
  --   XML_EXTERNAL_PARAMETER_ENTITY = 5
  --   XML_INTERNAL_PREDEFINED_ENTITY = 6
    entity_type = 1,
    external_id = "-//W3C//DTD XHTML 1.0 Transitional//EN",
    system_id = "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd",
    content = "This is test."
  }
  document:add_dtd_entity(entity)
end
parser:parse(xml)
