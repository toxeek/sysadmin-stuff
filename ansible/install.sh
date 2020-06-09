#!/bin/bash

#. ../chk_root.sh

if [[ ! $(which ansible) ]] ; then
    ${APT} install ansible
    if [ $? == 0 ] ; then 
        echo "[+] Ansible installed."
    else
        echo "[+] ansible not installed"
    fi
else
    echo "[+] Ansible already installed."
fi

if [ ! -f ~/.boto ]; then
    echo "[+] creating ~/.boto .."
    touch ~/.boto || echo "ansible error: unable to create ~/.boto" >&2
    echo "[+] ~/.boto created."
fi

exit 0
