#!/usr/bin/env luajit

local xmlua = require("xmlua")

local file = assert(io.open(arg[1]))
local html = file:read("*all")
file:close()

-- Parses HTML
local success, document = pcall(xmlua.HTML.parse, html, {prefer_charset = true})
if not success then
  local message = document
  print("Failed to parse HTML: " .. message)
  os.exit(1)
end

print(document:encoding())

print("title: " .. document:search("/html/head/title"):text())
