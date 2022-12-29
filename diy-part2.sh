#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改默认IP
sed -i 's/192.168.1.1/172.16.252.1/g' package/base-files/files/bin/config_generate

# 补充汉化       
cp -f ./feeds/springwrt/files/udpxy.lua ./feeds/luci/applications/luci-app-udpxy/luasrc/model/cbi
cp -f ./feeds/springwrt/files/mwan3.po ./feeds/luci/applications/luci-app-mwan3/po/zh-cn

# 取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon-18.06/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon-18.06/g' feeds/luci/collections/luci-nginx/Makefile

# 加入作者信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWRT-$(date +%Y%m%d)'/g" package/lean/default-settings/files/zzz-default-settings

# 更改主机名
sed -i "s/hostname='.*'/hostname='OpenWRT'/g" package/base-files/files/bin/config_generate

# 更改 Zerotier 菜单位置
sed -i "s/vpn/services/g" package/feeds/luci/luci-app-zerotier/luasrc/controller/zerotier.lua
sed -i "s/vpn/services/g" package/feeds/luci/luci-app-zerotier/luasrc/view/zerotier/zerotier_status.htm

# 调整接口菜单
sed -i '/option Interface/d'  package/network/services/dropbear/files/dropbear.config
