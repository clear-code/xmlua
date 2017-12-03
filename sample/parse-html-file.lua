#!/usr/bin/env luajit

local xmlua = require("xmlua")

local path = arg[1]
local file = assert(io.open(path))
local html = file:read("*all")
file:close()

-- Parses HTML
local success, document = pcall(xmlua.HTML.parse, html, {prefer_charset = true})
if not success then
  local message = document
  print("Failed to parse HTML: " .. message)
  os.exit(1)
end

print("Encoding: " .. document:encoding())

print("Title: " .. document:search("/html/head/title"):text())

if #document.errors > 0 then
  print()
  for i, err in ipairs(document.errors) do
    print("Error" .. i .. ":")
    print(path .. ":" .. err.line .. ":" .. err.message)
  end
end
