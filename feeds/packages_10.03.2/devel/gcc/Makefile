# 
# Copyright (C) 2008 OpenWrt.org
# Copyright (C) 2013 Richard Nee <openme@openwrt.org.cn>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gcc
GCC_VER:=$(call qstrip,$(CONFIG_GCC_VERSION))
PKG_VERSION:=$(firstword $(subst +, ,$(GCC_VER)))
PKG_RELEASE:=2
PATCH_DIR=$(TOPDIR)/toolchain/gcc/patches/$(GCC_VER)
PKG_SOURCE_URL:=@GNU/gcc/gcc-$(PKG_VERSION)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_MD5SUM:=

include $(INCLUDE_DIR)/package.mk

RSTRIP:=:


define Package/gcc
  SECTION:=devel
  CATEGORY:=Development
  TITLE:=gcc
  DEPENDS:=+libgmp +libmpfr
endef

define Package/gcc/description
	build a native toolchain for compiling on target
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) $(SCRIPT_DIR)/config.{guess,sub} $(PKG_BUILD_DIR)/
	$(SED) 's,^MULTILIB_OSDIRNAMES,# MULTILIB_OSDIRNAMES,' $(PKG_BUILD_DIR)/gcc/config/*/t-*
	$(SED) 's,\(version_string.. = "[0-9\.]*\).*\(";\),\1 (OpenWrt-2.0)\2,' $(PKG_BUILD_DIR)/gcc/version.c
	$(SED) 's,\(bug_report_url.. = "\).*\(";\),\1<URL:$(BUGURL)>\2,' $(PKG_BUILD_DIR)/gcc/version.c
	$(SED) 's,http://gcc.gnu.org/bugs.html,$(BUGURL),' $(PKG_BUILD_DIR)/gcc/configure
	#(cd $(PKG_BUILD_DIR)/libstdc++-v3; autoconf;);
	$(SED) 's,gcc_no_link=yes,gcc_no_link=no,' $(PKG_BUILD_DIR)/libstdc++-v3/configure
endef


SEP:=,
TARGET_LANGUAGES:="c$(if $(CONFIG_INSTALL_LIBSTDCPP),$(SEP)c++)$(if $(CONFIG_INSTALL_LIBGCJ),$(SEP)java)"

export libgcc_cv_fixed_point=no

GCC_CONFIGURE:= \
	SHELL="$(BASH)" \
	$(TARGET_CONFIGURE_OPTS) \
	$(PKG_BUILD_DIR)/configure \
		--build=$(GNU_HOST_NAME) \
		--host=$(REAL_GNU_TARGET_NAME) \
		--target=$(REAL_GNU_TARGET_NAME) \
		--prefix=/usr \
		--with-gnu-ld \
		--enable-target-optspace \
		--disable-libgomp \
		--disable-libmudflap \
		--disable-multilib \
		--disable-nls \
		--enable-languages=$(TARGET_LANGUAGES) \
		--enable-shared \
		--enable-threads \
		$(if $(CONFIG_GCC_USE_GRAPHITE),--with-host-libstdcxx=-lstdc++) \
		--disable-libstdcxx-pch \
		$(SOFT_FLOAT_CONFIG_OPTION) \
		$(call qstrip,$(CONFIG_EXTRA_GCC_CONFIG_OPTIONS)) \
		$(if $(CONFIG_GCC_VERSION_4_3_3_CS),--enable-poison-system-directories)

#TODO: ERROR: cfenv, fenv.h
#--disable-libstdcxx-pch \
#$(if $(CONFIG_GCC_USE_GRAPHITE),--with-host-libstdcxx=-lstdc++) \

ifneq ($(CONFIG_GCC_VERSION_4_3)$(CONFIG_GCC_VERSION_4_4),)
  GCC_CONFIGURE+= \
		--with-gmp="$(STAGING_DIR)/usr" \
		--with-mpfr="$(STAGING_DIR)/usr" \
		--disable-decimal-float
endif

ifneq ($(CONFIG_SSP_SUPPORT),)
  GCC_CONFIGURE+= \
		--enable-libssp
else
  GCC_CONFIGURE+= \
		--disable-libssp
endif

ifneq ($(CONFIG_EXTRA_TARGET_ARCH),)
  GCC_CONFIGURE+= \
		--enable-biarch \
		--enable-targets=$(call qstrip,$(CONFIG_EXTRA_TARGET_ARCH_NAME))-linux-$(TARGET_SUFFIX)
endif

ifeq ($(LIBC),uClibc)
  GCC_CONFIGURE+= \
		--disable-__cxa_atexit
else
  GCC_CONFIGURE+= \
		--enable-__cxa_atexit
endif


ifneq ($(CONFIG_TLS_SUPPORT),)
  GCC_CONFIGURE+= \
		--enable-tls
else
  GCC_CONFIGURE+= \
		--disable-tls
endif

ifdef CONFIG_powerpc
  TARGET_CFLAGS := $(patsubst -Os,-O2,$(TARGET_CFLAGS))
endif

TARGET_LDFLAGS := -L$(PKG_BUILD_DIR)/libiberty $(TARGET_LDFLAGS)
TARGET_CFLAGS:= -I$(TOOLCHAIN_DIR)/usr/include $(TARGET_CFLAGS) $(FPIC)

#GCC_CONFIGURE+= \
#	CFLAGS_FOR_TARGET="$(TARGET_CFLAGS)" \
#	CXXFLAGS_FOR_TARGET="$(TARGET_CFLAGS)"

define Build/Configure
	(cd $(PKG_BUILD_DIR); rm -f config.cache; \
		$(GCC_CONFIGURE) \
	);
endef

define Build/Compile
	export SHELL="$(BASH)"; $(MAKE_VARS) $(MAKE) -C $(PKG_BUILD_DIR) \
			DESTDIR="$(PKG_INSTALL_DIR)" $(MAKE_FLAGS) all install
	# Set up the symlinks to enable lying about target name.
	set -e; \
	(cd $(TOOLCHAIN_DIR)/usr; \
		ln -sf $(REAL_GNU_TARGET_NAME) $(GNU_TARGET_NAME); \
		cd bin; \
		for app in $(REAL_GNU_TARGET_NAME)-* ; do \
			ln -sf $$$${app} \
			$(GNU_TARGET_NAME)$$$${app##$(REAL_GNU_TARGET_NAME)}; \
		done; \
	);
endef

define Package/gcc/install
	$(INSTALL_DIR) $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/* $(1)
	$(CP) $(TOOLCHAIN_DIR)/usr/include $(1)/usr/
	$(CP) $(TOOLCHAIN_DIR)/usr/lib/crt* $(1)/usr/lib/
	$(CP) $(TOOLCHAIN_DIR)/usr/lib/libc* $(1)/usr/lib/
	$(CP) $(TOOLCHAIN_DIR)/usr/lib/* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,gcc))
