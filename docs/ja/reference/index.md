---
title: Reference manual
---

# リファレンスマニュアル

このドキュメントは全ての機能について記載しています。[Tutorial][tutorial]は、重要な機能について簡単に理解できる事に重点をおいています。このドキュメントは網羅性を重視しています。まだ、[Tutorial][tutorial]を読んでいないのであれば、このドキュメントを読む前にTutorialを読んでください。

## 内部モジュール

XMLuaは共通の機能を提供する内部メソッドがあります。これらは、パブリックなAPIへエクスポートされませんが、[`xmlua.HTML`][html]や[`xmlua.Element`][element]のようなパブリッククラス経由で使うことができます。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。

## Classes {#classes}

XMLua provides the following classes:

  * [`xmlua.HTML`][html]: HTMLをパースするクラスです。

  * [`xmlua.XML`][xml]: XMLをパースするクラスです。

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。

  * [`xmlua.Element`][element]: 要素ノード用のクラスです。

  * [`xmlua.NodeSet`][node-set]: 複数ノードを扱うためのクラスです。

You can access only `xmlua.HTML` and `xmlua.XML` directly. Other classes are accessible via methods of `xmlua.HTML` and `xmlua.XML.

[tutorial]:../tutorial/

[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html

[html]:html.html

[xml]:xml.html

[element]:element.html

[node-set]:node-set.html
