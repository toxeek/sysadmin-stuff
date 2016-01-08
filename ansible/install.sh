#!/bin/bash

APT=$(which apt-get)

if [ "$UID" -ne "0" ] ; then
    echo "[+] you have to be r00t." >&2
    exit 1
fi

if [[ ! $(which ansible) ]] ; then
    $APT "update" &>/dev/null && $APT install ansible &>/dev/null
    echo "[+] Ansible installed."
else
    echo "[+] Ansible already installed."
fi

exit 0
