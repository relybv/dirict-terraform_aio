#!/bin/bash
echo "Start of boot script"
export FACTER_monitor_address="${monitor_address}"
echo "Rsyslog server is: $FACTER_monitor_address"

export FACTER_nfs_address="${nfs_address}"
echo "NFS server is: $FACTER_nfs_address"

export FACTER_db_address="${db_address}"
echo "Database server is: $FACTER_db_address"
wget https://raw.githubusercontent.com/relybv/dirict-role_aio/master/files/bootme.sh && bash bootme.sh
