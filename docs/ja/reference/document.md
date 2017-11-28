---
title: xmlua.Document
---

# `xmlua.Document`モジュール

## 概要

HTMLドキュメントとXMLドキュメントに共通の機能を提供します。

## Methods

### `root() -> xmlua.Element` {#root}

It returns the root element.

例：

```lua
require xmlua = require("xmlua")

local xml = xmlua.XML.parse("<root><sub/></root>")
xml:root() -- -> "<root>" element as xmlua.Element object
```

## 参照

  * [`xmlua.HTML`][html]: The class for HTML document.

  * [`xmlua.XML`][xml]: The class for XML document.

  * [`xmlua.Element`][element]: The class for element node.

[html]:html.html

[xml]:xml.html

[element]:element.html
