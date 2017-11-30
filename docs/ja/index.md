---
title: none
---

<div class="jumbotron">
  <h1>XMLua</h1>
  <p>{{ site.description.ja }}</p>
  <p>最新版（<a href="news/#version-{{ site.version | replace:".", "-" }}">{{ site.version }}</a>）は{{ site.release_date }}にリリースされました。
  </p>
  <p>
    <a href="tutorial/"
       class="btn btn-primary btn-lg"
       role="button">チュートリアルをやってみる</a>
    <a href="install/"
       class="btn btn-primary btn-lg"
       role="button">インストール</a>
  </p>
</div>

## XMLuaについて {#about}

XMLuaはXML・HTMLを処理するLuaライブラリーです。[libxml2](http://xmlsoft.org/)を使っています。LuaJITのFFIモジュールを使って実装しています。

XMLuaはlibxml2の生のAPIではなく、使いやすいAPIを提供します。使いやすいAPIは生のlibxml2のAPIの上に実装しています。

## ドキュメント {#documentations}

  * [おしらせ](news/): リリース情報。

  * [インストール](install/): XMLuaのインストール方法。

  * [チュートリアル](tutorial/): XMLuaの使い方を1つずつ説明。

  * [リファレンス](reference/): クラスやメソッドなど個別の機能の詳細な説明。

## ライセンス {#license}

XMLuaのライセンスは[MITライセンス](https://opensource.org/licenses/mit)です。

著作権保持者など詳細は[LICENSE](https://github.com/clear-code/xmlua/blob/master/LICENSE)ファイルを見てください。
