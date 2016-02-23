#!/bin/bash

. ../utils.sh

if [[ ! $(which ansible) ]] ; then
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
