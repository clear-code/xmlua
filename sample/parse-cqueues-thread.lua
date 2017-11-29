#!/usr/bin/env luajit

local thread = require("cqueues.thread")

local n = 10

local workers = {}
local connections = {}

for i = 1, n do
  local worker, connection = thread.start(function(connection)
      -- require("xmlua") isn't thread safe.
      local xmlua = require("xmlua")
      -- Notify that require("xmlua") is finished.
      connection:write("ready\n")

      for path in connection:lines("*l") do
        local file = io.open(path)
        local html = file:read("*all")
        file:close()

        local success, document = pcall(xmlua.HTML.parse, html)
        if success then
          print(path .. ": " .. document:search("//title")[1]:to_html())
        else
          local err = document
          print(path .. ": Failed to parse: " .. err.message)
        end
      end
  end)
  -- Wait until require("xmlua") is finished.
  connection:read("*l")
  table.insert(workers, worker)
  table.insert(connections, connection)
end

for i = 1, #arg do
  for _, connection in ipairs(connections) do
    connection:write(arg[i] .. "\n")
  end
end

for _, connection in ipairs(connections) do
  connection:close()
end

for _, worker in ipairs(workers) do
  worker:join()
end
