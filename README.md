# wildfly-debian

Debian and Ubuntu Packaging for Wildfly

Much borrowed from https://github.com/mattthias/wildfly-packaging

## Building the package

Install prerequisites:

    apt-get install devscripts debhelper

Clone this project:

    git clone https://github.com/ilanddev/wildfly-debian.git

Download the Wildfly "source":

    wget http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.tar.gz

Create a link to the downloaded file named `wildfly_10.1.0.Final.orig.tar.gz`:

    ln -s wildfly-10.1.0.Final.tar.gz wildfly_10.1.0.Final.orig.tar.gz

Extract the tarball and change into the directory:

    tar -xzf wildfly-10.1.0.Final.tar.gz 
    cd wildfly-10.1.0.Final/

Copy the `debian` directory from this repository into the `wildfly-10.1.0.Final` directory:

    cp -R ../wildfly-debian/debian .

Build the package:

    dpkg-buildpackage -us -uc

The `.deb` file will be in the parent directory, along with the other generated files:

    drwxr-xr-x 11 root root      4096 Dec 21 19:44 wildfly-10.1.0.Final
    -rw-r--r--  1 root root 134396816 Jan 25 20:09 wildfly_10.1.0.Final_all.deb
    -rw-r--r--  1 root root      1724 Jan 25 20:09 wildfly_10.1.0.Final_amd64.changes
    -rw-r--r--  1 root root       875 Jan 25 20:07 wildfly_10.1.0.Final.debian.tar.gz
    -rw-r--r--  1 root root       811 Jan 25 20:07 wildfly_10.1.0.Final.dsc
    lrwxrwxrwx  1 root root        27 Jan 25 20:07 wildfly_10.1.0.Final.orig.tar.gz -> wildfly-10.1.0.Final.tar.gz
    -rw-r--r--  1 root root 139025162 Aug 19 00:27 wildfly-10.1.0.Final.tar.gz
