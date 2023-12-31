#!/bin/bash


# Add a feed source
sed -i '$a src-git zwrt https://github.com/zwrt/openwrt-packages' feeds.conf.default
