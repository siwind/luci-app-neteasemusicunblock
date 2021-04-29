# Copyright (C) 2020 Silvan
include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for neteasemusicunblock
LUCI_DEPENDS:= +bash +busybox +unzip +coreutils +coreutils-nohup +curl +dnsmasq-full +ipset +luci-compat +openssl-util +NeteaseMusicUnblockGo
LUCI_PKGARCH:=all
PKG_NAME:=luci-app-neteasemusicunblock
PKG_VERSION:=1.14
PKG_RELEASE:=1

PKG_MAINTAINER:=https://github.com/siwind/luci-app-neteasemusicunblock

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
