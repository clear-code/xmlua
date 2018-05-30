local Node = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

function Node:set_content(content)
  libxml2.xmlNodeSetContent(self.node, content)
  return
end

function Node:content()
  return libxml2.xmlNodeGetContent(self.node)
end

function Node:text()
  return ""
end

function Node:path()
  return libxml2.xmlGetNodePath(self.node)
end

function Node:unlink()
  return libxml2.xmlUnlinkNode(self.node)
end
return Node
