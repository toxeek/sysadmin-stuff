#!/bin/bash

. ../chk_root.sh

if [[ ! $(which ansible) ]] ; then
    ${APT} install software-properties-common &>/dev/null
    $(which apt-add-repository) ppa:ansible/ansible &>/dev/null
    ${APT} update
    ${APT} install ansible &>/dev/null
    echo "[+] Ansible installed."
else
    echo "[+] Ansible already installed."
fi

if [ ! -f ~/.boto ]; then
    echo "[+] creating ~/.boto .."
    touch ~/.boto || echo "ansible error: unable to create ~/.boto" >&2
    echo "[+] ~/.boto created."
fi

exit 0
