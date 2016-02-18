#!/bin/bash


if [[ ! $(which ansible) ]] ; then
    ${APT} install ansible &>/dev/null
    echo "[+] Ansible installed."
else
    echo "[+] Ansible already installed."
fi

if [ ! -f ~/.boto ]; then
    echo "[+] creating ~/.boto .."
    touch ~/.boto
    echo "[+] ~/.boto created."
fi

exit 0
