local Node = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

function Node.content(self)
  return libxml2.xmlNodeGetContent(self.node)
end

function Node.path(self)
  return libxml2.xmlGetNodePath(self.node)
end

return Node
