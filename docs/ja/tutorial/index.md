---
title: Tutorial
---

# チュートリアル

このドキュメントは、XMLuaの使い方を段階的に説明しています。まだ、XMLuaをインストールしていない場合は、このドキュメントを読む前にXMLuaを[インストール][install]してください。

## ドキュメントのパース {#parse-document}

XMLuaを使うために最初にドキュメントのパースをします。XMLuaはHTMLドキュメントとXMLドキュメントをサポートしています。

HTMLをパースするには、[`xmlua.HTML.parse`][html-parse]を使います。

例：

```lua
-- "xmlua"モジュールの読み込み
local xmlua = require("xmlua")

local html = [[
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>
    <p>World</p>
  </body>
</html>
]]

-- HTMLをパース
local document = xmlua.HTML.parse(html)

-- HTMLへのシリアライズ
print(document:to_html())
-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
-- <html>
--   <head>
-- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
--     <title>Hello</title>
--   </head>
--   <body>
--     <p>World</p>
--   </body>
-- </html>
```

XMLをパースするには、[`xmlua.XML.parse`][xml-parse]を使います。

例：

```lua
-- "xmlua"モジュールの読み込み
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]]

-- XMLをパース
local document = xmlua.XML.parse(xml)

-- XMLへのシリアライズ
print(document:to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub>text1</sub>
--   <sub>text2</sub>
--   <sub>text3</sub>
-- </root>
```

パースするHTMLまたは、XMLは`string`でなければなりません。ファイル内のHTMLやXMLをパースしたい場合は、自分でファイルの内容を読み込む必要があります。

例：

```lua
local xmlua = require("xmlua")

local xml_file = io.open("example.xml")
local xml = xml_file:read("*all")
xml_file:close()

local document = xmlua.XML.parse(xml)
```

`xmlua.HTML.parse`や`xmlua.XML.parse`は、失敗することがあります。例えば、不正なドキュメントを使った場合に失敗します。`xmlua.HTML.parse`や`xmlua.XML.parse`が失敗した場合は、エラーが発生します。

不正なドキュメントである可能性がある場合は、`pcall`を使ってエラーを処理する必要があります。

例：

```lua
local xmlua = require("xmlua")

local invalid_xml = "<root>"

-- 不正なXMLをパース
local success, document = pcall(xmlua.XML.parse, invalid_xml)

if success then
  print("Succeeded to parse XML")
else
  -- pcallが成功を返さない場合、パースされたドキュメントではなく
  -- エラーメッセージになります。
  local err = document
  print("Failed to parse XML: " .. err.message)
  -- -> Failed to parse XML: ./xmlua/xml.lua:15: Premature end of data in tag root line 1
end
```

パースしたHTML、パースしたXMLともにXMLuaの[`xmlua.Document`][document]オブジェクトとなり、同じ方法で操作できます。

## 要素の検索 {#search-element}

[XPath][xpath]を使って要素の検索ができます。[`xmlua.Searchable:search`][searchable-search]メソッドを使って要素の検索ができます。

[`xmlua.Document`][document]は[`xmlua.Searchable:search`][searchable-search]メソッドを使えます。

このメソッドは、[`xmlua.NodeSet`][node-set]オブジェクトを返します。[`xmlua.NodeSet`][node-set]オブジェクトは、通常の配列がもつ便利なメソッドが使えます。`#`や`[]`といった、機能を使うこともできます。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]]

local document = xmlua.XML.parse(xml)

-- <root>要素配下の全ての<sub>要素を検索します
local all_subs = document:search("/root/sub")

-- "#"を使ってマッチしたノードの数を出力できます。
print(#all_subs) -- -> 3

-- "[]"を使って、N番目のノードにアクセスできます。
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

[`xmlua.NodeSet`][node-set]オブジェクトも`search`メソッドを使えます。つまり、検索結果に対して検索をすることができます。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub class="A"><subsub1/></sub>
  <sub class="B"><subsub2/></sub>
  <sub class="A"><subsub3/></sub>
</root>
]]

local document = xmlua.XML.parse(xml)

-- 全ての<sub class="A">要素を検索
local class_a_subs = document:search("//sub[@class='A']")

-- <sub class="a">配下の全ての要素を検索
local subsubs_in_class_a = class_a_subs:search("*")

print(#subsubs_in_class_a) -- -> 2

-- /root/sub[@class="A"]/subsub1
print(subsubs_in_class_a[1]:to_xml())
-- <subsub1/>

-- /root/sub[@class="A"]/subsub3
print(subsubs_in_class_a[2]:to_xml())
-- <subsub3/>
```

`search`メソッドは、[`xmlua.NodeSet:search`][node-set-search]メソッドです。[`xmlua.Searchable:search`][searchable-search]メソッドではありません。

[`xmlua.Searchable:search`][searchable-search]メソッドは、要素に対しても使えます。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub>text1</sub>
  <sub>text2</sub>
  <sub>text3</sub>
</root>
]]

local document = xmlua.XML.parse(xml)

--<root>要素の検索
local roots = document:search("/root")
local root = roots[1]

-- <root>要素配下の全ての<sub>要素を検索します
local all_subs = root:search("sub")

-- "#"を使ってマッチしたノードの数を出力できます。
print(#all_subs) -- -> 3

-- "[]"を使って、N番目のノードにアクセスできます。
print(all_subs[1]:to_xml()) -- -> <sub1>text1</sub1>
print(all_subs[2]:to_xml()) -- -> <sub2>text2</sub2>
print(all_subs[3]:to_xml()) -- -> <sub3>text3</sub3>
```

`search`メソッドは、失敗することがあります。例えば、不正なXPathを使った場合に失敗します。`search`メソッドが失敗した場合は、エラーが発生します。

XPathが不正である可能性がある場合は、`pcall`を使ってエラーを処理する必要があります。

例：

```lua
local xmlua = require("xmlua")

local xml = "<root/>"

local document = xmlua.XML.parse(xml)

local invalid_xpath = "..."
local success, node_set = pcall(function()
  return document:search(invalid_xpath)
end)

if success then
  print("Succeeded to search by XPath")
else
  -- pcallが成功を返さない場合、ノードセットではなく
  -- エラーメッセージになります。
  local message = node_set
  print("Failed to search by XPath: " .. message)
  -- -> Failed to search by XPath: ./xmlua/searchable.lua:57: Invalid expression
end
```

## 属性値の取得 {#get-attribute-value}

要素の属性値を取得するには、[`xmlua.Element`][element]オブジェクトを取得する必要があります。

通常、`xmlua.Element`は[`xmlua.Document:root`][document-root]または、[`xmlua.Searchable:search`][searchable-search]を使って取得できます。

`xmlua.Document:root`は、ドキュメントのルート要素を返します。

`xmlua.Searchable:search`は、[`xmlua.NodeSet`][node-set]として、複数の要素を返します。`node_set[1]`とすることで、先頭の要素を取得できます。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root class='A'/>")

-- ルート要素の取得
local root = document:root()

-- ルート要素の取得
local root = document:search("/root")[1]
```

以下のいずれかを使って、属性値を取得できます。

  * `element.attribute_name`: ドット構文

  * `element["attribute_name"]`: `[]`構文

  * `element:get_attribute("attribute_name")`: メソッド構文

通常は、ドットか`[]`を用いた構文をおすすめします。

"`class`"のように属性名がLuaの識別子である場合は、ドットを用いた構文をおすすめします。

"`xml:lang`"のように属性名がLuaの識別子では無い場合は、`[]`を用いた構文をおすすめします。

`search`や`parent`のように`xmlua.Element`で使えるメソッド名と衝突している場合は、メソッドを用いた取得をおすすめします。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root class='A'/>")
local root = document:root()

-- ドットを使った属性値の取得
print(root.class)
-- -> A

-- []を使った属性値の取得
print(root["class"])
-- -> A

-- get_attributeメソッドを使った属性値の取得
print(root:get_attribute("class"))
-- -> A
```

指定した属性が存在しない場合は、`nil`を返します。

例：

```lua
local xmlua = require("xmlua")

local document = xmlua.XML.parse("<root class='A'/>")
local root = document:root()

-- 属性名が存在しないためnilが返ります。
print(root.nonexistent)
-- -> nil
```

属性が名前空間を持っている場合、`"xml:lang"`のように`"namespace-prefix:local-name"`構文を用いた属性名を使うことができます。このケースでは、`":"`が属性名に含まれているため、ドットを用いた構文は使えません。

指定した名前空間プレフィックスが存在しない場合は、指定した名前空間プレフィックス付きの属性名は、名前空間URIやローカル名ではなく属性名として扱われます。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root xmlns:example="http://example.com/"
      example:attribute="value-example"
      attribute="value"
      nonexistent-namespace:attribute="value-nonexistent-namespace"/>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()

-- 名前空間プレフィックスつき
print(root["example:attribute"])
-- -> value-example

-- 名前空間プレフィックスなし
print(root["attribute"])
-- -> value

-- 存在しない名前空間プレフィックスつき
print(root["nonexistent-namespace:attribute"])
-- -> value-nonexistent-namespace
```

## 要素の取得 {#get-elements}

兄弟要素を取得するには[`xmlua.Element:previous`][element-previous]と[`xmlua.Element:next`][element-next]を使います。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local sub2 = document:search("/root/sub2")[1]

-- <sub2>の1つ前の兄弟要素を取得
print(sub2:previous():to_xml())
-- <sub1/>

-- <sub2>の1つ後の兄弟要素を取得
print(sub2:next():to_xml())
-- <sub3/>
```

兄弟要素がない場合は`nil`を返します。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local sub1 = document:search("/root/sub1")[1]
local sub3 = document:search("/root/sub3")[1]

-- <sub1>の1つ前の兄弟要素を取得
print(sub1:previous())
-- nil

-- <sub3>の1つ後の兄弟要素を取得
print(sub3:next():to_xml())
-- nil
```

[`xmlua.Element:parent`][element-parent]で親要素を取得できます。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local sub2 = document:search("/root/sub2")[1]

-- <sub2>の親要素を取得
print(sub2:parent():to_xml())
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3/>
-- </root>

```

要素がルート要素のときは[`xmlua.Document`][document]を返します。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)
local root = document:root()

-- <root>の親要素を取得：xmlua.Document
print(root:parent():to_xml())
-- <?xml version="1.0" encoding="UTF-8"?>
-- <root>
--   <sub1/>
--   <sub2/>
--   <sub3/>
-- </root>

```

[`xmlua.Document:parent`][document-parent]もあります。このメソッドは常に`nil`を返します。一貫性のあるAPIにするためだけに存在しています。

例：

```lua
local xmlua = require("xmlua")

local xml = [[
<root>
  <sub1/>
  <sub2/>
  <sub3/>
</root>
]]

local document = xmlua.XML.parse(xml)

-- ドキュメントの親を取得
print(document:parent())
-- nil
```

## マルチスレッド {#multithread}

複数のスレッドでXMLuaを使えます。複数のスレッドで使うためのコードを追加する必要があります。

XMLuaを使うスレッドを作る前に、メインスレッドで[`xmlua.init`][xmlua-init]を呼ばなければいけません。

例：

```lua
local xmlua = require("xmlua")

-- 複数のスレッドでXMLuaを使う場合は
-- スレッドを作る前にメインスレッドでxmlua.initを呼ばないといけません。
xmlua.init()

local thread = require("cqueues.thread")
-- ...
```

XMLuaを使っているすべてのスレッドを終了し、XMLuaをもう使わない状態になった後なら、メインスレッドで[`xmlua.cleanup`][xmlua-cleanup]を呼べます。

例：

```lua
local xmlua = require("xmlua")

xmlua.init()

local thread = require("cqueues.thread")
-- ...

-- XMLuaが使っているすべてのリソースを開放するために
-- メインスレッドでxmlua.cleanupを呼べます。
-- 呼ぶときは、すべてのスレッドを終了して、XMLua関連のオブジェクトを今後
-- 絶対使わないようにしてください。
xmlua.cleanup()

os.exit()
```

GNU/Linux上でpthreadにリンクしていないLuaJITを動かすときは、`require("xmlua")`はスレッドセーフではありません。解決策は次の通りです。

  * `LD_PRELOAD`環境変数を使って`libpthread.so.0`をリンクする。

  * 同時に`require("xmlua")`を実行しない。

`LD_PRELOAD`を使うコマンドライン例は次の通りです。

Debian GNU/LinuxとUbuntuの場合：

```console
% LD_PRELOAD=/lib/x86_64-linux-gnu/libpthread.so.o luajit XXX.lua
```

CentOSの場合：

```console
% LD_PRELOAD=/lib64/libpthread.so.o luajit XXX.lua
```

[cqueues][cqueues]を使っている場合は、同時に`require("xmlua")`を実行するのを防ぐために`cqueues.thread.start`が返すコネクションを使えます。

例：

```lua
local xmlua = require("xmlua")
xmlua.init()

local thread = require("cqueues.thread")

local n = 10

local workers = {}
local connections = {}

for i = 1, n do
  local worker, connection = thread.start(function(connection)

    -- require("xmlua")はスレッドセーフではない
    local xmlua = require("xmlua")

    -- Notify that require("xmlua") is finished
    connection:write("ready\n")

    for job in connection:lines("*l") do
      -- local html = ...
      -- local document = xmlua.HTML.parse(html)
      -- document:search("...")
    end
  end)

  -- require("xmlua")が終了するまで待つ
  connection:read("*l")

  table.insert(workers, worker)
  table.insert(connections, connection)
end

for _, connection in ipairs(connections) do

  -- Put jobs to workers
  connection:write("Job1\n")
  connection:write("Job2\n")
  -- ...

end

for _, connection in ipairs(connections) do

  -- ジョブの投入を終了
  connection:close()

end

for _, worker in ipairs(workers) do
  worker:join()
end

xmlua.cleanup()
```

## 次のステップ {#next-step}

これでXMLuaのすべての主な機能を学びました！それぞれの機能をより理解したい場合は、各機能の[リファレンスマニュアル][reference]を見てください。


[install]:../install/

[html-parse]:../reference/html.html#parse

[xml-parse]:../reference/xml.html#parse

[document]:../reference/document.html

[xpath]:https://www.w3.org/TR/xpath/

[searchable-search]:../reference/searchable.html#search

[node-set]:../reference/node-set.html

[node-set-search]:../reference/node-set.html#search

[element]:../reference/element.html

[document-root]:../reference/document.html#root

[element-previous]:../reference/element.html#previous

[element-next]:../reference/element.html#next

[element-parent]:../reference/element.html#parent

[document-parent]:../reference/document.html#parent

[xmlua-init]:../reference/xmlua.html#init

[xmlua-cleanup]:../reference/xmlua.html#cleanup

[cqueues]:http://25thandclement.com/~william/projects/cqueues.html

[reference]:../reference/
