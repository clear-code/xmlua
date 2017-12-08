#!/usr/bin/env luajit

local xmlua = require("xmlua")

local path = arg[1]
local file = assert(io.open(path))
local xml = file:read("*all")
file:close()

-- Parses XML
local success, document = pcall(xmlua.XML.parse, xml)
if not success then
  local message = document
  print("Failed to parse XML: " .. message)
  os.exit(1)
end

print("Root element: " .. document:root():name())

if #document.errors > 0 then
  print()
  for i, err in ipairs(document.errors) do
    print("Error" .. i .. ":")
    print(path .. ":" .. err.line .. ":" .. err.message)
  end
end
