#!/bin/bash


# Add a feed source
sed -i '$a src-git kaikai https://github.com/djzng/openwrt-packages' feeds.conf.default
