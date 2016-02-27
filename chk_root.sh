
# you must be root
[ "$UID" -ne "0" ]  && echo "[+] you need to be r00t." >&2 && exit 1