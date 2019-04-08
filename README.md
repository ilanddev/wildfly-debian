# wildfly-debian

Debian and Ubuntu Packaging for Wildfly

Originally based on https://github.com/mattthias/wildfly-packaging

## Installing the Wildfly Package via PPA

If the `java8-runtime` virtual package dependency is not already satisfied on the system them you may want to first install the `openjdk-8-jre-headless` package:

    sudo apt-get install openjdk-8-jre-headless

Install wildfly:

    sudo add-apt-repository ppa:ilanddev/wildfly-15
    sudo apt-get update
    sudo apt-get install wildfly

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

    -rw-r--r--  1 build build      3820 Mar 20 20:29 wildfly_15.0.1.Final-1~xenialppa1.debian.tar.xz
    -rw-r--r--  1 build build      1770 Mar 20 20:29 wildfly_15.0.1.Final-1~xenialppa1.dsc
    -rw-r--r--  1 build build      2223 Mar 20 20:29 wildfly_15.0.1.Final-1~xenialppa1_source.build
    -rw-r--r--  1 build build      2216 Mar 20 20:29 wildfly_15.0.1.Final-1~xenialppa1_source.changes
    -rw-rw-r--  1 build build       388 Mar 20 20:31 wildfly_15.0.1.Final-1~xenialppa1_source.ubuntu.upload
    -rw-rw-r--  1 build build       404 Mar 20 20:48 wildfly_15.0.1.Final-1~xenialppa1_source.wildfly-15.upload
    -rw-rw-r--  2 build build 179449615 Jan  7 00:51 wildfly_15.0.1.Final.orig.tar.gz
    -rw-rw-r--  2 build build 179449615 Jan  7 00:51 wildfly-15.0.1.Final.tar.gz

## Building Sources for Ubuntu PPAs

Set a `PGP_KEY` environment variable or pass it on the command line to `make` as `gpg=`, then use the `source` target:

    make source gpg=7F5C3FB3

or

    export GPG_KEY="7F5C3FB3"
    make source

The generated files will be in the current directory:

    [...]
    Now signing changes and any dsc files...
     signfile wildfly_15.0.1.Final-1~xenialppa1.dsc F70956F8

     signfile wildfly_15.0.1.Final-1~xenialppa1_source.changes F70956F8

    Successfully signed dsc and changes files

The `.changes` file can now be uploaded to Launchpad using `dput`.

## Building with Custom Options

### Signing with a GPG key

To sign the local packages with your GPG key:

    make gpg=7F5C3FB3

or

    export GPG_KEY="7F5C3FB3"
    make

### Specifying a version

To build a different version, you can either pass the version as a Makefile parameter or use environment variables:

    make version=15.0.1.Final

or

    export WF_VERSION=15.0.1.Final
    make

The `version` command line parameter takes precendence over the `WF_VERSION` environment variable.

### Specifying a distribution

By default the Makefile will build a debian package for the distribution of the build system. To override this you can:

    make distribution=bionic

or

    export WF_DISTRIBUTION=bionic
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
    WF_DISTRIBUTION="bionic"
    WF_VERSION="15.0.1.Final"
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
    dpkg-buildpackage: source version 15.0.1.Final-1
    dpkg-buildpackage: source distribution bionic
    dpkg-buildpackage: source changed by Your Name <youremail@example.com>
