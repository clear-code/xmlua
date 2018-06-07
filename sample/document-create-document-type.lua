#!/usr/bin/env luajit

local xmlua = require("xmlua")

--Specify a location by PublicID
local document = xmlua.XML.build({})
local document_type =
  document:create_document_type("TestDocumentDecl",
                                "-//Test/Sample/EN",
                                "//test.dtd")
print(document:to_xml())
--<?xml version="1.0" encoding="UTF-8"?>
--<!DOCTYPE TestDocumentDecl PUBLIC "-//Test/Sample/EN" "//system.dtd">
