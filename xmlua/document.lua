local Document = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Element = require("xmlua.element")

function Document.root(self)
  local root_element = libxml2.xmlDocGetRootElement(self.document)
  if not root_element then
    return nil
  end
  return Element.new(self.document, root_element)
end

return Document
