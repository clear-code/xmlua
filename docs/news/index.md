---
title: News
---

# News

## 1.1.8: 2020-06-09 {#version-1-1-8}

### Fixes

  * `xmlua.libxml2.xmlUnlinkNode()`:

    * Ensured removing reference to document from an unlinked node. [GitHub#24][Reported by Arturas M.]

### Thanks

* Arturas M.

## 1.1.7: 2020-06-08 {#version-1-1-7}

### Fixes

  * `xmlua.Element:add_child()`:

    * Fixed a double free bug when unlinked element is added. [GitHub#24][Reported by Arturas M.]

### Thanks

* Arturas M.

## 1.1.6: 2020-04-14 {#version-1-1-6}

### Fixes

  * `xmlua.libxml2`:

    * Fixed a double free bug when setting a namespace. [GitHub#22][Reported by edo]

### Thanks

* edo

## 1.1.5: 2020-02-26 {#version-1-1-5}

### Improvements

  * `xmlua.serializable`:

    * Added `escape` option to `to_html()` and `to_xml()`.

  * `xmlua.xml`:

    * Added `parse_options` options to `XML.parse()`.

### Fixes

  * `xmlua.Node`:

    * Fixed `set_content()` does not handle c-strings.
      * Use `xmlNodeSetContentLen()` instead of `xmlNodeSetContent()`.
        * Because Lua string may not be finished by `'\0'`.

## 1.1.4: 2018-10-03 {#version-1-1-4}

### Improvements

  * `xmlua.Searchable.xpath_search()`: Added.
    * It's an alias of `Searchable:search`.
    * Added for LuaWebDriver compatibility.
  * `xmlua.HTMLSAXParser`:
    * We modified to keep backward compatibility with libxml2 2.9.5 or later.

## 1.1.3: 2018-06-07 {#version-1-1-3}

### Fixes

  * `xmlua.DocumentFragment`: Fixed a bug that accidentally returned element node.

  * `xmlua.libxml2`:

    * Fix a bug that unintentionally set to `jit.off` in all modules.

    * Fix a bug that replaced nodes are not released.

## 1.1.2: 2018-06-06 {#version-1-1-2}

### Improvements

  * `xmlua.Document`: Added below functions.

    * `create_cdata_section()`

    * `create_comment()`

    * `create_processing_instruction()`

    * `create_namespace()`

  * `xmlua.Element`: Added below functions.

    * `add_child()`

    * `add_previous_sibling()`

    * `add_sibling()`

    * `add_next_sibling()`

    * `find_namespace()`

  * `xmlua.Node.replace_node()` Added.

  * `xmlua.Text.concat()` Added.

  * `xmlua.Text.merge()` Added.

## 1.1.1: 2018-04-16 {#version-1-1-1}

### Fixes

  * `xmlua.Document`: Fix bug that `add_entity` returns `xmlEntity` of libxml2.

  * `xmlua.Document`: Fix bug that `add_dtd_entity` returns `xmlEntity` of libxml2.

## 1.1.0: 2018-04-13 {#version-1-1-0}

### Fixes

  * `rockspec`: Fix a bug that installation failed.

## 1.0.9: 2018-04-13 {#version-1-0-9}

### Improvements

  * `xmlua.XMLSAXParser`: Added supported events:

    * `start_document`

    * `end_document`

    * `start_element`

    * `end_element`

    * `element declaration`

    * `attribute declaration`

    * `unparsed entity declaration`

    * `notation declaration`

    * `entity declaration`

    * `internal subset`

    * `external subset`

    * `comment`

    * `text`

    * `reference`

    * `ignorable_whitespace`

    * `cdata_block`

    * `processing_instruction`

    * `warning`

    * `error`

  * `xmlua.HTMLSAXParser`: Added supported events:

    * `start_document`

    * `end_document`

    * `start_element`

    * `end_element`

    * `comment`

    * `ignorable_whitespace`

    * `cdata_block`

    * `processing_instruction`

    * `error`


## 1.0.8: 2018-04-03 {#version-1-0-8}

### Fixes

  * `rockspec`: Fix a bug that installation failed.

## 1.0.7: 2018-04-03 {#version-1-0-7}

### Improvements

  * `xmlua.HTML.build()`: Added.

## 1.0.6: 2018-04-02 {#version-1-0-6}

### Fixes

  * `xmlua.Element:insert_element()`: Fixed a bug that
    `insert_element(1)` with empty element raises an error.

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

  * `xmlua.XML.build()`: Added.

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

## 1.0.1: 2017-12-04 {#version-1-0-1}

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
