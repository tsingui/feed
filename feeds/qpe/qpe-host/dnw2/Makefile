# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

# Please install libusb and libusb-dev before building.
# sudo apt-get install libusb-dev
PKG_NAME:=dnw2
PKG_VERSION:=
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  TITLE:=DNW2 for USB download
  CATEGORY:=Qt/Qtopia
  SUBMENU:=qpe-host
  SECTION:=qtopia-$(SUBMENU)
  DEPENDS:=
  URL:=
  MAINTAINER:=Richard Nee <richard.nee.cn@gmail.com>
endef

define Package/$(PKG_NAME)/description
  DNW2, by Fox <hulifox008@163.com>
    modified by Richard Nee to support more s3c2410/s3c2440/s3c6410 devices.

    Please install libusb and libusb-dev before building.
    You should use lsusb to find out the actual vender ID & product ID of board.
endef

define Build/Compile
	$(CC) -lusb -o $(PKG_BUILD_DIR)/$(PKG_NAME) ./src/dnw2.c
endef

define Package/$(PKG_NAME)/install
	$(CP) $(PKG_BUILD_DIR)/$(PKG_NAME) $(STAGING_DIR_HOST)/bin/
	$(CP) $(PKG_BUILD_DIR)/$(PKG_NAME) $(TOPDIR)/bin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
