#!/bin/bash

# default arguments
WORKDIR=$(dirname "$0")
INSTALL_UPDATE=false
INSTALL_GOLANG=false
INSTALL_SKYWIRE=false
INSTALL_ALL=false
MANAGER_IP=""
MANAGER_IP_IS_VALID=false


# arguments
while test $# -gt 0; do
	case "$1" in
		--help)
			printf "\n%0s\n" "Setup skyminer with flags (run as root):"
			printf "%4s%s\n" '' "--all --manager-ip <MANAGER_IP_ADDRESS> (example: 192.168.1.36)"
			printf "%4s%s\n" '' "--update"
			printf "%4s%s\n" '' "--golang"
			printf "%4s%s\n" '' "--skywire --manager-ip <MANAGER_IP_ADDRESS> (example: 192.168.1.36)"
			printf "\n"
			printf "%4s%s\n" '' "You can do the job with one command using the --all flag."
			printf "%4s%s\n" '' "You can do the installation step by step, for debugging purposes."
			printf "%4s%s\n" '' "In order to do so, proceed as follows:"
			printf "%4s%s\n" '' "1) Run setup.sh --update. This will update your raspberry and enable ssh."
			printf "%4s%s\n" '' "2) Run setup.sh --golang. This will install golang (1.12.7)."
			printf "%4s%s\n" '' "3) Run setup.sh --skywire --manager-ip <MANAGER_IP_ADDRESS>. This will install the skywire software."
			printf "%4s%s\n" '' "4) Reboot."
			exit
			;;
		--update)
			INSTALL_UPDATE=true
			break
			;;
		--golang)
			INSTALL_GOLANG=true
			break
			;;
		--skywire)
			INSTALL_SKYWIRE=true
			if [ -z "$MANAGER_IP" ]; then
				shift
			else
				break
			fi
			;;
		--manager-ip)
			shift
			if test $# -gt 0; then
				MANAGER_IP=$1
			else
				printf "ERROR: the IP address of the manager must be provided."
				exit 1
			fi
			if [ "$INSTALL_SKYWIRE" = true ]; then
				break
			else
				if [ "$INSTALL_ALL" = true ]; then
					break
				else
					shift
				fi
			fi
			;;
		--all)  
			INSTALL_ALL=true
			if [ -z "$MANAGER_IP" ]; then
				shift
			else
				break
			fi
			;;
		*)
			break
			;;
	esac
done


# check if root
if [ "$(id -u)" != "0" ]
then
	printf "\t%s\n" "This script must be run as root."
	printf "\t%s\n" "Execute <sudo -i> (without the <>) or <su> and try again."
	printf "\t%s\n" "If you don't know the password for the root user, try to set it with <sudo passwd root>."
	printf "\t%s\n" "If you don't know the sudo password (pi user), the default one is <raspberry>."
	exit 1
fi


# check if manager ip exists
if ping -c1 -w3 $MANAGER_IP >/dev/null 2>&1
then
	MANAGER_IP_IS_VALID=true
fi


# permissions
chmod 777 $WORKDIR/install_update.sh
chmod 777 $WORKDIR/install_golang.sh
chmod 777 $WORKDIR/install_skywire.sh


# install update
if [ "$INSTALL_UPDATE" = true ]
then
	sh $WORKDIR/install_update.sh
fi


# install golang
if [ "$INSTALL_GOLANG" = true ]
then
	sh $WORKDIR/install_golang.sh
fi


# install skywire
if [ "$INSTALL_SKYWIRE" = true ]
then
	if [ "$MANAGER_IP_IS_VALID" = true ]
	then
		sh $WORKDIR/install_skywire.sh $MANAGER_IP
	else
		echo "The provided IP address $MANAGER_IP is not a valid." >&2
		exit 1
	fi
fi


# install all
if [ "$INSTALL_ALL" = true ]
then
	# check manager ip
	if [ "$MANAGER_IP_IS_VALID" = false ]
	then
		echo "The provided IP address $MANAGER_IP is not a valid." >&2
		exit 1
	fi
        
	# run setup
	sh $WORKDIR/install_update.sh
	sh $WORKDIR/install_golang.sh
	sh $WORKDIR/install_skywire.sh $MANAGER_IP
    
	# reboot
	reboot
fi
