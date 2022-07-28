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

#修复SSR PULS依赖编译报错
#sed -i 's/luci-lib-ipkg/luci-base/g' package/luci-app-ssr-plus/Makefile

# Modify default passwd
#sed -i '/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF./ d' package/lean/default-settings/files/zzz-default-settings

# Temporary repair https://github.com/coolsnowwolf/lede/issues/8423
# sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile

#恢复主机型号
#sed -i 's/(dmesg | grep .*/{a}${b}${c}${d}${e}${f}/g' package/lean/autocore/files/x86/autocore
#sed -i '/h=${g}.*/d' package/lean/autocore/files/x86/autocore
#sed -i 's/echo $h/echo $g/g' package/lean/autocore/files/x86/autocore

#关闭串口跑码
#sed -i 's/console=tty0//g'  target/linux/x86/image/Makefile

# 切换内核版本
sed -i 's/KERNEL_PATCHVER\:\=5.15/KERNEL_PATCHVER\:\=5.10/g' ./target/linux/x86/Makefile

# Modify default IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

#修改X86默认固件大小
if [[ `grep -o "default 160" config/Config-images.in | wc -l` == "1" ]]; then
    sed -i 's\default 160\default 200\g' config/Config-images.in
else
    echo ""
fi

#修改默认主题为luci-theme-argonne
sed -i "s/Bootstrap/Argonne/g" ./feeds/luci/collections/luci/Makefile
sed -i "s/luci-theme-bootstrap/luci-theme-argonne/g" ./feeds/luci/collections/luci/Makefile

#修改x86首页
#  rm -rf package/lean/autocore/files/index.htm
wget -O x86_index.htm https://raw.githubusercontent.com/c939984606/OpenWrt_Auto_Action/master/Other/x86_index.htm
cp -rf ./x86_index.htm package/lean/autocore/files/x86/index.htm
base_zh_po_if=$(grep -o "#天气预报" feeds/luci/modules/luci-base/po/zh-cn/base.po)
if [[ "$base_zh_po_if" == "#天气预报" ]]; then
    echo "已添加天气预报"
else
    sed -i '$a \       ' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a #天气预报' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a msgid "Weather"' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a msgstr "天气"' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a \       ' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a msgid "Local Weather"' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a msgstr "本地天气"' feeds/luci/modules/luci-base/po/zh-cn/base.po
fi

#首页显示编译时间 作者 下载地址
Compile_time_if=$(grep -o "#首页显示编译时间" feeds/luci/modules/luci-base/po/zh-cn/base.po)
if [[ "$Compile_time_if" == "#首页显示编译时间" ]]; then
    echo "已添加首页显示编译时间"
else
    sed -i '$a \       ' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a #首页显示编译时间' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a msgid "Compile_time"' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a msgstr "固件编译时间"' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a \       ' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a #首页显示编译作者' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a msgid "Compile_author"' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a msgstr "固件编译作者"' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a \       ' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a #首页显示下载地址' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a msgid "Frimware_dl"' feeds/luci/modules/luci-base/po/zh-cn/base.po
    sed -i '$a msgstr "固件更新地址"' feeds/luci/modules/luci-base/po/zh-cn/base.po
fi
sed -i '/Compile_time/d' package/lean/default-settings/files/zzz-default-settings
sed -i '/Compile_author/d' package/lean/default-settings/files/zzz-default-settings
sed -i '/Frimware_dl/d' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit/d' package/lean/default-settings/files/zzz-default-settings
echo "echo \"`date "+%Y-%m-%d %H:%M"` (commit:`git log -1 --format=format:'%C(bold white)%h%C(reset)'`)\" >> /etc/Compile_time" >> package/lean/default-settings/files/zzz-default-settings
echo "echo \"➤➤ By 一路阳光&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;➤➤ https://blog.abcdl.cn\" >> /etc/Compile_author" >> package/lean/default-settings/files/zzz-default-settings
echo "echo \"➤➤ 点击此处下载&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;✿提取码：nbn9\" >> /etc/Frimware_dl" >> package/lean/default-settings/files/zzz-default-settings
echo "exit 0" >> package/lean/default-settings/files/zzz-default-settings

#-------------------------------------------------------------------------------------------------------------------------------

rm -rf package/other
mkdir package/other

#istore
#svn co https://github.com/linkease/istore/trunk/luci/luci-app-store ./package/other/luci-app-store
#svn co https://github.com/openwrt/luci/trunk/libs/luci-lib-ipkg ./package/other/luci-lib-ipkg
#cp -rf ./package/other/luci-lib-ipkg ./feeds/luci/libs/
#rm -rf ./package/feeds/luci/luci-lib-ipkg/luasrc
#ln -s ./feeds/luci/libs/luci-lib-ipkg ./package/feeds/luci/luci-lib-ipkg
#git clone https://github.com/linkease/istore-ui.git ./package/other/istore-ui
#cp -rf ./package/other/istore-ui/app-store-ui ./package/other/luci-app-store
#echo "-----------------------------------------------------"
#echo

#Auto Wan
git clone https://github.com/kongfl888/luci-app-autorewan.git ./package/other/luci-app-autorewan
echo "-----------------------------------------------------"
echo

#luci-app-netspeedtest
git clone https://github.com/waynesg/luci-app-netspeedtest.git ./package/other/luci-app-netspeedtest
echo "-----------------------------------------------------"
echo

# 采用lisaac的luci-app-dockerman
rm -rf ./package/lean/luci-app-dockerman 
rm -rf ./package/lean/luci-lib-docker
svn co https://github.com/lisaac/luci-app-dockerman/trunk/applications/luci-app-dockerman ./package/lean/luci-app-dockerman
git clone --depth=1 https://github.com/lisaac/luci-lib-docker ./package/lean/luci-lib-docker
echo "-----------------------------------------------------"
echo

#添加 fw876/helloworld
rm -rf ./package/lean/helloworld
git clone --depth=1 https://github.com/fw876/helloworld.git ./package/lean/helloworld
echo "-----------------------------------------------------"
echo

# add luci-app-advanced
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-advanced ./package/other/luci-app-advanced
echo "-----------------------------------------------------"
echo

# add luci-app-aliddns
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-aliddns ./package/other/luci-app-aliddns
echo "-----------------------------------------------------"
echo

# add luci-app-eqos
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-eqos ./package/other/luci-app-eqos
echo "-----------------------------------------------------"
echo

# add adguardhome
svn co https://github.com/kenzok8/openwrt-packages/trunk/adguardhome ./package/other/adguardhome
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-adguardhome ./package/other/luci-app-adguardhome
echo "-----------------------------------------------------"
echo

# add aliyundrive-webdav
svn co https://github.com/kenzok8/openwrt-packages/trunk/aliyundrive-webdav ./package/other/aliyundrive-webdav
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-aliyundrive-webdav ./package/other/luci-app-aliyundrive-webdav
echo "-----------------------------------------------------"
echo

# add ddnsto
svn co https://github.com/kenzok8/openwrt-packages/trunk/ddnsto ./package/other/ddnsto
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-ddnsto ./package/other/luci-app-ddnsto
echo "-----------------------------------------------------"
echo

# add filebrowser
svn co https://github.com/kenzok8/openwrt-packages/trunk/filebrowser ./package/other/filebrowser
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-filebrowser ./package/other/luci-app-filebrowser
echo "-----------------------------------------------------"
echo

# add luci-app-bypass
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-bypass ./package/other/luci-app-bypass
echo "-----------------------------------------------------"
echo

# add luci-app-koolddns
svn co https://github.com/c939984606/openwrt-packages/trunk/luci-app-koolddns ./package/other/luci-app-koolddns
echo "-----------------------------------------------------"
echo

# add openclash
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-openclash ./package/other/luci-app-openclash
echo "-----------------------------------------------------"
echo

# add passwall2
#git clone https://github.com/kenzok8/small ./package/other/small
#svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-passwall2 ./package/other/luci-app-passwall2
#echo "-----------------------------------------------------"
#echo

# add passwall
git clone -b luci https://github.com/xiaorouji/openwrt-passwall.git ./package/other/passwall_luci
git clone -b packages https://github.com/xiaorouji/openwrt-passwall.git ./package/other/passwall_packages
cd ./package/other/passwall_luci
git reset --hard d4e05410d3364cdd2945a8f6b778eead1721c95f
cd ../../../ && cd ./package/other/passwall_packages
git reset --hard 883154b3ae9976343374fcb28a94c89a38d835ce
cd ../../../
echo "-----------------------------------------------------"
echo

#微信推送钉钉机器人版
git clone https://github.com/zzsj0928/luci-app-pushbot ./package/other/luci-app-pushbot
echo "-----------------------------------------------------"
echo

# add luci-app-serverchan
rm -rf ./package/lean/luci-app-serverchan
git clone https://github.com/tty228/luci-app-serverchan ./package/lean/luci-app-serverchan
echo "-----------------------------------------------------"
echo

# add luci-app-smartdns
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-smartdns ./package/other/luci-app-smartdns
svn co https://github.com/kenzok8/openwrt-packages/trunk/smartdns ./package/other/smartdns
echo "-----------------------------------------------------"
echo

#  VSSR
rm -rf ./package/lean/luci-app-vssr
rm -rf ./package/lean/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr.git ./package/other/luci-app-vssr
git clone https://github.com/jerrykuku/lua-maxminddb.git ./package/other/lua-maxminddb
echo "-----------------------------------------------------"
echo


# add theme
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-atmaterial_new ./package/other/luci-theme-atmaterial_new
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-argonne ./package/other/luci-theme-argonne
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-mcat ./package/other/luci-theme-mcat
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-tomato ./package/other/luci-theme-tomato
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-neobird ./package/other/luci-theme-neobird
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-argonne-config ./package/other/luci-app-argonne-config
echo "-----------------------------------------------------"
echo


#删除默认主题配置
sed -i '/set\ luci.main.mediaurlbase=\/luci-static\/netgear/d' ./feeds/luci/themes/luci-theme-netgear/root/etc/uci-defaults/30_luci-theme-netgear
sed -i '/set\ luci.main.mediaurlbase=\/luci-static\/neobird/d' ./package/other/luci-theme-neobird/root/etc/uci-defaults/30_luci-theme-neobird
sed -i '/set\ luci.main.mediaurlbase=\/luci-static\/bootstrap/d' ./feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i '/set\ luci.main.mediaurlbase=\/luci-static\/material/d' ./feeds/luci/themes/luci-theme-material/root/etc/uci-defaults/30_luci-theme-material
sed -i '/set\ luci.main.mediaurlbase=\/luci-static\/atmaterial_new/d' ./package/other/luci-theme-atmaterial_new/root/etc/uci-defaults/30_luci-theme-atmaterial_new
sed -i '/set\ luci.main.mediaurlbase=\/luci-static\/mcat/d' ./package/other/luci-theme-mcat/files/30_luci-theme-mcat
sed -i '/set\ luci.main.mediaurlbase=\/luci-static\/tomato/d' ./package/other/luci-theme-tomato/root/etc/uci-defaults/30_luci-theme-tomato
