#!/bin/bash


# Add a feed source
sed -i '$a src-git kaikai https://github.com/kaikai8191/openwrt-packages' feeds.conf.default
