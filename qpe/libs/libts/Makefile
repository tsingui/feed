#
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libts
PKG_VERSION:=master-2012-08-30
PKG_RELEASE:=1

PKG_SOURCE:=tslib-$(PKG_VERSION).tar.bz2
PKG_SOURCE_SUBDIR:=tslib-$(PKG_VERSION)
PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)
PKG_SOURCE_URL:=https://github.com/kergoth/tslib.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=f6c499a523bff845ddd57b1d96c9d1389f0df17b


PKG_INSTALL:=1
PKG_FIXUP:=libtool

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  TITLE:=tslib is an abstraction layer for touchscreen panel events
  CATEGORY:=Qt/Qtopia
  SUBMENU:=libs
  SECTION:=qpe-$(SUBMENU)
  DEPENDS:=@!LINUX_2_4
  URL:=http://tslib.berlios.de/ https://github.com/kergoth/tslib
  MAINTAINER:=Richard Nee <richard.nee.cn@gmail.com>
endef

define Package/$(PKG_NAME)/description
  tslib is an abstraction layer for touchscreen panel events,
  as well as a filter stack for the manipulation of those events.
  Examples of implemented filters include jitter smoothing and the calibration transform.
endef

ifeq ($(CONFIG_TARGET_s5pv210),y)
  TSLIB_CONFFILE:=ts-1wire.conf
  TSLIB_CALIBFILE:=pointercal-s5pv210
else 
  TSLIB_CONFFILE:=ts.conf
endif

define Build/Configure
	(cd $(PKG_BUILD_DIR); ./autogen.sh; echo "ac_cv_func_malloc_0_nonnull=yes" > cache-file.cache );
	$(call Build/Configure/Default, --cache-file=cache-file.cache)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/* $(1)/usr/lib/
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/ts $(1)/usr/bin $(1)/etc
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/ts_* $(1)/usr/bin/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/*.so* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ts/*.so* $(1)/usr/lib/ts/
	$(if $(TSLIB_CONFFILE),$(CP) ./files/$(TSLIB_CONFFILE) $(1)/etc/ts.conf )
	$(if $(TSLIB_CALIBFILE),$(CP) ./files/$(TSLIB_CALIBFILE) $(1)/etc/pointercal )
	$(CP) ./files/tslib-env.sh $(1)/etc/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
