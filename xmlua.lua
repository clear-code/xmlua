local xmlua = {}

xmlua.libxml2 = require("xmlua.libxml2")
xmlua.XML = require("xmlua.xml")
xmlua.HTML = require("xmlua.html")

local Searchable = require("xmlua.searchable")
Searchable.lazy_load()
Searchable.lazy_load = nil

return xmlua
