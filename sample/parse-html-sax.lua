#!/usr/bin/env luajit

local xmlua = require("xmlua")

local path = arg[1]
local file = assert(io.open(path))

local parser = xmlua.HTMLSAXParser.new()

parser.start_document = function()
  print("Start document")
end

parser.ignorable_whitespace = function(whitespaces)
  print("Ignorable whitespaces: " .. "\"" .. whitespaces .. "\"")
  print("Ignorable whitespaces length: " .. #whitespaces)
end

parser.processing_instruction = function(target, data)
  print("Processing instruction target: " .. target)
  print("Processing instruction data: " .. data)
end

parser.comment = function(comment)
  print("Comment: " .. comment)
end

parser.cdata_block = function(cdata_block)
  print("CDATA block: " .. cdata_block)
end

parser.start_element = function(name, attributes)
  print("Start element: " .. name)
  if #attributes > 0 then
    print("  Attributes:")
    for i, attribute in pairs(attributes) do
      print("    " .. attribute.name .. ": " .. (attribute.value or ""))
    end
  end
end

parser.end_element = function(name)
  print("End element: " .. name)
end

parser.text = function(text)
  print("Text: <" .. text .. ">")
end

parser.error = function(err)
  print("Error: " .. path .. ":" .. err.line .. ": " .. err.message)
end

parser.end_document = function()
  print("End document")
end

while true do
  local line = file:read()
  if not line then
    parser:finish()
    break
  end
  parser:parse(line)
end
file:close()
