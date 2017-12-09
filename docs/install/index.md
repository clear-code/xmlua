---
title: Install
---

# Install

This document how to install XMLua on the following platforms:

  * [Debian GNU/Linux](#debian)

  * [Ubuntu](#ubuntu)

  * [CentOS](#centos)

  * [macOS](#macos)

You must install [LuaJIT][luajit] and [LuaRocks][luarocks] before installing XMLua.

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

For CentOS 6 x86_64:

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
