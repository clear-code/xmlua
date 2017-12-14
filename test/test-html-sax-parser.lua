local luaunit = require("luaunit")
local xmlua = require("xmlua")

local ffi = require("ffi")

TestHTMLSAXParser = {}

local function collect_start_elements(chunk)
  local parser = xmlua.HTMLSAXParser.new()
  local elements = {}
  parser.start_element = function(local_name, prefix, uri, attributes)
    local element = {
      local_name = local_name,
      prefix = prefix,
      uri = uri,
      attributes = attributes
    }
    table.insert(elements, element)
  end
  luaunit.assertEquals(parser:parse(chunk), true)
  return elements
end

function TestHTMLSAXParser.test_start_element_no_namespace()
  local expected = {
    {
      local_name = "html",
      attributes = {},
    },
  }
  luaunit.assertEquals(collect_start_elements("<html>"), expected)
end

function TestHTMLSAXParser.test_start_element_attributes_no_namespace()
  local html = [[
<html id="top" class="top-level">
]]
  local expected = {
    {
      local_name = "html",
      attributes = {
        {
          local_name = "id",
          value = "top",
          is_default = false,
        },
        {
          local_name = "class",
          value = "top-level",
          is_default = false,
        },
      },
    },
  }
  luaunit.assertEquals(collect_start_elements(html),
                       expected)
end

function TestHTMLSAXParser.test_start_element_with_namespace()
  local xhtml = [[
<xhtml:html xmlns:xhtml="http://www.w3.org/1999/xhtml"
  id="top"
  xhtml:class="top-level">
]]
  local expected = {
    {
      local_name = "html",
      prefix = "xhtml",
      uri = "http://www.w3.org/1999/xhtml",
      attributes = {
        {
          local_name = "id",
          value = "top",
          is_default = false,
        },
        {
          local_name = "class",
          prefix = "xhtml",
          uri = "http://www.w3.org/1999/xhtml",
          value = "top-level",
          is_default = false,
        },
      },
    },
  }
  luaunit.assertEquals(collect_start_elements(xhtml),
                       expected)
end

local function collect_errors(chunk)
  local parser = xmlua.HTMLSAXParser.new()
  local errors = {}
  parser.error = function(error)
    table.insert(errors, error)
  end
  luaunit.assertEquals(parser:parse(chunk), true)
  luaunit.assertEquals(parser:finish(), false)
  return errors
end

function TestHTMLSAXParser.test_error()
  local expected = {
    {
      domain = ffi.C.XML_FROM_PARSER,
      code = ffi.C.XML_ERR_DOCUMENT_END,
      message = "Extra content at the end of the document\n",
      level = ffi.C.XML_ERR_FATAL,
      line = 1,
    },
  }
  luaunit.assertEquals(collect_errors("<"),
                       expected)
end
