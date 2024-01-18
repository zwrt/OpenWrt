#!/bin/bash

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.4/g' package/base-files/files/bin/config_generate

# Themes 主题
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# 修改 argon 为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile

# 更改 Argon 主题背景
cp -f $GITHUB_WORKSPACE/diy/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

##更改主机名
sed -i "s/hostname='.*'/hostname='Phicomm-N1'/g" package/base-files/files/bin/config_generate

# 显示增加编译时间
sed -i "s/<%=pcdata(ver.distname)%> <%=pcdata(ver.distversion)%>/<%=pcdata(ver.distname)%> <%=pcdata(ver.distversion)%> (By @TIAmo build $(TZ=UTC-8 date "+%Y-%m-%d %H:%M"))/g" package/lean/autocore/files/arm/index.htm

# 修改概览里时间显示为中文数字
sed -i 's/os.date()/os.date("%Y年%m月%d日") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/lean/autocore/files/arm/index.htm

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# 晶晨宝盒
git_sparse_clone main https://github.com/ophub/luci-app-amlogic luci-app-amlogic
sed -i "s|firmware_repo.*|firmware_repo 'https://github.com/wrtv/OpenWrt'|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|kernel_path.*|kernel_path 'https://github.com/zwrt/kernel'|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|Phicomm-N1|g" package/luci-app-amlogic/root/etc/config/amlogic

# 添加额外插件
git clone --depth 1 https://github.com/kenzok78/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist
git clone --depth 1 https://github.com/Lienol/openwrt-package package/luci-app-filebrowser

# 科学上网插件
git clone --depth 1 https://github.com/wrtv/luci-app-vssr package/luci-app-vssr
git clone --depth 1 https://github.com/jerrykuku/lua-maxminddb package/lua-maxminddb
git clone --depth=1 -b main https://github.com/fw876/helloworld package/luci-app-ssr-plus
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash
