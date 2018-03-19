---
title: xmlua
---

# `xmlua`モジュール

## 概要

メインモジュールです。

## モジュール関数

### `init() -> nil` {#init}

XMLuaを明示的に初期化します。XMLuaは暗黙的に初期化されるので、通常、呼ぶ必要はありません。

マルチスレッドに対応するときに必要になります。

複数のスレッドでXMLuaを使いたいときは、スレッドを作る前にメインスレッドで`xmlua.init`を呼ばなければいけません。

例：

```lua
local xmlua = require("xmlua")

-- 複数のスレッドでXMLuaを使う場合は
-- スレッドを作る前にメインスレッドでxmlua.initを呼ばないといけません。
xmlua.init()

local thread = require("cqueues.thread")

-- thread.start(function() ... end)
```

### `cleanup() -> nil` {#cleanup}

XMLuaが使っているすべてのリソースを解放します。通常、呼ぶ必要はありません。なぜなら、これを呼びたいときはプロセスが終了する直前だからです。

メインスレッドで呼ばないといけません。

呼ぶときは、すべてのスレッドを終了し、すべてのXMLua関連のオブジェクトをこれ以上触らないようにしないといけません。

例：

```lua
local xmlua = require("xmlua")

-- local xml = ...
-- local document = xmlua.XML.parse(xml)
-- document:search(...)

-- XMLuaが使っているすべてのリソースを開放するために
-- メインスレッドでxmlua.cleanupを呼べます。
-- 呼ぶときは、すべてのスレッドを終了して、XMLua関連のオブジェクトを今後
-- 絶対使わないようにしてください。
xmlua.cleanup()

os.exit()
```

## 参照

  * [チュートリアルのマルチスレッドセクション][tutorial-multithread]


[tutorial-multithread]:../tutorial/#multithread
