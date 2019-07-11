#!/bin/bash

# download golang
golang_version="go1.12.7.linux-armv6l.tar.gz"
cd
wget https://storage.googleapis.com/golang/$golang_version
tar xvf $golang_version
rm $golang_version
if [ -d /usr/local/go ]
then
	rm -rf /usr/local/go
fi
mv go /usr/local/go

# add golang preferences
if [ ! "$(grep "# golang preferences" .bashrc)" ]
then
	export GOROOT=/usr/local/go
	export GOPATH=$HOME/go
	export GOBIN=$GOPATH/bin
	
	/bin/cat <<EOM >>.bashrc

# golang preferences
export GOROOT=$GOROOT
export GOPATH=$GOPATH
export GOBIN=$GOBIN
export PATH=$PATH:$GOBIN
EOM

fi

# install golang by setting links
rm -f /usr/local/bin/go
rm -f /usr/local/bin/godoc
rm -f /usr/local/bin/gofmt
ln -s /usr/local/go/bin/go /usr/local/bin/go
ln -s /usr/local/go/bin/godoc /usr/local/bin/godoc 
ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt
