---
title: xmlua
---

# `xmlua` module

## Summary

It's the main module.

## Module functions

### `init() -> nil` {#init}

It initializes XMLua implicitly. Normally, you don't need to call it because XMLua is initialized explicitly.

It's needed for supporting multithread.

If you want to use XMLua in multiple threads, you must call `xmlua.init` in the main thread before you create any thread.

Example:

```lua
local xmlua = require("xmlua")

-- You must call xmlua.init in main thread before you create threads
-- when you use XMLua with multiple threads.
xmlua.init()

local thread = require("cqueues.thread")

-- thread.start(function() ... end)
```

### `cleanup() -> nil` {#cleanup}

It frees all resources used by XMLua. Normally, you don't need to call it because your process will be exited soon when you want to call it.

You must call it in the main thread.

You must ensure that all threads are finished and all XMLua related objects aren't used anymore when you call it.

Example:

```lua
local xmlua = require("xmlua")

-- local xml = ...
-- local document = xmlua.XML.parse(xml)
-- document:search(...)

-- You can call xmlua.cleanup in main thread to free all resources
-- used by XMLua. You must ensure that all threads are finished and
-- all XMLua related objects aren't used anymore.
xmlua.cleanup()

os.exit()
```

## See also

  * [Multithread section in Tutorial][tutorial-multithread]


[tutorial-multithread]:../tutorial/#multithread
