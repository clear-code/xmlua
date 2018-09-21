FROM centos:7

RUN \
  yum install -y epel-release
RUN \
  yum install -y  \
    gcc \
    git \
    libxml2 \
    lua-devel \
    luajit \
    luajit-devel \
    luarocks \
    make \
    m4 \
    openssl-devel
RUN \
  luarocks install cqueues && \
  luarocks install luaunit

RUN \
  systemd-machine-id-setup

RUN \
  useradd --user-group --create-home xmlua

COPY . /home/xmlua/xmlua
WORKDIR /home/xmlua/xmlua

RUN \
  cp \
    xmlua.rockspec \
    xmlua-$(grep VERSION xmlua.lua | sed -e 's/.*"\(.*\)"/\1/g')-0.rockspec
RUN luarocks make xmlua-*.rockspec
RUN rm -rf xmlua.lua xmlua

USER xmlua

RUN \
  git clone --depth 1 https://github.com/clear-code/luacs.git ../luacs

CMD \
  test/run-test.lua && \
  luajit -e 'package.path = "../luacs/?.lua;" .. package.path' \
    sample/parse-html-cqueues-thread.lua sample/sample.html
