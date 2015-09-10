#!/bin/bash

# To allow automated installation of new packages, we set the debconf(7) frontend to noninteractive,
# which never prompts the user for choices on installation/configuration of packages
export DEBIAN_FRONTEND=noninteractive

## Prevent initramfs updates from trying to run grub and lilo.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
export INITRD=no

# Hack for initctl not being available inside docker #
if [ "`dpkg-divert --truename /sbin/initctl`" = "/sbin/initctl" ]; then
	dpkg-divert --local --rename --add /sbin/initctl
	ln -s /bin/true /sbin/initctl
fi

# Fix ischroot that might not work correctly inside docker #
if [ "`dpkg-divert --truename /usr/bin/ischroot`" = "/usr/bin/ischroot" ]; then
	dpkg-divert --local --rename --add /usr/bin/ischroot
	ln -s /bin/true /usr/bin/ischroot
fi

# Fix sysctl that might not work correctly inside docker #
if [ "`dpkg-divert --truename /sbin/sysctl`" = "/sbin/sysctl" ]; then
	dpkg-divert --local --rename --add /sbin/sysctl
	ln -s /bin/true /sbin/sysctl
fi

# Fix systemd-logind that might not work correctly inside docker #
if [ "`dpkg-divert --truename /etc/init.d/systemd-logind`" = "/etc/init.d/systemd-logind" ]; then
	dpkg-divert --local --rename --add /etc/init.d/systemd-logind
	ln -s /bin/true /etc/init.d/systemd-logind
fi

# Configure policy-rc.d to always return 101 exit code #
# See http://people.debian.org/~hmh/invokerc.d-policyrc.d-specification.txt
cp /build/templates/policy-rc.d /usr/sbin/policy-rc.d

# Temporarily disable dpkg fsync to make building faster #
echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/02apt-speedup

# Setup APT sources
echo "deb http://ubuntu.mirrors.skynet.be/ubuntu precise main restricted universe multiverse" | tee /etc/apt/sources.list
echo "deb http://ubuntu.mirrors.skynet.be/ubuntu precise-updates main restricted universe multiverse" | tee -a /etc/apt/sources.list
echo "deb http://ubuntu.mirrors.skynet.be/ubuntu precise-security main restricted universe multiverse" | tee -a /etc/apt/sources.list
echo "deb http://ubuntu.mirrors.skynet.be/ubuntu precise-backports main restricted universe multiverse" | tee -a /etc/apt/sources.list
#echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu precise main" | tee -a /etc/apt/sources.list
#echo "deb-src http://ppa.launchpad.net/git-core/ppa/ubuntu precise main" | tee -a /etc/apt/sources.list

# Upgrade packages #
apt-get -qq update
apt-get -qq upgrade
apt-get -qq dist-upgrade

# Fix locale
apt-get update
apt-get install -qq language-pack-en

locale-gen en_US.UTF-8 && \
update-locale LANG=en_US.UTF-8 && \
dpkg-reconfigure locales

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# HTTPS Support for APT
apt-get install -qq apt-transport-https ca-certificates

# Base dependencies and tools
apt-get install -qq aptitude software-properties-common python-software-properties
apt-get install -qq sudo iputils-ping wget vim bzr bzip2 curl htop logrotate cron g++ rsync zip unzip nano vim curl less
apt-get install -qq python2.7 python2.7-dev
apt-get install -qq rsyslog make net-tools psmisc iftop iotop
curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo python2.7

# Git (needs software-properties-common python-software-properties)
add-apt-repository ppa:git-core/ppa
apt-get -qq update
apt-get install -qq git

# Scripts
cp /build/scripts/regenerate_ssh_host_keys.sh /regenerate_ssh_host_keys.sh
chmod +x /regenerate_ssh_host_keys.sh
