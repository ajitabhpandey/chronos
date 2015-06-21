#!/bin/bash
# Sync the remote backup director on server to local backup directory
# Note - Need bash as we are using arrays, so sh in shebang line will not work
#
RSYNC_CMD="/usr/bin/rsync"
SERVER_LIST="remote_server_fqdn_or_ip"
SOURCE="/source/on/server/"
TARGET="/local/destination/"
# -i is the ssh key allowed to do remote login without a password
# -p is to specify the port on which SSHD is listening, if its default (22), it can be ignored
RSYNC_OPTIONS=(-avzhPe '/usr/bin/ssh -p 22 -i /home/user/.ssh/id_rsa')
for SERVER in $SERVER_LIST
do
  $RSYNC_CMD "${RSYNC_OPTIONS[@]}" ajitabhp@"$SERVER":"$SOURCE" "$TARGET"
done
