#!/bin/sh

# Sync my Mail directories from y corp desktop to local

sync() {
  /usr/bin/rsync -avzhPe ssh --delete xxxxxxxx.xxxx.xxxx.domain.com:Mail/ycorp/ $HOME/Mail/ycorp/
}

# Check if the connectivity to the my corp machine is there
/bin/nc -x 127.0.0.1:9080 -z -w5 xxxxxxxx.xxxx.xxxx.domain.com 22

if [ $? -eq 0 ]
then 
  echo "Syncing..."
  sync
else 
  echo "Connecting..."
  /usr/bin/ssh -N -x -f proxy.corp.domain.com
  sync
fi

