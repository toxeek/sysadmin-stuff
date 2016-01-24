#!/bin/bash


if [[ ! $(which ansible) ]] ; then
    ${APT} install ansible &>/dev/null
    echo "[+] Ansible installed."
else
    echo "[+] Ansible already installed."
fi

echo "[+] creating ~/.boto .."
touch ~/.boto
echo "[+] ~/.boto created."


exit 0
