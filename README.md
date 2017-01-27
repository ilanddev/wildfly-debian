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

    -rw-r--r--  1 root root 134398972 Jan 27 16:53 wildfly_10.1.0.Final-0~ppa1485535916_all.deb
    -rw-r--r--  1 root root      2216 Jan 27 16:53 wildfly_10.1.0.Final-0~ppa1485535916_amd64.changes
    -rw-r--r--  1 root root      3467 Jan 27 16:52 wildfly_10.1.0.Final-0~ppa1485535916.debian.tar.gz
    -rw-r--r--  1 root root      1431 Jan 27 16:53 wildfly_10.1.0.Final-0~ppa1485535916.dsc
    -rw-r--r--  2 root root 139025162 Aug 19 00:27 wildfly_10.1.0.Final.orig.tar.gz
    -rw-r--r--  2 root root 139025162 Aug 19 00:27 wildfly-10.1.0.Final.tar.gz

## Building Sources for Ubuntu PPAs

Set a `PGP_KEY` environment variable or pass it on the command line to `make` as `gpg=`, then use the `source` target:

    make source gpg=7F5C3FB3

or

    export GPG_KEY="7F5C3FB3"
    make source

The generated files will be in the current directory:

    [...]
    Now signing changes and any dsc files...
     signfile wildfly_10.1.0.Final-0~ppa1485535653.dsc 7F5C3FB3

     signfile wildfly_10.1.0.Final-0~ppa1485535653_source.changes 7F5C3FB3

    Successfully signed dsc and changes files

## Building with Custom Options

### Signing with a GPG key

To sign the local packages with your GPG key:

    make gpg=7F5C3FB3

or

    export GPG_KEY="7F5C3FB3"
    make

### Specifying a version

To build a different version, you can either pass the version as a Makefile parameter or use environment variables:

    make version=8.0.0.Final

or

    export WF_VERSION=10.0.0.Final
    make

The `version` command line parameter takes precendence over the `WF_VERSION` environment variable.

### Specifying a distribution

By default the Makefile will build a debian package for the distribution of the build system. To override this you can:

    make distribution=trusty

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
    GPG_KEY="7F5C3FB3"
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
