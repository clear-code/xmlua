---
title: Reference manual
---

# リファレンスマニュアル

このドキュメントは全ての機能について記載しています。[チュートリアル][tutorial]は、重要な機能について簡単に理解できる事に重点をおいています。このドキュメントは網羅性を重視しています。まだ、[チュートリアル][tutorial]を読んでいないのであれば、このドキュメントを読む前にチュートリアルを読んでください。

## モジュール {#modules}

XMLuaには1つだけ公開モジュールがあります。それは`xmlua`メインモジュールです。

  * [`xmlua`][xmlua]: メインモジュール。

## 内部モジュール {#internal-modules}

XMLuaは共通の機能を提供する内部メソッドがあります。これらは、APIとして公開されていませんが、[`xmlua.HTML`][html]や[`xmlua.Element`][element]のような公開クラス経由で使うことができます。

  * [`xmlua.Serializable`][serializable]: HTML・XMLへのシリアライズ関連のメソッドを提供します。

  * [`xmlua.Searchable`][searchable]: ノード検索関連のメソッドを提供します。

## クラス {#classes}

XMLuaは以下のクラスを提供します。

  * [`xmlua.HTML`][html]: HTMLをパースするクラスです。

  * [`xmlua.HTMLSAXParser`][html-sax-parser]: HTML のSAXパーサークラスです。

  * [`xmlua.XML`][xml]: XMLをパースするクラスです。

  * [`xmlua.XMLSAXParser`][xml-sax-parser]: XMLのSAXパーサークラスです。

  * [`xmlua.XMLStreamSAXParser`][xml-stream-sax-parser]: 同じファイル内に複数のルート要素を持つXML用のSAXパーサークラスです。

  * [`xmlua.CDATASection`][cdata-section]: CDATASectionノード用のクラスです。

  * [`xmlua.Element`][element]: コメントノード用のクラスです。

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。

  * [`xmlua.DocumentFragment`][document-fragment]: ドキュメントフラグメントノード用のクラスです。

  * [`xmlua.DocumentType`][document-type]: ドキュメントタイプノード用のクラスです。

  * [`xmlua.Element`][element]: 要素ノード用のクラスです。

  * [`xmlua.Namespace`][namespace]: 名前空間ノード用のクラスです。

  * [`xmlua.Node`][node]: 各ノードに共通のメソッドを提供するクラスです。

  * [`xmlua.NodeSet`][node-set]: 複数ノードを扱うためのクラスです。

  * [`xmlua.ProcessingInstruction`][processing-instruction]: 処理命令ノード用のクラスです。

  * [`xmlua.Text`][text]: テキストノード用のクラスです。

`xmlua.HTML`と`xmlua.XML`、`xmlua.HTMLSAXParser`のみ直接アクセスできます。その他のクラスへは、`xmlua.HTML`と`xmlua.XML`、`xmlua.HTMLSAXParser`のメソッド経由でアクセスできます。

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

[document-fragment]:document-fragment

[document-type]:document-type

[namespace]:namespace

[processing-instruction]:processing-instruction
