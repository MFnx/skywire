#!/bin/bash

MANAGER_IP=$1

# remove previous installation if any
cd
if [ -d "$HOME/go" ]
then
	rm -rf $HOME/go
fi

# download git
apt-get install -y git

# download skywire
mkdir -p $HOME/go/bin
mkdir -p $HOME/go/pkg
mkdir -p $HOME/go/src
mkdir -p $HOME/go/src/github.com/skycoin
cd $HOME/go/src/github.com/skycoin
rm -rf skywire
git clone https://github.com/skycoin/skywire.git

# install skywire
cd $HOME/go/src/github.com/skycoin/skywire/cmd
go install ./...

# create job to load skywire at startup
script=/etc/init.d/start_skywire.sh
job="@reboot sleep 60 && bash $script"
crontab -l > jobs
line_number=$(grep -n "$job" jobs | grep -Eo '^[^:]+')
if [ -z "$line_number" ]
then
	echo "$job" >> jobs # add job
	crontab jobs # reset crontab
	rm jobs
fi

# script to load skywire
if [ -f "$script" ]
then
	rm $script
fi
touch $script
/bin/cat <<EOM >>$script
#!/bin/bash
export GOPATH=$HOME/go
cd $GOPATH/bin
./skywire-manager -web-dir /root/go/src/github.com/skycoin/skywire/static/skywire-manager > /dev/null 2>&1 &
sleep 5
cd $GOPATH/bin
./skywire-node -connect-manager -manager-address $MANAGER_IP:5998 -manager-web $MANAGER_IP:8000 -discovery-address testnet.skywire.skycoin.com:5999-028ec969bdeb92a1991bb19c948645ac8150468a6919113061899051409de3f243 -address :5000 -web-port :6001 &> /dev/null 2>&1 &
echo "Access the Skywire Manager in your browser: $MANAGER_IP:8000"
sleep 10
EOM

# set execute permissions
chmod +x $script
