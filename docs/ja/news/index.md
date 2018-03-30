---
title: おしらせ
---

# おしらせ

## 1.0.5: 2018-03-30 {#version-1-0-5}

### Improvements

  * `xmlua.NodeSet:insert()`: Added.

  * `xmlua.NodeSet:remove()`: Added.

  * `xmlua.NodeSet:merge()`: Added.

  * `xmlua.NodeSet:unlink()`: Added.

  * `xmlua.Element:append_element()`: Added.

  * `xmlua.Element:insert_element()`: Added.

  * `xmlua.Element:unlink()`: Added.

  * `xmlua.Element:set_attribute()`: Added.

  * `xmlua.Element:remove_attribute()`: Added.

  * `xmlua.XML:build()`: Added.

## 1.0.4: 2018-03-19 {#version-1-0-4}

### Improvements

  * `xmlua.libxml2.VERSION`: Added.

  * Experimental: `xmlua.HTMLSAXParser`: Added supported events:

    * `start_document`

    * `end_document`

    * `comment`

    * `ignorable_whitespace`

    * `cdata_block`

    * `processing_instruction`

  * Experimental: `xmlua.HTMLSAXParser`: Removed needless namespace information from the following events.

    * `start_element`

    * `end_element`

  * Experimental: `xmlua.XMLSAXParser`: Added.

  * `xmlua.Node:path()`: Added.

  * `xmlua.NodeSet:paths()`: Added.

  * `xmlua.Searchable.css_select()`: Added.

## 1.0.3: 2017-12-14 {#version-1-0-3}

### Improvements

  * Experimental: `xmlua.HTMLSAXParser`: Added.

### Fixes

  * Fixed a memory leak for parsing XML.

  * Fixed a memory leak for parsed document.

## 1.0.2: 2017-12-05 {#version-1-0-2}

### Fixes

  * Fixed package.

## 1.0.1: 2017-12-04 {#version-1-0-2}

### Improvements

  * `xmlua.HTML.parse()`: Changed to parse HTML rough.

  * `xmlua.HTML.parse()`: Added `url` option that specifies base URL.

  * `xmlua.HTML.parse()`: Added `encoding` option that specifies HTML encoding.

  * `xmlua.Node:content()`: Added.

  * `xmlua.NodeSet:content()`: Added.

  * `xmlua.Element:text()`: Added.

  * `xmlua.NodeSet:text()`: Added.

  * Added `//text()` XPath support.

  * `xmlua.HTML.parse()`: Added `prefer_meta_charset` option.

  * `xmlua.Document:errors`: Added.

### Fixes

  * Fixed a memory leak of parsed XML document.

## 1.0.0: 2017-11-29 {#version-1-0-0}

The first release!!!
