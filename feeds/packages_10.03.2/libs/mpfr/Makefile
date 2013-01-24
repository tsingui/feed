#
# Copyright (C) 2009 OpenWrt.org
# Copyright (C) 2013 Richard Nee <openme@openwrt.org.cn>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mpfr
PKG_VERSION:=2.4.1
PKG_RELEASE:=1

PKG_SOURCE_URL:=http://www.mpfr.org/mpfr-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_MD5SUM:=c5ee0a8ce82ad55fe29ac57edd35d09e

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_FIXUP:=libtool

include $(INCLUDE_DIR)/package.mk


define Package/$(PKG_NAME)
  TITLE:=multiple-precision library
  CATEGORY:=Development
  SUBMENU:=
  SECTION:=devel
  DEPENDS:=+gmp
  URL:=http://www.mpfr.org
  MAINTAINER:=Richard Nee <openme@openwrt.org.cn>
endef

define Package/$(PKG_NAME)/description
  The MPFR library is a C library for multiple-precision 
  floating-point computations with correct rounding.
  MPFR is based on the GMP multiple-precision library.
endef

TARGET_CFLAGS += $(FPIC)
CONFIGURE_VARS += CC="$(TARGET_CROSS)gcc"
CONFIGURE_ARGS += \
	--enable-shared \
	--enable-static \
	--with-gmp="$(STAGING_DIR)/usr" \


define Build/Compile
	$(call Build/Compile/Default, \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		CC="$(TARGET_CC)" \
		all \
	)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/*.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmpfr.{a,so*} $(1)/usr/lib/
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmpfr.so* $(1)/usr/lib/
endef


$(eval $(call BuildPackage,$(PKG_NAME)))

