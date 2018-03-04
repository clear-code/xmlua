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

  * [`xmlua.Document`][document]: HTMLドキュメントとXMLドキュメント用のクラスです。

  * [`xmlua.Element`][element]: 要素ノード用のクラスです。

  * [`xmlua.NodeSet`][node-set]: 複数ノードを扱うためのクラスです。

`xmlua.HTML`と`xmlua.XML`、`xmlua.HTMLSAXParser`のみ直接アクセスできます。その他のクラスへは、`xmlua.HTML`と`xmlua.XML`、`xmlua.HTMLSAXParser`のメソッド経由でアクセスできます。

[tutorial]:../tutorial/

[xmlua]:xmlua.html

[document]:document.html

[serializable]:serializable.html

[searchable]:searchable.html

[html]:html.html

[html-sax-parser]:html-sax-parser.html

[xml]:xml.html

[element]:element.html

[node-set]:node-set.html
