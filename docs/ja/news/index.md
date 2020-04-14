---
title: おしらせ
---

# おしらせ

## 1.1.6: 2020-04-14 {#version-1-1-6}

### 修正

  * `xmlua.libxml2`:

    * ネームスペースを設定する際にダブルフリーしてしまう問題を修正しました。 [GitHub#22][edoさんによる報告]

### 感謝

* edoさん

## 1.1.5: 2020-02-26 {#version-1-1-5}

### 改善

  * `xmlua.serializable`:

    * `to_html()`と`to_xml()`に`escape`オプションを追加しました。

  * `xmlua.xml`:

    * `XML.parse()`に`parse_options`オプションを追加しました。

### 修正

  * `xmlua.Node`:

    * `set_content()`がCの文字列を処理しない問題を修正しました。
      * `xmlNodeSetContent()`の代わりに`xmlNodeSetContentLen()`を使用するようにしました。
        * Luaの文字列は`'\0'`で終端しないことがあるためです。

## 1.1.4: 2018-10-03 {#version-1-1-4}

### 改善

  * `xmlua.Searchable.xpath_search()`: 追加
    * `Searchable:search`のエイリアスです。
    * LuaWebDriverとの互換性のために追加されました。
  * `xmlua.HTMLSAXParser`:
    * libxml2 2.9.5 以降との下位互換性を維持するよう変更しました。

## 1.1.3: 2018-06-07 {#version-1-1-3}

### 修正

  * `xmlua.DocumentFragment`: 誤ってelement nodeを返却するバグを修正しました。

  * `xmlua.libxml2`:

    * 全てのモジュールで意図せず、`jit.off`を設定したバグを修正しました。

    * 置き換えられたノードが解放されないバグを修正しました。

## 1.1.2: 2018-06-06 {#version-1-1-2}

### 改善

  * `xmlua.Document`: 以下の関数を追加しました。

    * `create_cdata_section()`

    * `create_comment()`

    * `create_processing_instruction()`

    * `create_namespace()`

  * `xmlua.Element`: 以下の関数を追加しました。

    * `add_child()`

    * `add_previous_sibling()`

    * `add_sibling()`

    * `add_next_sibling()`

    * `find_namespace()`

  * `xmlua.Node.replace_node()` 追加

  * `xmlua.Text.concat()` 追加

  * `xmlua.Text.merge()` 追加

## 1.1.1: 2018-04-16 {#version-1-1-1}

### 修正

  * `xmlua.Document`: `add_entity` がlibxml2の `xmlEntity` を返すバグを修正しました。

  * `xmlua.Document`: `add_dtd_entity` がlibxml2の `xmlEntity` を返すバグを修正しました。

## 1.1.0: 2018-04-13 {#version-1-1-0}

### 修正

  * `rockspec`: インストールに失敗するバグを修正しました。

## 1.0.9: 2018-04-13 {#version-1-0-9}

### 改善

  * `xmlua.XMLSAXParser`: サポートするイベントを追加しました:

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

  * `xmlua.HTMLSAXParser`: サポートするイベントを追加しました:

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

### 修正

  * `rockspec`: インストールに失敗するバグを修正しました。

## 1.0.7: 2018-04-03 {#version-1-0-7}

### 改善

  * `xmlua.HTML.build()`: 追加

## 1.0.6: 2018-04-02 {#version-1-0-6}

### 修正

  * `xmlua.Element:insert_element()`: `insert_element(1)` が空の要素の時にエラーが発生するバグを修正しました。

## 1.0.5: 2018-03-30 {#version-1-0-5}

### 改善

  * `xmlua.NodeSet:insert()`: 追加

  * `xmlua.NodeSet:remove()`: 追加

  * `xmlua.NodeSet:merge()`: 追加

  * `xmlua.NodeSet:unlink()`: 追加

  * `xmlua.Element:append_element()`: 追加

  * `xmlua.Element:insert_element()`: 追加

  * `xmlua.Element:unlink()`: 追加

  * `xmlua.Element:set_attribute()`: 追加

  * `xmlua.Element:remove_attribute()`: 追加

  * `xmlua.XML.build()`: 追加

## 1.0.4: 2018-03-19 {#version-1-0-4}

### 改善

  * `xmlua.libxml2.VERSION`: 追加

  * 実験的: `xmlua.HTMLSAXParser`: サポートするイベントを追加しました。:

    * `start_document`

    * `end_document`

    * `comment`

    * `ignorable_whitespace`

    * `cdata_block`

    * `processing_instruction`

  * 実験的: `xmlua.HTMLSAXParser`: 以下のイベントから必要のない名前空間の情報を削除しました。

    * `start_element`

    * `end_element`

  * 実験的: `xmlua.XMLSAXParser`: 追加

  * `xmlua.Node:path()`: 追加

  * `xmlua.NodeSet:paths()`: 追加

  * `xmlua.Searchable.css_select()`: 追加

## 1.0.3: 2017-12-14 {#version-1-0-3}

### 改善

  * 実験的: `xmlua.HTMLSAXParser`: 追加

### 修正

  * XMLをパース中のメモリリークを修正しました。

  * ドキュメントをパース中のメモリリークを修正しました。

## 1.0.2: 2017-12-05 {#version-1-0-2}

### 修正

  * パッケージを修正しました。

## 1.0.1: 2017-12-04 {#version-1-0-1}

### 改善

  * `xmlua.HTML.parse()`: HTMLを荒くパースするよう変更しました。

  * `xmlua.HTML.parse()`: ベースURLを指定するための `url` オプションを追加しました。

  * `xmlua.HTML.parse()`: HTMLエンコーディングを指定するための `encoding` オプションを追加しました。

  * `xmlua.Node:content()`: 追加

  * `xmlua.NodeSet:content()`: 追加

  * `xmlua.Element:text()`: 追加

  * `xmlua.NodeSet:text()`: 追加

  * `//text()` XPathのサポートを追加しました。

  * `xmlua.HTML.parse()`: `prefer_meta_charset` オプションを追加しました。

  * `xmlua.Document:errors`: 追加

### 修正

  * XMLドキュメントパース中のメモリリークを修正しました。

## 1.0.0: 2017-11-29 {#version-1-0-0}

最初のリリースです！！！
