# $Id$
# $URL$
#
# declare the packages to be built and their dependencies
# initial version from Mark Huang
# Mark Huang <mlhuang@cs.princeton.edu>
# Copyright (C) 2003-2006 The Trustees of Princeton University
# rewritten by Thierry Parmentelat - INRIA Sophia Antipolis
#
# see doc in Makefile  
#

#
# kernel
#
# use a package name with srpm in it:
# so the source rpm is created by running make srpm in the codebase
#

kernel-MODULES := linux-2.6
kernel-SPEC := kernel-2.6.spec
kernel-BUILD-FROM-SRPM := yes
ifeq "$(HOSTARCH)" "i386"
kernel-RPMFLAGS:= --target i686
else
kernel-RPMFLAGS:= --target $(HOSTARCH)
endif
# this is useful for 2.6.22 but will not be needed anymore with 2.6.27
kernel-SPECVARS += iwlwifi=1 
kernel-SPECVARS += kernelconfig=planetlab
KERNELS += kernel

kernels: $(KERNELS)
kernels-clean: $(foreach package,$(KERNELS),$(package)-clean)

ALL += $(KERNELS)
# this is to mark on which image a given rpm is supposed to go
IN_BOOTCD += $(KERNELS)
IN_VSERVER += $(KERNELS)
IN_BOOTSTRAPFS += $(KERNELS)

#
# ipfw: root context module, and slice companion
#
ipfwroot-MODULES := ipfwsrc
ipfwroot-SPEC := planetlab/ipfwroot.spec
ipfwroot-DEPEND-DEVEL-RPMS := kernel-devel
ipfwroot-SPECVARS = kernel_version=$(kernel.rpm-version) \
        kernel_release=$(kernel.rpm-release) \
        kernel_arch=$(kernel.rpm-arch)
ALL += ipfwroot

ipfwslice-MODULES := ipfwsrc
ipfwslice-SPEC := planetlab/ipfwslice.spec
ipfwslice-SPECVARS = kernel_version=$(kernel.rpm-version) \
        kernel_release=$(kernel.rpm-release) \
        kernel_arch=$(kernel.rpm-arch)
ALL += ipfwslice

# this doesn't build on f12 - weird all right - I suspect gcc to be smarter but that needs investigation
# is madwifi still current anyway ? should we move to ath5k instead ?
#ifneq "$(DISTRONAME)" "f12"
#
# madwifi
#
madwifi-MODULES := madwifi
madwifi-SPEC := madwifi.spec
madwifi-BUILD-FROM-SRPM := yes
madwifi-DEPEND-DEVEL-RPMS := kernel-devel
madwifi-SPECVARS = kernel_version=$(kernel.rpm-version) \
	kernel_release=$(kernel.rpm-release) \
	kernel_arch=$(kernel.rpm-arch)
ALL += madwifi
IN_BOOTSTRAPFS += madwifi
#endif

# 
# nozomi
# 
nozomi-MODULES := nozomi
nozomi-SPEC := nozomi.spec
nozomi-DEPEND-DEVEL-RPMS := kernel-devel
nozomi-SPECVARS = kernel_version=$(kernel.rpm-version) \
	kernel_release=$(kernel.rpm-release) \
	kernel_arch=$(kernel.rpm-arch)
IN_BOOTSTRAPFS += nozomi
ALL += nozomi

#
# comgt
# 
comgt-MODULES := comgt
comgt-SPEC := comgt.spec
IN_BOOTSTRAPFS += comgt
ALL += comgt

#
# umts: root context stuff
#
umts-backend-MODULES := planetlab-umts-tools
umts-backend-SPEC := backend.spec
IN_BOOTSTRAPFS += umts-backend
ALL += umts-backend

#
# umts: slice tools
#
umts-frontend-MODULES := planetlab-umts-tools
umts-frontend-SPEC := frontend.spec
IN_VSERVER += umts-frontend
ALL += umts-frontend

#
# iptables
#
iptables-MODULES := iptables
iptables-SPEC := iptables.spec
iptables-DEPEND-DEVEL-RPMS := kernel-devel kernel-headers
ALL += iptables
IN_BOOTSTRAPFS += iptables

#
# iproute
#
iproute-MODULES := iproute2
iproute-SPEC := iproute.spec
ALL += iproute
IN_BOOTSTRAPFS += iproute
IN_VSERVER += iproute
IN_BOOTCD += iproute

#
# util-vserver
#
util-vserver-MODULES := util-vserver
util-vserver-SPEC := util-vserver.spec
util-vserver-RPMFLAGS:= --without dietlibc
ALL += util-vserver
IN_BOOTSTRAPFS += util-vserver

#
# libnl - local import
# we need either 1.1 or at least 1.0.pre6
# rebuild this on centos5 - see kexcludes in build.common
#
local_libnl=false
ifeq "$(DISTRONAME)" "centos5"
local_libnl=true
endif

ifeq "$(local_libnl)" "true"
libnl-MODULES := libnl
libnl-SPEC := libnl.spec
libnl-BUILD-FROM-SRPM := yes
# this sounds like the thing to do, but in fact linux/if_vlan.h comes with kernel-headers
libnl-DEPEND-DEVEL-RPMS := kernel-devel kernel-headers
ALL += libnl
IN_BOOTSTRAPFS += libnl
endif

#
# util-vserver-pl
#
util-vserver-pl-MODULES := util-vserver-pl
util-vserver-pl-SPEC := util-vserver-pl.spec
util-vserver-pl-DEPEND-DEVEL-RPMS := util-vserver-lib util-vserver-devel util-vserver-core 
ifeq "$(local_libnl)" "true"
util-vserver-pl-DEPEND-DEVEL-RPMS += libnl libnl-devel
endif
ALL += util-vserver-pl
IN_BOOTSTRAPFS += util-vserver-pl

#
# NodeUpdate
#
nodeupdate-MODULES := NodeUpdate
nodeupdate-SPEC := NodeUpdate.spec
ALL += nodeupdate
IN_BOOTSTRAPFS += nodeupdate

#
# ipod
#
ipod-MODULES := PingOfDeath
ipod-SPEC := ipod.spec
ALL += ipod
IN_BOOTSTRAPFS += ipod

#
# NodeManager
#
nodemanager-MODULES := NodeManager
nodemanager-SPEC := NodeManager.spec
ALL += nodemanager
IN_BOOTSTRAPFS += nodemanager

#
# pl_sshd
#
sshd-MODULES := pl_sshd
sshd-SPEC := pl_sshd.spec
ALL += sshd
IN_BOOTSTRAPFS += sshd

#
# codemux: Port 80 demux
#
codemux-MODULES := CoDemux
codemux-SPEC   := codemux.spec
#codemux-RPMBUILD := bash ./rpmbuild.sh
ALL += codemux
IN_BOOTSTRAPFS += codemux

#
# fprobe-ulog
#
fprobe-ulog-MODULES := fprobe-ulog
fprobe-ulog-SPEC := fprobe-ulog.spec
ALL += fprobe-ulog
IN_BOOTSTRAPFS += fprobe-ulog

#
# pf2slice
#
pf2slice-MODULES := pf2slice
pf2slice-SPEC := pf2slice.spec
ALL += pf2slice

#
# PlanetLab Mom: Cleans up your mess
#
mom-MODULES := Mom
mom-SPEC := pl_mom.spec
ALL += mom
IN_BOOTSTRAPFS += mom

#
# inotify-tools - local import
# rebuild this on centos5 (not found) - see kexcludes in build.common
#
local_inotify_tools=false
ifeq "$(DISTRONAME)" "centos5"
local_inotify_tools=true
endif

ifeq "$(local_inotify_tools)" "true"
inotify-tools-MODULES := inotify-tools
inotify-tools-SPEC := inotify-tools.spec
inotify-tools-BUILD-FROM-SRPM := yes
IN_BOOTSTRAPFS += inotify-tools
ALL += inotify-tools
endif

#
# vsys
#
vsys-MODULES := vsys
vsys-SPEC := vsys.spec
ifeq "$(local_inotify_tools)" "true"
vsys-DEPEND-DEVEL-RPMS := inotify-tools inotify-tools-devel
endif
IN_BOOTSTRAPFS += vsys
ALL += vsys

#
# vsys-scripts
#
vsys-scripts-MODULES := vsys-scripts
vsys-scripts-SPEC := vsys-scripts.spec
IN_BOOTSTRAPFS += vsys-scripts
ALL += vsys-scripts

#
# plcapi
#
plcapi-MODULES := PLCAPI
plcapi-SPEC := PLCAPI.spec
ALL += plcapi

#
# drupal
# 
drupal-MODULES := drupal
drupal-SPEC := drupal.spec
drupal-BUILD-FROM-SRPM := yes
ALL += drupal

#
# use the plewww module instead
#
plewww-MODULES := PLEWWW
plewww-SPEC := plewww.spec
ALL += plewww

#
# www-register-wizard
#
www-register-wizard-MODULES := www-register-wizard
www-register-wizard-SPEC := www-register-wizard.spec
ALL += www-register-wizard

#
# pcucontrol
#
pcucontrol-MODULES := pcucontrol
pcucontrol-SPEC := pcucontrol.spec
ALL += pcucontrol

#
# monitor
#
monitor-MODULES := Monitor
monitor-SPEC := Monitor.spec
ALL += monitor
IN_BOOTSTRAPFS += monitor

#
# zabbix
#
zabbix-MODULES := Monitor
zabbix-SPEC := zabbix.spec
zabbix-BUILD-FROM-SRPM := yes
ALL += zabbix

#
# PLC RT
#
plcrt-MODULES := PLCRT
plcrt-SPEC := plcrt.spec
ALL += plcrt

#
# pyopenssl
#
pyopenssl-MODULES := pyopenssl
pyopenssl-SPEC := pyOpenSSL.spec
pyopenssl-BUILD-FROM-SRPM := yes
ALL += pyopenssl

#
# pyaspects
#
pyaspects-MODULES := pyaspects
pyaspects-SPEC := pyaspects.spec
pyaspects-BUILD-FROM-SRPM := yes
ALL += pyaspects

#
# ejabberd
#
ejabberd-MODULES := ejabberd
ejabberd-SPEC := ejabberd.spec
ejabberd-BUILD-FROM-SRPM := yes
ALL += ejabberd

#
# sfa - Slice Facility Architecture
#
sfa-MODULES := sfa
sfa-SPEC := sfa.spec
ALL += sfa

#
# nodeconfig
#
nodeconfig-MODULES := nodeconfig
nodeconfig-SPEC := nodeconfig.spec
ALL += nodeconfig

#
# bootmanager
#
bootmanager-MODULES := BootManager
bootmanager-SPEC := bootmanager.spec
ALL += bootmanager

#
# pypcilib : used in bootcd
# 
pypcilib-MODULES := pypcilib
pypcilib-SPEC := pypcilib.spec
ALL += pypcilib
IN_BOOTCD += pypcilib

#
# pyplnet
#
pyplnet-MODULES := pyplnet
pyplnet-SPEC := pyplnet.spec
ALL += pyplnet
IN_BOOTSTRAPFS += pyplnet
IN_BOOTCD += pyplnet

#
# OMF resource controller
#
omf-resctl-MODULES := omf
omf-resctl-SPEC := omf-resctl.spec
ALL += omf-resctl
IN_VSERVER += omf-resctl

#
# OMF exp controller
#
omf-expctl-MODULES := omf
omf-expctl-SPEC := omf-expctl.spec
ALL += omf-expctl

#
# bootcd
#
bootcd-MODULES := BootCD build
bootcd-SPEC := bootcd.spec
bootcd-RPMBUILD := bash ./rpmbuild.sh
bootcd-DEPEND-PACKAGES := $(IN_BOOTCD)
bootcd-DEPEND-FILES := RPMS/yumgroups.xml
bootcd-RPMDATE := yes
ALL += bootcd

#
# vserver : reference image for slices
#
vserver-MODULES := VserverReference build
vserver-SPEC := vserver-reference.spec
vserver-DEPEND-PACKAGES := $(IN_VSERVER)
vserver-DEPEND-FILES := RPMS/yumgroups.xml
vserver-RPMDATE := yes
ALL += vserver
IN_BOOTSTRAPFS += vserver

#
# bootstrapfs
#
bootstrapfs-MODULES := BootstrapFS build
bootstrapfs-SPEC := bootstrapfs.spec
bootstrapfs-RPMBUILD := bash ./rpmbuild.sh
bootstrapfs-DEPEND-PACKAGES := $(IN_BOOTSTRAPFS)
bootstrapfs-DEPEND-FILES := RPMS/yumgroups.xml
bootstrapfs-RPMDATE := yes
ALL += bootstrapfs

#
# noderepo
#
# all rpms resulting from packages marked as being in bootstrapfs and vserver
NODEREPO_RPMS = $(foreach package,$(IN_BOOTSTRAPFS) $(IN_VSERVER),$($(package).rpms))
# replace space with +++ (specvars cannot deal with spaces)
SPACE=$(subst x, ,x)
NODEREPO_RPMS_3PLUS = $(subst $(SPACE),+++,$(NODEREPO_RPMS))

noderepo-MODULES := BootstrapFS 
noderepo-SPEC := noderepo.spec
noderepo-RPMBUILD := bash ./rpmbuild.sh
# package requires all embedded packages
noderepo-DEPEND-PACKAGES := $(IN_BOOTSTRAPFS) $(IN_VSERVER)
noderepo-DEPEND-FILES := RPMS/yumgroups.xml
#export rpm list to the specfile
noderepo-SPECVARS = node_rpms_plus=$(NODEREPO_RPMS_3PLUS)
noderepo-RPMDATE := yes
ALL += noderepo

#
# slicerepo
#
# all rpms resulting from packages marked as being in vserver
SLICEREPO_RPMS = $(foreach package,$(IN_VSERVER),$($(package).rpms))
# replace space with +++ (specvars cannot deal with spaces)
SPACE=$(subst x, ,x)
SLICEREPO_RPMS_3PLUS = $(subst $(SPACE),+++,$(SLICEREPO_RPMS))

slicerepo-MODULES := BootstrapFS 
slicerepo-SPEC := slicerepo.spec
slicerepo-RPMBUILD := bash ./rpmbuild.sh
# package requires all embedded packages
slicerepo-DEPEND-PACKAGES := $(IN_VSERVER)
slicerepo-DEPEND-FILES := RPMS/yumgroups.xml
#export rpm list to the specfile
slicerepo-SPECVARS = slice_rpms_plus=$(SLICEREPO_RPMS_3PLUS)
slicerepo-RPMDATE := yes
ALL += slicerepo

#
# MyPLC : lightweight packaging, dependencies are yum-installed in a vserver
#
myplc-MODULES := MyPLC
myplc-SPEC := myplc.spec
myplc-DEPEND-FILES := myplc-release RPMS/yumgroups.xml
ALL += myplc

# myplc-docs only contains docs for PLCAPI and NMAPI, but
# we still need to pull MyPLC, as it is where the specfile lies, 
# together with the utility script docbook2drupal.sh
myplc-docs-MODULES := MyPLC PLCAPI NodeManager Monitor
myplc-docs-SPEC := myplc-docs.spec
ALL += myplc-docs

# using some other name than myplc-release, as this is a make target already
release-MODULES := MyPLC
release-SPEC := myplc-release.spec
release-RPMDATE := yes
ALL += release
