# Vagrant-LocalDeb

Overrides the Debian capabilities to use local .deb files instead of apt-get to install `rsync` and an NFS client. This means you can proceed to the provisioning stage on a vanilla Debian box without Internet access, but you must provide the necessary .deb files.

## Installation

    $ vagrant plugin install vagrant-localdeb

## Usage

Obtain .deb files and take note of which dependencies are required for which installation. The simplest way is to:

```
    $ apt-get install rsync
    $ ls /var/cache/apt/archives/*.deb
```

```
    $ apt-get install nfs-common
    $ ls /var/cache/apt/archives/*.deb
```

Take a copy of the files, and place them in one of the following locations:

    - your vagrant project directory (alongside Vagrantfile)
    - the '.vagrant' subdirectory
    - a '.offline' subdirectory

Name the files rsync.n.deb and nfs.n.deb where 'n' is a number indicating the order the files should be installed (dependencies first).

Alternatively, you can place symlinks to the real files.

Voilà!

