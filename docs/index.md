---
title: none
---

<div class="jumbotron">
  <h1>XMLua</h1>
  <p>{{ site.description.en }}</p>
  <p>The latest version
     (<a href="news/#version-{{ site.version | replace:".", "-" }}">{{ site.version }}</a>)
     has been released at {{ site.release_date }}.
  </p>
  <p>
    <a href="tutorial/"
       class="btn btn-primary btn-lg"
       role="button">Try tutorial</a>
    <a href="install/"
       class="btn btn-primary btn-lg"
       role="button">Install</a>
  </p>
</div>

## About XMLua {#about}

XMLua is a Lua library for processing XML and HTML. It's based on [libxml2](http://xmlsoft.org/). It uses LuaJIT's FFI module.

XMLua provides user-friendly API instead of low-level libxml2 API. The user-friendly API is implemented top of low-level libxml2 API.

## Documentations {#documentations}

  * [News](news/): It lists release information.

  * [Install](install/): It describes how to install XMLua.

  * [Tutorial](tutorial/): It describes how to use XMLua step by step.

  * [Reference](reference/): It describes details for each features such as classes and methods.

## License {#license}

XMLua is released under [the MIT license](https://opensource.org/licenses/mit).

See [LICENSE](https://github.com/clear-code/xmlua/blob/master/LICENSE) file for details such as copyright holders.
