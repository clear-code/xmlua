local xmlua = {}

xmlua.VERSION = "0.9.0"

xmlua.libxml2 = require("xmlua.libxml2")
xmlua.XML = require("xmlua.xml")
xmlua.HTML = require("xmlua.html")

local Document = require("xmlua.document")
Document.lazy_load()
Document.lazy_load = nil

local Searchable = require("xmlua.searchable")
Searchable.lazy_load()
Searchable.lazy_load = nil

return xmlua
