#!/bin/bash

[ "$UID" -ne "0" ] && echo "[+] you need to be r00t." >&2 && exit 1

if [[ ! $(which tmux) ]] ; then
    $APT "install" tmux &>/dev/null && echo "[+] tmux installed."
fi

# ruby and gem necessary for tmuxinator
if [[ ! $(which ruby) ]] ; then
    $APT "install" ruby rubygems &>/dev/null && echo "[+] ruby installed."
fi

if [[ ! $(which tmuxinator) ]] ; then
    $(which gem) install tmuxinator && echo "[+] tmuxinator."  
fi


