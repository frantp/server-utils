#!/bin/bash
# Simple LDAP configuration for Ubuntu 18.04
# https://www.server-world.info/en/note?os=Ubuntu_18.04&p=openldap&f=3

# Install
apt install -y libnss-ldap libpam-ldap ldap-utils nscd

# Basic configuration
sed -i 's/\(\(passwd\|group\):.*\)/\1 ldap/g' /etc/nsswitch.conf
sed -i 's/\(pam_ldap\.so.*\)\( use_authtok\)/\1/g' /etc/pam.d/common-password
echo 'session optional\tpam_mkhomedir.so skel=/etc/skel umask=077' >> /etc/pam.d/common-session

# Shell and TLS configuration
cfg='nss_override_attribute_value loginShell /bin/bash
ssl start_tls
tls_checkpeer no'
echo "${cfg}" >> /etc/ldap.conf

# Add sudoers group
read -p "sudo group (empty to omit): " sugroup
if [ -n "${sugroup}" ]; then
  echo "%${sugroup}\tALL=(ALL) ALL" >> /etc/sudoers
fi

# Restart daemons
systemctl restart systemd-logind libnss-ldap nscd
