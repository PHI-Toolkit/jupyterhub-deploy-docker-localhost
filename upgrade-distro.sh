#!/bin/bash
# update the distro line
sed -i 's/xenial/bionic/g' /etc/apt/sources.list
apt-get update
apt-get dist-upgrade -y
apt-get autoremove
