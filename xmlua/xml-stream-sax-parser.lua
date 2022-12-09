local XMLStreamSAXParser = {}

local libxml2 = require("xmlua.libxml2")
local XMLSAXParser = require("xmlua.xml-sax-parser")

local methods = {}

local metatable = {}

function metatable.__index(parser, key)
  return methods[key]
end

local CALLBACK_NAMES = {
  "start_document",
  "end_document",
  "element_declaration",
  "attribute_declaration",
  "unparsed_entity_declaration",
  "notation_declaration",
  "entity_declaration",
  "internal_subset",
  "external_subset",
  "cdata_block",
  "comment",
  "processing_instruction",
  "ignorable_whitespace",
  "text",
  "reference",
  -- "start_element",
  -- "end_element",
  "warning",
  "error",
}

local function assign_callbacks(parser, sax_parser)
  local listener = parser.listener
  for _, name in ipairs(CALLBACK_NAMES) do
    if listener[name] then
      sax_parser[name] = function(...)
        return listener[name](listener, ...)
      end
    end
  end
end

local function create_sax_parser(parser)
  local sax_parser = XMLSAXParser.new(parser.options)
  assign_callbacks(parser, sax_parser)

  local listener = parser.listener
  if listener.warning then
    sax_parser.is_pedantic = true
  end
  local depth = 1
  sax_parser.start_element = function(...)
    depth = depth + 1
    if listener.start_element then
      listener:start_element(...)
    end
  end
  sax_parser.end_element = function(...)
    if listener.end_element then
      listener:end_element(...)
    end
    depth = depth - 1
    parser.need_finish = depth == 1
  end
  return sax_parser
end

local function ensure_sax_parser(parser)
  if parser.sax_parser == nil then
    local sax_parser = create_sax_parser(parser)
    parser.sax_parser = sax_parser
    parser.need_finish = false
  end
end

function methods:parse(chunk)
  local success = true
  while #chunk > 0 and success do
    ensure_sax_parser(self)

    local start_index, end_index = chunk:find(">")
    if start_index then
      success = self.sax_parser:parse(chunk:sub(1, end_index))
      chunk = chunk:sub(end_index + 1)
    else
      success = self.sax_parser:parse(chunk)
      chunk = ""
    end
    if self.need_finish then
      self.sax_parser:finish()
      self.sax_parser = nil
      -- Skip leading spaces
      while true do
        start_index, end_index = chunk:find("[ \r\n]+")
        if start_index == 1 then
          chunk = chunk:sub(end_index + 1)
        else
          break
        end
      end
    end
  end
  return success
end

function methods:finish()
  if self.sax_parser == nil then
    return true
  end
  return self.sax_parser:finish()
end

function XMLStreamSAXParser.new(listener, options)
  local parser = {
    listener = listener,
    options = options,
    need_finish = false,
  }

  setmetatable(parser, metatable)

  return parser
end

return XMLStreamSAXParser
