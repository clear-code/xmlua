#!/usr/bin/env luajit

local xmlua = require("xmlua")

-- Add a new entity to document
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE root [
]>
<root>
  &Sample;
<root/>
]]

local parser = xmlua.XMLSAXParser.new()
local is_root = true
parser.start_element = function()
  if not is_root then
    return
  end

  local document = parser.document
  -- Setting information for add a entity
  local entity = {
    name = "Sample",
    -- Entity type list
    --   INTERNAL_ENTITY
    --   EXTERNAL_PARSED_ENTITY
    --   EXTERNAL_UNPARSED_ENTITY
    --   INTERNAL_PARAMETER_ENTITY
    --   EXTERNAL_PARAMETER_ENTITY
    --   INTERNAL_PREDEFINED_ENTITY
    entity_type = "INTERNAL_ENTITY",
    content = "This is test."
  }
  document:add_entity(entity)
  is_root = false
end
parser.text = function(text)
  print(text) -- This is test.
end

parser:parse(xml)


-- Add a new entity to document DTD external subset
local xml = [[
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE root SYSTEM "./sample/sample.dtd">
<root>
  &Sample;
</root>
]]

local options = {load_dtd = true}
local parser = xmlua.XMLSAXParser.new(options)
local is_root = true
parser.start_element = function()
  if not is_root then
    return
  end

  local document = parser.document
  -- Setting information for add entity
  local entity = {
    name = "Sample",
    -- Entity type list
    --   INTERNAL_ENTITY
    --   EXTERNAL_PARSED_ENTITY
    --   EXTERNAL_UNPARSED_ENTITY
    --   INTERNAL_PARAMETER_ENTITY
    --   EXTERNAL_PARAMETER_ENTITY
    --   INTERNAL_PREDEFINED_ENTITY
    entity_type = "INTERNAL_ENTITY",
    content = "This is test."
  }
  document:add_dtd_entity(entity)
  is_root = false
end
parser.text = function(text)
  print(text) -- This is test.
end
parser:parse(xml)

