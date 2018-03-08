#!/usr/bin/env luajit

local xmlua = require("xmlua")

local path = arg[1]
local file = assert(io.open(path))

local parser = xmlua.XMLSAXParser.new()

parser.start_document = function()
  print("Start document")
end

parser.external_subset = function(name,
                                  external_id,
                                  system_id)
  print("External subset name: ".. name)
  print("External subset external id: ".. external_id)
  print("External subset system id: ".. system_id)
end

parser.cdata_block = function(cdata_block)
  print("CDATA block: ".. cdata_block)
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
