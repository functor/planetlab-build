#
# PlanetLab RPM generation
#
# Mark Huang <mlhuang@cs.princeton.edu>
# Copyright (C) 2003-2006 The Trustees of Princeton University
#
# $Id: Makefile,v 1.89 2007/09/12 20:26:20 mef Exp $
#

# Default target
all:

# By default, the naming convention for built RPMS is
# <name>-<version>-<release>.<PLDISTRO>.<arch>.rpm
# Set PLDISTRO on the command line to differentiate between downstream
# variants.
PLDISTRO := planetlab

include $(PLDISTRO).mk

RPMBUILD ?= bash ./rpmbuild.sh
CVS_RSH ?= ssh

ifeq ($(findstring $(package),$(ALL)),)

# Build all packages
all: $(ALL)

# Recurse
$(ALL):
	@echo -n "XXXXXXXXXXXXXXX -- BEG $@ " ; date
	$(MAKE) package=$@
	@echo -n "XXXXXXXXXXXXXXX -- END $@ " ; date

# Remove files generated by this package
$(foreach package,$(ALL),$(package)-clean): %-clean:
	$(MAKE) package=$* clean

# Remove all generated files
clean:
	rm -rf BUILD RPMS SOURCES SPECS SRPMS .rpmmacros tmp parseSpec

.PHONY: all $(ALL) $(foreach package,$(ALL),$(package)-clean) clean

else

# Define variables for Rules.mk
#CVSROOT := $(if $($(package)-CVSROOT),$($(package)-CVSROOT),$(CVSROOT))
#SVNPATH := $(if $($(package)-SVNPATH),$($(package)-SVNPATH),$(SVNPATH))
TAG := $(if $($(package)-TAG),$($(package)-TAG),$(TAG))
MODULE := $($(package)-MODULE)
SPEC := $($(package)-SPEC)
RPMFLAGS := $(if $($(package)-RPMFLAGS),$($(package)-RPMFLAGS),$(RPMFLAGS))
RPMBUILD := $(if $($(package)-RPMBUILD),$($(package)-RPMBUILD),$(RPMBUILD))
CVS_RSH := $(if $($(package)-CVS_RSH),$($(package)-CVS_RSH),$(CVS_RSH))

include Rules.mk

endif
