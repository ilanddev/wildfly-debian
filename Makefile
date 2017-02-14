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
WF_TARBALL_ORIG = $(subst -,_,$(subst tar.gz,orig.tar.gz,$(WF_TARBALL)))
WF_DIRECTORY = wildfly-$(WF_VERSION)
WF_DOWNLOAD_URL = http://download.jboss.org/wildfly/$(WF_VERSION)/$(WF_TARBALL)
WF_DISTRIBUTION := $(or $(distribution),$(WF_DISTRIBUTION),$(shell lsb_release -sc))
GPG_KEY := $(or $(gpg),$(GPG_KEY))
PPA_VERSION := $(or $(ppa_version),$(PPA_VERSION),$(shell cat PPA_VERSION))

build: prepare $(WF_TARBALL_ORIG) ensure-debhelper-and-devscripts-packages-are-installed
ifdef GPG_KEY
	cd $(WF_DIRECTORY) && dpkg-buildpackage -F -k$(GPG_KEY)
else
	cd $(WF_DIRECTORY) && dpkg-buildpackage -us -uc
endif

source: prepare $(WF_TARBALL_ORIG) ensure-debhelper-and-devscripts-packages-are-installed
ifdef GPG_KEY
	cd $(WF_DIRECTORY) && debuild -S -k$(GPG_KEY)
else
	@echo GPG_KEY is not set. Please pass the key via gpg= on the command line, or set GPG_KEY in the environment.
endif
#(error GPG_KEY is not set. Please pass the key via gpg= on the command line, or set GPG_KEY in the environment.)

$(WF_TARBALL): /usr/bin/wget
	/usr/bin/wget $(WF_DOWNLOAD_URL)

$(WF_TARBALL_ORIG): $(WF_TARBALL)
	ln $(WF_TARBALL) $(WF_TARBALL_ORIG)

unpack: $(WF_TARBALL) clean
	tar -xzf $(WF_TARBALL)

copy: unpack
	cp -R debian $(WF_DIRECTORY)/

$(WF_DIRECTORY)/debian/wildfly.init: copy
	find $(WF_DIRECTORY) -name wildfly-init-debian.sh -exec cp {} $(WF_DIRECTORY)/debian/wildfly.init \;

prepare: $(WF_DIRECTORY)/debian/wildfly.init PPA_VERSION
	cd $(WF_DIRECTORY) && \
	dch --create --distribution=$(WF_DISTRIBUTION) --package=wildfly \
	    --newversion=$(WF_VERSION)-1~ppa$(PPA_VERSION) "packaging wildfly"

.PHONY: ensure-debhelper-and-devscripts-packages-are-installed
ensure-debhelper-and-devscripts-packages-are-installed: /usr/bin/dpkg-buildpackage /usr/bin/dch
	@echo Ensure that the debhelper and devscripts packages are installed

.PHONY: clean
clean:
	rm -rf $(WF_DIRECTORY)

.PHONY: cleanall
cleanall: clean
	rm -f $(WF_TARBALL_ORIG) $(WF_TARBALL) *.debian.tar.gz *.dsc *.changes *.build *.ppa.upload *.deb
