#!/bin/bash
# System-wide oh-my-zsh installation
# https://stackoverflow.com/a/42193058

# zsh

apt install -y zsh
sed -i 's/DSHELL=.*/DSHELL=\/bin\/zsh/' /etc/adduser.conf
sed -i 's/SHELL=.*/SHELL=\/bin\/zsh/' /etc/default/useradd
sed -i "s/\/usr\/bin\/bash/\/usr\/bin\/zsh/g" /etc/passwd
if [ -f /etc/ldap.conf ]; then
    line="nss_override_attribute_value loginShell /bin/zsh"
    grep -q "nss_override_attribute_value\s*loginShell" /etc/ldap.conf && \
        sed -i "s/nss_override_attribute_value\s*loginShell.*/${line} \/bin\/zsh/" /etc/ldap.conf || \
        echo "${line}" >> /etc/ldap.conf
fi

# oh-my-zsh

cd /root
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
mv .oh-my-zsh /usr/share/oh-my-zsh
cd /usr/share/oh-my-zsh/
cp templates/zshrc.zsh-template zshrc
wget https://aur.archlinux.org/cgit/aur.git/plain/0001-zshrc.patch\?h\=oh-my-zsh-git -O - | patch -p1
ln zshrc /etc/skel/.zshrc

read -p "Zsh theme (empty for default): " zsh_theme
if [ -n "${zsh_theme}" ]; then
    sed -i "s/ZSH_THEME=.*/ZSH_THEME=\"${zsh_theme}\"/" zshrc
fi
