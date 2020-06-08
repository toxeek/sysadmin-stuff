
# you must be root
HOME_DIERCTORY="$HOME"
[ "$UID" -ne "0" ]  && echo "[+] you need to be r00t." >&2 && exit 1
ROOT_DIR=$HOME_DIERCTORY