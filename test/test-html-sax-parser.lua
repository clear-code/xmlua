local luaunit = require("luaunit")
local libxml2 = require("xmlua").libxml2
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
  local comment = ""
  parser.comment = function(comment_content)
    comment = comment_content
  end
  local succeeded = parser:parse(html)
  luaunit.assertEquals({succeeded, comment},
                       {true, "This is comment"})
end

local function collect_start_elements(chunk)
  local parser = xmlua.HTMLSAXParser.new()
  local elements = {}
  parser.start_element = function(name, attributes)
    local element = {
      name = name,
      attributes = attributes,
    }
    table.insert(elements, element)
  end
  luaunit.assertEquals(parser:parse(chunk), true)
  return elements
end

function TestHTMLSAXParser.test_start_element()
  local expected = {
    {
      name = "html",
      attributes = {},
    },
    -- An implicit event. We can disable it with HTML_PARSER_NOIMPLIED option.
    {
      name = "body",
      attributes = {},
    },
    {
      name = "p",
      attributes = {},
    },
  }
  luaunit.assertEquals(collect_start_elements("<html><p>"),
                       expected)
end

function TestHTMLSAXParser.test_start_element_attributes()
  local html = [[
<html id="top" class="top-level">
]]
  local expected = {
    {
      name = "html",
      attributes = {
        {
          name = "id",
          value = "top",
        },
        {
          name = "class",
          value = "top-level",
        },
      },
    },
  }
  luaunit.assertEquals(collect_start_elements(html),
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
  -- This condition may be loose
  if tonumber(libxml2.VERSION) >= 21207 then
    -- This error doesn't happen with at least libxml2 2.12.7.
    return
  end

  local expected = {
    {
      domain = ffi.C.XML_FROM_HTML,
      code = ffi.C.XML_ERR_NAME_REQUIRED,
      message = "htmlParseStartTag: invalid element name\n",
      level = ffi.C.XML_ERR_ERROR,
      line = 1,
    },
  }
  luaunit.assertEquals(collect_errors("<&"),
                       expected)
end
