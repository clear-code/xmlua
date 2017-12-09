---
title: インストール
---

# インストール

このドキュメントでは次のプラットフォーム上でXMLuaをインストールする方法を説明します。

  * [Debian GNU/Linux](#debian)

  * [Ubuntu](#ubuntu)

  * [CentOS](#centos)

  * [macOS](#macos)

XMLuaをインストールする前に[LuaJIT][luajit]と[LuaRocks][luarocks]をインストールしておいてください。

## Debian GNU/Linux {#debian}

```console
% sudo apt install -y -V libxml2
% sudo luarocks install xmlua
```

## Ubuntu {#ubuntu}

```console
% sudo apt install -y -V libxml2
% sudo luarocks install xmlua
```

## CentOS {#centos}

```console
% sudo yum install -y libxml2
% sudo luarocks install xmlua
```

CentOS 6 x86_64の場合：

```console
% sudo yum install -y libxml2
% sudo luarocks install xmlua LIBXML2_LIBDIR=/usr/lib64
```

## macOS {#macos}

```console
% brew install libxml2
% sudo luarocks install xmlua
```


[luajit]:http://luajit.org/

[luarocks]:https://luarocks.org/
