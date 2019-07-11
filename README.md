# skywire
Scripts for installing skywire on raspberries. The skywire services are aumatically run at each reboot.

The scripts have been fully tested on a raspberry pi 3 B+ with OS raspbian lite.

## usage
```
bash setup.sh --all --manager-ip <STATIC_IP_SKYWIRE_MANAGER>
```

```STATIC_IP_SKYWIRE_MANAGER``` is the IP address of the raspberry which runs the skywire manager.

For more details, read [this tutorial](https://skywug.net/forum/Thread-DIY-Skyminer-on-raspberry-pi-devices?pid=2843#pid2843).

Additional information about the scripts and advanced usage is given below.

## scripts
### setup.sh
This is the script the user interacts with.

It comes with a ```--help``` flag which explains how to use the script. You can install the skywire in three steps using the following flags:

```
--update # updates your system (see install_update.sh)
--golang # installs golang (see install_golang.sh)
--skywire # installs skywire (see install_skywire.sh)
--manager-ip # needed when using the --skywire or --all flag
```
You can install the skywire with one single command:

```bash setup.sh --all --manager-ip <STATIC_IP_SKYWIRE_MANAGER>```

When skywire is installed, the system will reboot. You can also install the skywire in 3 steps as follows:

```
bash setup.sh --update
bash setup.sh --golang
bash setup.sh --all --manager-ip <STATIC_IP_SKYWIRE_MANAGER>
```

This might be useful for debugging purposes. The system will not reboot.

The script must be executed as ```root```. Only ```bash setup.sh --help``` can be run by another user. The script first manages the input arguments by scanning the flags. It then checks if it's being executed by ```root``` and if the manager IP exists (if provided). It then installs the software according to the input flags.

### install_update.sh
This script simply updates and upgrades your system, and installs the following additional packages:

```
curl
git
mercurial
binutils
bzr
bison
libgmp3-dev
screen
build-essential
```

Finally, it enables ```ssh``` which is convenient if you want to access your raspberry from another device.

### install_golang.sh
This script installs ```go1.12.7.linux-armv6l.tar.gz``` from https://storage.googleapis.com/golang/$golang_version. It adds some paths to ```~/.bashrc``` and adds links in ```/usr/local/bin``` pointing to the ```golang``` binaries.

### install_skywire.sh
This scripts installs the official skywire software from https://github.com/skycoin/skywire.git. Finally, it adds a cron job which runs the skywire services at each reboot.
