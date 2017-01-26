## Usage:
##
##   To build the current upstream version (as defined in WF_CURRENT_VERSION):
##
##     make
##
##   To build a specific version:
##
##     make version=8.0.0.Final
##
## Requires:
##
##   debhelper and devscripts packages 
##

WF_CURRENT_VERSION = 10.1.0.Final

WF_VERSION := $(or $(version),$(WF_VERSION),$(WF_CURRENT_VERSION))
WF_TARBALL = wildfly-$(WF_VERSION).tar.gz
WF_SYMLINK = $(subst -,_,$(subst tar.gz,orig.tar.gz,$(WF_TARBALL)))
WF_DIRECTORY = wildfly-$(WF_VERSION)
WF_DOWNLOAD_URL = http://download.jboss.org/wildfly/$(WF_VERSION)/$(WF_TARBALL)
WF_DISTRIBUTION := $(or $(distribution),$(WF_DISTRIBUTION),$(shell lsb_release -sc))

build: $(WF_TARBALL) $(WF_SYMLINK) unpack copy $(WF_DIRECTORY)/debian/wildfly.init ensure-debhelper-and-devscripts-packages-are-installed
	cd $(WF_DIRECTORY) && \
	dch --create --distribution=$(WF_DISTRIBUTION) --package=wildfly --newversion=$(WF_VERSION)-1 "packaging wildfly" && \
	dpkg-buildpackage -us -uc

$(WF_TARBALL): /usr/bin/wget
	/usr/bin/wget $(WF_DOWNLOAD_URL)

$(WF_SYMLINK): $(WF_TARBALL)
	ln -s $(WF_TARBALL) $(WF_SYMLINK)

unpack: $(WF_SYMLINK) clean
	tar -xzf $(WF_TARBALL)

copy: unpack
	cp -R debian $(WF_DIRECTORY)/

$(WF_DIRECTORY)/debian/wildfly.init: copy
	find $(WF_DIRECTORY) -name wildfly-init-debian.sh -exec cp {} $(WF_DIRECTORY)/debian/wildfly.init \;

.PHONY: ensure-debhelper-and-devscripts-packages-are-installed
ensure-debhelper-and-devscripts-packages-are-installed: /usr/bin/dpkg-buildpackage /usr/bin/dch
	@echo Ensure that the debhelper and devscripts packages are installed

.PHONY: clean
clean:
	rm -rf $(WF_DIRECTORY)

.PHONY: cleanall
cleanall: clean
	rm -f $(WF_SYMLINK) $(WF_TARBALL)
