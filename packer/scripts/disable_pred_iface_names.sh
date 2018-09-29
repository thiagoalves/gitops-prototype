#!/bin/bash

# disable pred iface names as kernel param
sed -i '/^GRUB\_CMDLINE\_LINUX/s/\"$/\ net\.ifnames\=0\"/' /etc/default/grub
update-grub

# remove existing network config
#rm /etc/network/interfaces.d/50-cloud-init.cfg || true
#rm /etc/udev/rules.d/70-persistent-net.rules || true

# remove cloud-init data
#( cd /var/lib/cloud/ && sudo rm -rf * )
