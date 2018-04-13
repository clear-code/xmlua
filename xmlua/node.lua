local Node = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

function Node:content()
  return libxml2.xmlNodeGetContent(self.node)
end

function Node:path()
  return libxml2.xmlGetNodePath(self.node)
end

function Node:unlink()
  return libxml2.xmlUnlinkNode(self.node)
end
return Node
