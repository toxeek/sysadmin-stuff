#!/bin/bash

if [ "$UID" -ne "0" ]; then
    echo "[+] you need to be r00t." >&2 && exit 1
fi

WHO=$(who am i | awk '{print $1}')
UGROUPS=$(groups $WHO | grep sudo)

[ ! -n "$UGROUPS" ] && $(which usermod) -aG "sudo" $USER


