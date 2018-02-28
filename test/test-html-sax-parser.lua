local luaunit = require("luaunit")
local xmlua = require("xmlua")

local ffi = require("ffi")

TestHTMLSAXParser = {}

function TestHTMLSAXParser.test_start_document()
  local html = [[
<html></html>
]]
  local parser = xmlua.HTMLSAXParser.new()
  local called = false
  parser.start_document = function()
    called = true
  end
  local succeeded = parser:parse(html)
  luaunit.assertEquals({succeeded, called}, {true, true})
end

function TestHTMLSAXParser.test_processing_instruction()
  local html = "<html><?target This is PI></html>"
  local parser = xmlua.HTMLSAXParser.new()
  local targets = {}
  local data_list = {}
  parser.processing_instruction = function(target, data)
    table.insert(targets, target)
    table.insert(data_list, data)
  end
  local succeeded = parser:parse(html)
  luaunit.assertEquals({succeeded, targets, data_list},
                       {true, {"target"}, {"This is PI"}})
end

function TestHTMLSAXParser.test_cdata_block()
  local html = "<html><script>alert(\"Hello world!\")</script></html>"
  local parser = xmlua.HTMLSAXParser.new()
  local cdata_blocks = {}

  parser.cdata_block = function(cdata_block)
    table.insert(cdata_blocks, cdata_block)
  end
  local succeeded = parser:parse(html)
  luaunit.assertEquals({succeeded, cdata_blocks},
                       {true, {"alert(\"Hello world!\")"}})
end

function TestHTMLSAXParser.test_ignorable_whitespace()
  local html = [[
<html>
  <span></span>
</html>
]]
  local parser = xmlua.HTMLSAXParser.new()
  local ignorable_whitespaces_list = {}

  parser.ignorable_whitespace = function(ignorable_whitespaces)
    table.insert(ignorable_whitespaces_list, ignorable_whitespaces)
  end
  local succeeded = parser:parse(html)
  luaunit.assertEquals({succeeded, ignorable_whitespaces_list},
                       {true, {"\n  ", "\n"}})
end

function TestHTMLSAXParser.test_comment()
  local html = [[
<html><!--This is comment--></html>
]]
  local parser = xmlua.HTMLSAXParser.new()
  local called = false
  local comment = ""

  parser.comment = function(comment_content)
    called = true
    comment = comment_content
  end
  local succeeded = parser:parse(html)
  luaunit.assertEquals({succeeded, called, comment},
                       {true, true, "This is comment"})
end

local function collect_start_elements(chunk)
  local parser = xmlua.HTMLSAXParser.new()
  local elements = {}
  parser.start_element = function(local_name,
                                  prefix,
                                  uri,
                                  namespaces,
                                  attributes)
    local element = {
      local_name = local_name,
      prefix = prefix,
      uri = uri,
      namespaces = namespaces,
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
      namespaces = {},
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
      namespaces = {},
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
      namespaces = {
        xhtml = "http://www.w3.org/1999/xhtml",
      },
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

function TestHTMLSAXParser.test_start_element_with_default_namespace()
  local xhtml = [[
<html xmlns="http://www.w3.org/1999/xhtml"
  id="top"
  class="top-level">
]]
  local expected = {
    {
      local_name = "html",
      uri = "http://www.w3.org/1999/xhtml",
      namespaces = {},
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
  expected[1].namespaces[""] = "http://www.w3.org/1999/xhtml"
  luaunit.assertEquals(collect_start_elements(xhtml),
                       expected)
end


local function collect_end_elements(chunk)
  local parser = xmlua.HTMLSAXParser.new()
  local names = {}
  parser.end_element = function(name)
    table.insert(names, name)
  end
  luaunit.assertEquals(parser:parse(chunk), true)
  return names
end

function TestHTMLSAXParser.test_end_element()
  luaunit.assertEquals(collect_end_elements("<html><body></body></html>"),
                       {"body", "html"})
end

local function collect_texts(chunk)
  local parser = xmlua.HTMLSAXParser.new()
  local texts = {}
  parser.text = function(text)
    table.insert(texts, text)
  end
  luaunit.assertEquals(parser:parse(chunk), true)
  return texts
end

function TestHTMLSAXParser.test_text()
  local html = [[
<html>
  <head>
    <title>Hello World</title>
  </head>
  <body>
    <div>
      <p>Hello</p>
      <p>World</p>
    </div>
  </body>
</html>
]]
  local expected = {
    "Hello World",
    "\n    ",
    "\n      ",
    "Hello",
    "\n      ",
    "World",
    "\n    ",
    "\n  "
  }
  luaunit.assertEquals(collect_texts(html), expected)
end

function TestHTMLSAXParser.test_end_document()
  local html = [[
<html></html>
]]
  local parser = xmlua.HTMLSAXParser.new()
  local called = false
  parser.end_document = function()
    called = true
  end
  local succeeded = parser:parse(html)
  luaunit.assertEquals({succeeded, called}, {true, false})
  succeeded = parser:finish()
  luaunit.assertEquals({succeeded, called}, {true, true})
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
      domain = ffi.C.XML_FROM_HTML,
      code = ffi.C.XML_ERR_NAME_REQUIRED,
      message = "htmlParseStartTag: invalid element name\n",
      level = ffi.C.XML_ERR_ERROR,
      line = 1,
    },
  }
  luaunit.assertEquals(collect_errors("<"),
                       expected)
end
