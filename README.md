# skywire
Scripts for installing skywire on raspberries. The skywire services are aumatically run at each reboot.

**IMPORTANT:** these scripts are still being tested. As soon as the testing is done, a version tag will be added.

## usage
The first time you start your raspberry, you'll see the install menu where you can choose which OS to install. I have tried with both raspbian (the default option) and raspbian lite (raspbian without desktop). If you are confortable with the command line, I definitely recommend raspbian lite (you don't need a GUI, and the OS occupies less than 1Gb).

##### note on OS raspbian
Once the OS installed, you'll be asked to enter a password for the default user ```pi```. You can change that password from the terminal (if desired) with ```sudo passwd pi```. 
##### note on OS raspian lite
Once the OS installed, you'll be asked to enter a user and password. You can log in with user ```pi``` and password ```raspberry```. You can then reset the password with (recommended) with ```sudo passwd pi```. 

Set the password for ```root``` with ```sudo passwd root```. This is important as the install script ```setup.sh``` must be run as ```root```. 

Some useful tips:
```
Ctrl+Alt+T # shortcut for opening a terminal in case you installed raspbian (with desktop)
sudo -i # log as root (alternative: su)
```

Connect your raspberry to the internet with ethernet or wifi, go to your router (typically 192.168.1.1 or 192.168.0.1), make sure DHCP is enabled for additional nodes, configure the local IP address of the raspberry which will run the skywire manager as static (for example: 192.168.1.142) and write it down.

Open a terminal and download the scripts. Then install your skyminer (same for the manager as for the nodes):

```
cd /home/pi/Desktop # just an example, you can run the scripts from any directory
git clone https://github.com/MFnx/skywire.git
sudo -i # enter password if asked for
sh skywire/setup.sh --all --manager-ip 192.168.1.142 # the static IP you wrote down
```

When finished, the folder in ```/home/pi/Desktop/skywire``` (or wherever you downloaded the scripts) is not needed anymore and can be deleted.

You can now access your skywire manager via a browser at 192.168.1.142:8000 and see your public keys. If additional nodes are installed (same procedure as described above), you will see all your nodes with public and private keys there.

For information on how to whitelist your skyminer: https://github.com/skycoin/skywire/wiki/Skywire-Whitelisting-System

Additional information about the scripts and advanced usage is given below.

## scripts
### setup.sh
This is the script the user interacts with. If needed, set permissions: 

````sudo chmod 777 setup.sh````

It comes with a ```--help``` flag which explains how to use the script. You can install the skywire in three steps using the following flags:

```
--update # updates your system (see install_update.sh)
--golang # installs golang (see install_golang.sh)
--skywire # installs skywire (see install_skywire.sh)
--manager-ip # needed when using the --skywire or --all flag
```
You can install the skywire with one single command:

```sh setup.sh --all --manager-ip <YOUR_MANAGER_IP>```

When skywire is installed, the system will reboot. You can also install the skywire in 3 steps as follows:

```
sh setup.sh --update
sh setup.sh --golang
sh setup.sh --all --manager-ip <YOUR_MANAGER_IP>
```

This might be useful for debugging purposes. The system will not reboot.

The script must be executed as ```root```. Only ```sh setup.sh --help``` can be run by another user. The script first manages the input arguments by scanning the flags. It then checks if it's being executed by ```root``` and if the manager IP exists (if provided). It then installs the software according to the input flags.

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
This script installs ```go1.12.7.linux-armv6l.tar.gz``` from https://storage.googleapis.com/golang/$golang_version. It adds some paths to ```~/.bashrc``` and adds links in ```/usr/local/bin``` pointing to the ```golang``` binaries. Finally, it reloads the environment.

### install_skywire.sh
This scripts installs the official skywire software from https://github.com/skycoin/skywire.git. Finally, it adds a cron job which runs the skywire services at each reboot.

