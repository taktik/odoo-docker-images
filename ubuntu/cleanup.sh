#!/bin/bash

# Clean temporary files
apt-get -qq autoclean
apt-get -qq autoremove
apt-get -qq clean
rm -rf /tmp/* /var/tmp/*
rm -rf /var/lib/apt/lists/*

# Remove temporary APT speedup config file #
rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup
