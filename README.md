# wildfly-debian

Debian and Ubuntu Packaging for Wildfly

Originally based on https://github.com/mattthias/wildfly-packaging

## Building the Wildfly package

Install prerequisites:

    apt-get install devscripts debhelper

Clone this project:

    git clone https://github.com/ilanddev/wildfly-debian.git

Change into the directory and run `make`:

    cd wildfly-debian
    make

This will build the most recently released "Final" version of Wildfly.

All generated files, including the `.deb` file, will be placed in the current directory:

    drwxr-xr-x 11 root root      4096 Dec 21 19:44 wildfly-10.1.0.Final
    -rw-r--r--  1 root root 134396816 Jan 25 20:09 wildfly_10.1.0.Final_all.deb
    -rw-r--r--  1 root root      1724 Jan 25 20:09 wildfly_10.1.0.Final_amd64.changes
    -rw-r--r--  1 root root       875 Jan 25 20:07 wildfly_10.1.0.Final.debian.tar.gz
    -rw-r--r--  1 root root       811 Jan 25 20:07 wildfly_10.1.0.Final.dsc
    lrwxrwxrwx  1 root root        27 Jan 25 20:07 wildfly_10.1.0.Final.orig.tar.gz -> wildfly-10.1.0.Final.tar.gz
    -rw-r--r--  1 root root 139025162 Aug 19 00:27 wildfly-10.1.0.Final.tar.gz

## Building with Custom Options

### Specifying a version

To build a different version, you can either pass the version as a Makefile parameter or use environment variables:

    make version=8.0.0.Final

or

    WF_VERSION=8.0.0.Final make

or

    export WF_VERSION=10.0.0.Final
    make

The `version` command line parameter takes precendence over the `WF_VERSION` environment variable.

### Specifying a distribution

By default the Makefile will build a debian package for the distribution of the build system. To override this you can:

    make distribution=trusty

or

    WF_DISTRIBUTION=trusty make

or

    export WF_DISTRIBUTION=trusty
    make

### Setting Environment Variables for Debian changelog

The `dch` command looks for several environment variables to use when generating the changelog file:

    export DEBFULLNAME="Your Name"
    export DEBEMAIL="youremail@example.com"
    make

### Using a Configuration File

All of these configuration options can be maintained in a file that sets the environment variables in one place:

    # wildfly.env
    set -a
    WF_DISTRIBUTION="trusty"
    WF_VERSION="8.0.0.Final"
    DEBFULLNAME="Your Name"
    DEBEMAIL="youremail@example.com"
    set +a

The `set -a` line enables auto-exporting of any variables that follow, and the `set +a` at the end disables that.

Build wildfly:

    source wildfly.env
    make

This should result in the following output during the build:

    dpkg-buildpackage: source package wildfly
    dpkg-buildpackage: source version 8.0.0.Final-1
    dpkg-buildpackage: source distribution trusty
    dpkg-buildpackage: source changed by Your Name <youremail@example.com>
