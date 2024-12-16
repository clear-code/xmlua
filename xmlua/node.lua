local Node = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

function Node:replace(replace_node)
  if not self.node and not replace_node.node then
    error("Already freed receiver node and replace node")
  elseif not self.node then
    error("Already freed receiver node")
  elseif not replace_node.node then
    error("Already freed replace node")
  end

  local was_freed =
    libxml2.xmlReplaceNode(self.node, replace_node.node)
  if was_freed then
    self.node = nil
  end
end

function Node:set_content(content)
  libxml2.xmlNodeSetContent(self.node, content)
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
