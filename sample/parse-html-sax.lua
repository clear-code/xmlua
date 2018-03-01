#!/usr/bin/env luajit

local xmlua = require("xmlua")

local path = arg[1]
local file = assert(io.open(path))

local parser = xmlua.HTMLSAXParser.new()

parser.start_document = function()
  print("Start document")
end

parser.start_element = function(local_name,
                                attributes)
  print("Start element: " .. local_name)
  if #attributes > 0 then
    print("  Attributes:")
    for i, attribute in pairs(attributes) do
      local name
      if attribute.prefix then
        name = attribute.prefix .. ":" .. attribute.local_name
      else
        name = attribute.local_name
      end
      if attribute.uri then
        name = name .. "{" .. attribute.uri .. "}"
      end
      print("    " .. name .. ": " .. attribute.value)
    end
  end
end

parser.end_element = function(local_name, prefix, uri)
  print("End element: " .. local_name)
  if prefix then
    print("  prefix: " .. prefix)
  end
  if uri then
    print("  URI: " .. uri)
  end
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
