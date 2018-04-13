#!/usr/bin/env luajit

local xmlua = require("xmlua")

local path = arg[1]
local file = assert(io.open(path))

local parser = xmlua.XMLSAXParser.new()

parser.is_pedantic = true
parser.warning = function(message)
  print("Warning message: " .. message)
  print("Pedantic :", parser.is_pedantic)
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
