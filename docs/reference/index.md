---
title: Reference manual
---

# Reference manual

This document describes about all features. [Tutorial][tutorial] focuses on easy to understand only about important features. This document focuses on completeness. If you don't read [tutorial][tutorial] yet, read tutorial before read this document.

## Modules {#modules}

XMLua has only one public modules. It's `xmlua` main module.

  * [`xmlua`][xmlua]: The main module.

## Internal modules {#internal-modules}

XMLua has internal modules to provide common methods. They aren't exported into public API but you can use them via public classes such as [`xmlua.HTML`][html] and [`xmlua.Element`][element].

  * [`xmlua.Serializable`][serializable]: Provides HTML and XML serialization related methods.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.

## Classes {#classes}

XMLua provides the following classes:

  * [`xmlua.HTML`][html]: The class for parsing HTML.

  * [`xmlua.HTMLSAXParser`][html-sax-parser]: The class for HTML SAX parsing.

  * [`xmlua.XML`][xml]: The class for parsing XML.

  * [`xmlua.XMLSAXParser`][xml-sax-parser]: The class for XML SAX parsing.

  * [`xmlua.XMLStreamSAXParser`][xml-stream-sax-parser]: The class for XML SAX parsing with multiple root elements in same file.

  * [`xmlua.CDATASection`][cdata-section]: The class for cdata section node.

  * [`xmlua.Comment`][comment]: The class for comment node.

  * [`xmlua.Document`][document]: The class for HTML document and XML document.

  * [`xmlua.DocumentFragment`][document-fragment]: The class for document fragment node.

  * [`xmlua.DocumentType`][document-type]: The class for document type node.

  * [`xmlua.Element`][element]: The class for element node.

  * [`xmlua.Namespace`][namespace]: The class for namespace node.

  * [`xmlua.Node`][node]: It's a class that provides a common method for each node.

  * [`xmlua.NodeSet`][node-set]: The class for multiple nodes.

  * [`xmlua.ProcessingInstruction`][processing-instruction]: The class for processing instruction node.

  * [`xmlua.Text`][text]: The class for text nodes.

You can access only `xmlua.HTML` and `xmlua.XML`, `xmlua.HTMLSAXParser` directly. Other classes are accessible via methods of `xmlua.HTML` and `xmlua.XML`, `xmlua.HTMLSAXParser`.

[tutorial]:../tutorial/

[xmlua]:xmlua.html

[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html

[html]:html.html

[html-sax-parser]:html-sax-parser.html

[xml]:xml.html

[xml-sax-parser]:xml-sax-parser.html

[xml-stream-sax-parser]:xml-stream-sax-parser.html

[element]:element.html

[node]:node.html

[node-set]:node-set.html

[text]:text.html

[cdata-section]:cdata-section.html

[comment]:comment.html

[document-fragment]:docuemnt-fragment

[document-type]:document-type

[namespace]:namespace

[processing-instruction]:processing-instruction
