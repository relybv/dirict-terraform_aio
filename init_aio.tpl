#!/bin/bash
echo "Start of boot script"

export FACTER_monitor_address="${monitor_address}"
echo "Rsyslog server is: $FACTER_monitor_address"

export FACTER_nfs_address="${nfs_address}"
echo "NFS server is: $FACTER_nfs_address"

export FACTER_db_address="${db_address}"
echo "Database server is: $FACTER_db_address"

echo "Create hiera directories"
mkdir -p /etc/puppetlabs/puppet
mkdir -p /etc/puppetlabs/code/environments/production/hieradata

echo "Write hiera.yaml /etc/puppetlabs/puppet/hiera.yaml"
cat <<'EOF' >> /etc/puppetlabs/puppet/hiera.yaml
---
:backends:
  - json
  - yaml
:hierarchy:
  - "nodes/%{::trusted.certname}"
  - customer
  - relybv
  - common

:yaml:
  :datadir: "/etc/puppetlabs/code/environments/production/hieradata"
:json:
  :datadir: "/etc/puppetlabs/code/environments/production/hieradata"
EOF

echo "Write customer hieradata"
echo '${file("customer.json")}' > "/etc/puppetlabs/code/environments/production/hieradata/customer.json"

echo "Bootstrap puppet and apply role"
wget https://raw.githubusercontent.com/relybv/dirict-role_aio/master/files/bootme.sh && bash bootme.sh
