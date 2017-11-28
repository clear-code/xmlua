---
title: Reference manual
---

# Reference manual

This document describes about all features. [Tutorial][tutorial] focuses on easy to understand only about important features. This document focuses on completeness. If you don't read [tutorial][tutorial] yet, read tutorial before read this document.

## Internal modules {#internal-modules}

XMLua has internal modules to provide common methods. They aren't exported into public API but you can use them via public classes such as [`xmlua.HTML`][html] and [`xmlua.Element`][element].

  * [`xmlua.Serializable`][serializable]: Provides HTML and XML serialization related methods.

  * [`xmlua.Searchable`][searchable]: Provides node search related methods.

## Classes {#classes}

XMLua provides the following classes:

  * [`xmlua.HTML`][html]: The class for parsing HTML.

  * [`xmlua.XML`][xml]: The class for parsing XML.

  * [`xmlua.Document`][document]: The class for HTML document and XML document.

  * [`xmlua.Element`][element]: The class for element node.

  * [`xmlua.NodeSet`][node-set]: The class for multiple nodes.

You can access only `xmlua.HTML` and `xmlua.XML` directly. Other classes are accessible via methods of `xmlua.HTML` and `xmlua.XML.

[tutorial]:../tutorial/

[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html

[html]:html.html

[xml]:xml.html

[element]:element.html

[node-set]:node-set.html
