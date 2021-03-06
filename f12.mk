#
# $Id$
# $URL$
#
# the f12 pldistro is to rebuild a fedora 12 vserver-capable kernel + out-to-date util-vserver
# it is intended to be used in conjunction with the stock f12 distribution
#

#
# kernel
#
kernel-MODULES := linux-2.6
kernel-SPEC := kernel.spec
kernel-BUILD-FROM-SRPM := yes
ifeq "$(HOSTARCH)" "i386"
kernel-RPMFLAGS:= --target i686
else
kernel-RPMFLAGS:= --target $(HOSTARCH)
endif
# the defaults below are built into the specfile
#kernel-RPMFLAGS += --with firmware --without doc --without-debug
ALL += kernel

#
# util-vserver
#
util-vserver-MODULES := util-vserver
util-vserver-SPEC := util-vserver.spec
util-vserver-BUILD-FROM-SRPM := yes
#util-vserver-RPMFLAGS:= --without dietlibc
ALL += util-vserver

yum-MODULES := yum
yum-SPEC := yum.spec
yum-BUILD-FROM-SRPM := yes
ALL += yum
